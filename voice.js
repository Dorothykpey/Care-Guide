document.addEventListener('DOMContentLoaded', () => {
  const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
  const canSpeak = 'speechSynthesis' in window;
  const answerForm = document.querySelector('.answer_form');
  const consultationForm = document.querySelector('form[action="/consult"]');
  const languageField = document.querySelector('select[name="language"], input[name="language"]');
  const regionField = document.querySelector('select[name="region"]');
  const resultPanel = document.querySelector('.result');
  const careButton = document.getElementById('locate_button');
  let language = languageField?.value || document.getElementById('ai_explainer')?.dataset.language || 'en';
  let recognition;
  let listening = false;
  let currentMode = null;

  const toolbar = document.createElement('div');
  toolbar.className = 'voice_toolbar';
  toolbar.innerHTML = `
    <button type="button" id="voice_toggle" aria-pressed="false">
      <span aria-hidden="true">&#127897;</span> Enable voice conversation
    </button>
    <p id="voice_status" role="status" aria-live="polite">Voice conversation is off</p>`;
  document.body.appendChild(toolbar);
  const toggle = toolbar.querySelector('#voice_toggle');
  const status = toolbar.querySelector('#voice_status');

  const locales = {en:'en-GH', fr:'fr-FR', es:'es-ES', zh:'zh-CN', tw:'en-GH', ee:'en-GH', gaa:'en-GH', ada:'en-GH', dag:'en-GH', fat:'en-GH', ha:'ha-NG'};
  const languageLabels = {en:'English', fr:'French', es:'Spanish', zh:'Chinese', tw:'Twi', ee:'Ewe', gaa:'Ga', ada:'Dangme or Adangbe', dag:'Dagbani', fat:'Fante', ha:'Hausa'};
  const languageAliases = {
    en:['english'], fr:['french','francais'], es:['spanish','espanol'], zh:['chinese','mandarin'],
    tw:['twi','akan'], ee:['ewe','ewegbe'], gaa:['ga','gaa'], ada:['dangme','adangbe'],
    dag:['dagbani'], fat:['fante','fanti'], ha:['hausa']
  };
  const regionAliases = {
    ahafo:['ahafo'], ashanti:['ashanti'], bono:['bono'], bono_east:['bono east'],
    central:['central'], eastern:['eastern'], greater_accra:['greater accra','accra'],
    north_east:['north east','northeast'], northern:['northern'], oti:['oti'],
    savannah:['savannah','savanna'], upper_east:['upper east'], upper_west:['upper west'],
    volta:['volta'], western:['western'], western_north:['western north']
  };
  const regionLabels = Object.fromEntries(
    Object.entries(regionAliases).map(([value, aliases]) => [value, aliases[0].replace(/\b\w/g, c => c.toUpperCase())])
  );
  const yesWords = ['yes','yeah','yep','oui','si','aane','ane','eh','ee'];
  const noWords = ['no','non','dabi','daabi','ao',"a'a"];

  const normalize = text => text.toLowerCase().normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '').replace(/[^a-z0-9' ]/g, ' ').replace(/\s+/g, ' ').trim();
  const containsPhrase = (text, phrase) => phrase.includes(' ')
    ? text.includes(phrase)
    : text.split(' ').includes(phrase);
  const heardAny = (texts, choices) => texts.some(text => choices.some(choice => containsPhrase(text, choice)));
  const findChoice = (texts, choices) => {
    const candidates = Object.entries(choices).flatMap(([value, aliases]) =>
      aliases.map(alias => [value, aliases, normalize(alias)]));
    candidates.sort((a, b) => b[2].length - a[2].length);
    const match = candidates.find(([, , alias]) => texts.some(text => containsPhrase(text, alias)));
    return match ? [match[0], match[1]] : undefined;
  };
  const setStatus = message => { status.textContent = message; };

  const speak = (message, nextMode = null, locale = null, onComplete = null) => {
    if (!canSpeak) return setStatus('Speech output is unavailable in this browser.');
    currentMode = nextMode;
    speechSynthesis.cancel();
    const utterance = new SpeechSynthesisUtterance(message);
    utterance.lang = locale || locales[language] || 'en-GH';
    utterance.rate = 0.88;
    utterance.onstart = () => setStatus(`CareGuide: ${message}`);
    utterance.onend = () => {
      if (nextMode) startListening(nextMode);
      else if (onComplete) onComplete();
    };
    speechSynthesis.speak(utterance);
  };

  const askVision = () => speak(
    'Before we begin, are you blind or unable to read the screen? Please say yes or no.',
    'vision', 'en-GH'
  );

  const askLanguage = () => speak(
    'Welcome to CareGuide voice conversation. Which language do you understand? Say English, French, Spanish, Chinese, Twi, Ewe, Ga, Dangme, Dagbani, Fante, or Hausa.',
    'language', 'en-GH'
  );

  const askRegion = () => speak(
    'Thank you. Which region of Ghana are you currently in? For example, say Greater Accra, Ashanti, Volta, or the name of your region.',
    'region'
  );

  const askQuestion = () => {
    const question = document.querySelector('.result h1')?.textContent || document.querySelector('h1')?.textContent || '';
    speak(`${question}. Please say yes or no. You can also say repeat or help.`, 'answer');
  };

  const readResult = () => {
    const resultText = resultPanel?.innerText?.replace(/\s+/g, ' ').trim() || document.querySelector('h1')?.textContent || '';
    speak(`${resultText}. This is educational guidance, not a medical diagnosis. Say find hospitals, repeat result, or start again.`, 'result');
  };

  const retry = (message, mode) => speak(`${message} Please try again.`, mode);

  const handleVision = texts => {
    if (heardAny(texts, yesWords)) {
      localStorage.setItem('careguide_accessibility', 'blind');
      localStorage.setItem('careguide_voice', 'on');
      speak('Thank you. Voice conversation will guide you through the consultation.', null, 'en-GH', beginConversation);
      return;
    }
    if (heardAny(texts, noWords)) {
      localStorage.setItem('careguide_accessibility', 'visual');
      speak(
        'Thank you. Voice assistance will now stop. You can read the screen and answer the questions yourself.',
        null, 'en-GH', disableVoice
      );
      return;
    }
    retry('I did not understand. Say yes if you need voice guidance, or no if you can read the screen.', 'vision');
  };

  const handleLanguage = texts => {
    const selected = findChoice(texts, languageAliases);
    if (!selected || !languageField) return retry('I did not understand the language. Say English, French, Spanish, Chinese, Twi, Ewe, Ga, Dangme, Dagbani, Fante, or Hausa.', 'language');
    language = selected[0];
    languageField.value = language;
    languageField.dispatchEvent(new Event('change', {bubbles:true}));
    localStorage.setItem('careguide_language', language);
    speak(`${languageLabels[language]} selected.`, null);
    setTimeout(askRegion, 1200);
  };

  const handleRegion = texts => {
    const selected = findChoice(texts, regionAliases);
    if (!selected || !regionField || !consultationForm) return retry('I did not understand the region. Please say the full name of your region.', 'region');
    regionField.value = selected[0];
    regionField.dispatchEvent(new Event('change', {bubbles:true}));
    localStorage.setItem('careguide_region', selected[0]);
    speak(`${regionLabels[selected[0]]} selected. I will begin the consultation. Your browser may ask permission to use your location.`, null);
    setTimeout(() => consultationForm.requestSubmit(), 3500);
  };

  const handleAnswer = texts => {
    if (heardAny(texts, ['repeat','again'])) return askQuestion();
    if (heardAny(texts, ['help'])) return speak('Answer yes if you currently have the symptom. Answer no if you do not have it.', 'answer');
    let response;
    if (heardAny(texts, yesWords)) response = 'yes';
    else if (heardAny(texts, noWords)) response = 'no';
    if (!response) return retry('I did not understand. Say yes, no, repeat, or help.', 'answer');
    const button = answerForm?.querySelector(`button[value="${response}"]`);
    speak(`${response === 'yes' ? 'Yes' : 'No'} received. Moving to the next question.`, null);
    setTimeout(() => button?.click(), 1300);
  };

  const handleResult = texts => {
    if (heardAny(texts, ['repeat','repeat result','again'])) return readResult();
    if (heardAny(texts, ['start again','restart','new consultation'])) {
      speak('Starting a new consultation.', null);
      return setTimeout(() => { window.location.href = '/'; }, 1200);
    }
    if (heardAny(texts, ['find hospitals','find hospital','nearby care','hospital','clinic'])) {
      speak('I will request your location and show nearby healthcare facilities.', null);
      return setTimeout(() => careButton?.click(), 1400);
    }
    retry('I did not understand. Say find hospitals, repeat result, or start again.', 'result');
  };

  const handleSpeech = (mode, rawTexts) => {
    const texts = rawTexts.map(normalize);
    setStatus(`Patient: ${rawTexts[0]}`);
    if (heardAny(texts, ['stop voice','disable voice','stop listening'])) return disableVoice();
    if (mode === 'vision') handleVision(texts);
    else if (mode === 'language') handleLanguage(texts);
    else if (mode === 'region') handleRegion(texts);
    else if (mode === 'answer') handleAnswer(texts);
    else if (mode === 'result') handleResult(texts);
  };

  function startListening(mode) {
    if (!SpeechRecognition || listening || toggle.getAttribute('aria-pressed') !== 'true') return;
    currentMode = mode;
    recognition = new SpeechRecognition();
    recognition.lang = locales[language] || 'en-GH';
    recognition.interimResults = false;
    recognition.maxAlternatives = 3;
    recognition.onstart = () => {
      listening = true;
      toolbar.classList.add('listening');
      setStatus('Patient: listening...');
    };
    recognition.onresult = event => handleSpeech(mode, [...event.results[0]].map(item => item.transcript));
    recognition.onerror = event => {
      if (!['aborted','no-speech'].includes(event.error)) setStatus('Microphone unavailable. Tap voice conversation to try again.');
    };
    recognition.onend = () => {
      listening = false;
      toolbar.classList.remove('listening');
    };
    recognition.start();
  }

  const beginConversation = () => {
    if (answerForm) return askQuestion();
    if (careButton && resultPanel) return readResult();
    if (languageField?.tagName === 'SELECT' && regionField) {
      const savedLanguage = localStorage.getItem('careguide_language');
      if (savedLanguage && languageField.querySelector(`option[value="${savedLanguage}"]`)) {
        language = savedLanguage;
        languageField.value = savedLanguage;
      }
      return askLanguage();
    }
    speak(`${document.querySelector('h1')?.textContent || document.title}. Voice conversation is ready.`);
  };

  function disableVoice() {
    localStorage.removeItem('careguide_voice');
    recognition?.abort();
    speechSynthesis?.cancel();
    currentMode = null;
    toggle.setAttribute('aria-pressed', 'false');
    toggle.innerHTML = '<span aria-hidden="true">&#127897;</span> Enable voice conversation';
    setStatus('Voice conversation is off');
  }

  const enableVoice = () => {
    if (!SpeechRecognition || !canSpeak) return setStatus('Use Chrome or Edge for two-way voice conversation.');
    toggle.setAttribute('aria-pressed', 'true');
    toggle.innerHTML = '<span aria-hidden="true">&#128266;</span> End voice conversation';
    askVision();
  };

  toggle.addEventListener('click', () => toggle.getAttribute('aria-pressed') === 'true' ? disableVoice() : enableVoice());
  if (localStorage.getItem('careguide_voice') === 'on' &&
      localStorage.getItem('careguide_accessibility') === 'blind') {
    toggle.setAttribute('aria-pressed', 'true');
    toggle.innerHTML = '<span aria-hidden="true">&#128266;</span> End voice conversation';
    setTimeout(beginConversation, 650);
  } else {
    localStorage.removeItem('careguide_voice');
  }
});
