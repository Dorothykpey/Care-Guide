document.addEventListener('DOMContentLoaded', () => {
  const panel = document.getElementById('ai_explainer');
  const button = document.getElementById('ai_explain_button');
  const output = document.getElementById('ai_explanation');
  if (!panel || !button || !output) return;

  const readResponse = async response => {
    const text = await response.text();
    try {
      return JSON.parse(text);
    } catch {
      return {error: text || `Local AI request failed with status ${response.status}.`};
    }
  };

  button.addEventListener('click', async () => {
    button.disabled = true;
    output.textContent = 'Preparing a clear explanation...';
    try {
      const response = await fetch('/llm/explain', {
        method: 'POST',
        cache: 'no-store',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
          disease: panel.dataset.disease,
          advice: panel.dataset.advice,
          specialist: panel.dataset.specialist,
          language: panel.dataset.language
        })
      });
      const data = await readResponse(response);
      if (!response.ok) throw new Error(data.error || 'The local AI could not respond.');
      output.textContent = data.explanation;
      if (localStorage.getItem('careguide_voice') === 'on' && 'speechSynthesis' in window) {
        speechSynthesis.cancel();
        speechSynthesis.speak(new SpeechSynthesisUtterance(data.explanation));
      }
    } catch (error) {
      output.textContent = error.message === 'Failed to fetch'
        ? 'The web app could not reach its local AI service. Confirm that the Prolog server is running, then try again.'
        : error.message;
    } finally {
      button.disabled = false;
    }
  });
});
