:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_files)).
:- use_module(library(http/html_write)).
:- use_module(library(lists)).

:- consult('diseases_diagnosis.pl').
:- consult('translations.pl').

:- http_handler(root(.), home, []).
:- http_handler(root(consult), begin_consultation, []).
:- http_handler(root(setup), setup_page, []).
:- http_handler(root(answer), answer_request, [method(post)]).
:- http_handler(root(diagnose), diagnose_request, [method(post)]).
:- http_handler(root('style.css'), stylesheet, []).
:- http_handler(root('theme.css'), theme_stylesheet, []).
:- http_handler(root('distance.js'), distance_script, []).
:- http_handler(root('carousel.js'), carousel_script, []).
:- http_handler(root('background-carousel.js'), background_carousel_script, []).
:- http_handler(root('hospital-background.png'), hospital_background, []).
:- http_handler(root('hospital-background-2.png'), hospital_background_2, []).
:- http_handler(root('hospital-background-3.png'), hospital_background_3, []).
:- http_handler(root('hospital-background-4.jpg'), hospital_background_4, []).
:- http_handler(root('manifest.webmanifest'), manifest_file, []).
:- http_handler(root('pwa.js'), pwa_script, []).
:- http_handler(root('sw.js'), service_worker, []).
:- http_handler(root('app-icon.svg'), app_icon, []).

start :- start(8080).

start(Port) :-
    http_server(http_dispatch, [port(Port)]),
    format('Disease Diagnosis web app: http://localhost:~w/~n', [Port]).

run :-
    current_prolog_flag(argv, Arguments),
    ( Arguments = [PortAtom|_], atom_number(PortAtom, Port) -> true ; Port = 8080 ),
    start(Port),
    thread_get_message(stop).

home(_Request) :-
    reply_html_page(
        [ title('Disease Diagnosis System'),
          meta([name(viewport), content('width=device-width, initial-scale=1, viewport-fit=cover')]),
          meta([name('theme-color'), content('#e7f6fa')]),
          meta([name('apple-mobile-web-app-capable'), content(yes)]),
          link([rel(manifest), href('/manifest.webmanifest')], []),
          link([rel(icon), href('/app-icon.svg'), type('image/svg+xml')], []),
          link([rel(stylesheet), href('/style.css')], []),
          link([rel(stylesheet), href('/theme.css')], []),
          script([src('/carousel.js'), defer], []),
          script([src('/background-carousel.js'), defer], []),
          script([src('/pwa.js'), defer], [])
        ],
        [ div(class(landing_page),
              [ nav(class(top_nav),
                    [ a([href('/'), class(brand)],
                        [span(class(brand_mark), '\u271A'), span('Care'), strong('Guide')]),
                      div(class(nav_links),
                          [a([href('#assessment')], 'Assessment'),
                           a([href('#how')], 'How it works'),
                           a([href('#safety')], 'Safety'),
                           a([href('#coverage')], 'Coverage')]),
                      button([type(button), id(install_app), class(install_action), hidden], 'Install app'),
                      a([href('#assessment'), class(nav_action)], 'Start check')
                    ]),
                main(class(hero),
                     [ div(class(hero_copy),
                           [ div(class(eyebrow), [span('\u2022'), ' CHECK SMARTER. FIND CARE FASTER.']),
                             h1([span('Understand Symptoms.'), br([]),
                                 span('Find the Right Care.'), br([]),
                                 span('Act Sooner.')]),
                             p(class(hero_intro),
                               'Answer guided symptom questions, identify an appropriate specialist, and find nearby healthcare facilities across all 16 regions of Ghana.'),
                             div([id(how), class(feature_line)],
                                 [span('\u2713 Guided questions'), span('\u2713 Regional facilities'), span('\u2713 Distance estimates')])
                           ]),
                       form([action('/consult'), method(get), id(assessment), class(hero_form)],
                            [ h2('Start your health check'),
                              p('Choose your preferences before beginning.'),
                              div(class(form_grid),
                                  [ div([label([for(language)], 'Language'),
                                         select([name(language), id(language), required], \language_options)]),
                                    div([label([for(region)], 'Region'),
                                         select([name(region), id(region), required], \region_options)])
                                  ]),
                              label([for(address)], 'House address or GhanaPost GPS address'),
                              input([type(text), name(address), id(address), required,
                                     minlength(5), autocomplete('street-address'),
                                     placeholder('Example: GA-123-4567 or street and town')]),
                              p([id(safety), class(privacy_note)],
                                'Your address is used only to locate nearby care and is not saved.'),
                              button([type(submit)], 'Begin consultation \u2192')
                            ]),
                       div([id(coverage), class(hero_disclaimer)],
                           'Educational guidance only. For severe or urgent symptoms, contact emergency services immediately.')
                     ])
              ])
        ]).

setup_page(_Request) :-
    reply_html_page(
        [ title('Consultation setup'),
          meta([name(viewport), content('width=device-width, initial-scale=1, viewport-fit=cover')]),
          meta([name('theme-color'), content('#e7f6fa')]),
          link([rel(manifest), href('/manifest.webmanifest')], []),
          link([rel(stylesheet), href('/style.css')], []),
          link([rel(stylesheet), href('/theme.css')], []),
          script([src('/background-carousel.js'), defer], []),
          script([src('/pwa.js'), defer], [])
        ],
        [ div(class(container),
              [ a([href('/')], '\u2190 Back to home'),
                h1('Consultation setup'),
                p('Choose your language and region, then provide an address so nearby facilities can be estimated.'),
                form([action('/consult'), method(get), class(setup_form)],
                     [ label([for(language)], 'Language'),
                       select([name(language), id(language), required], \language_options),
                       label([for(region)], 'Region'),
                       select([name(region), id(region), required], \region_options),
                       label([for(address)], 'House address or GhanaPost GPS address'),
                       input([type(text), name(address), id(address), required,
                              minlength(5), autocomplete('street-address'),
                              placeholder('Example: GA-123-4567 or street and town')]),
                       p(class(privacy_note), 'Your address is used only to locate nearby care and is not saved.'),
                       button([type(submit)], 'Continue to symptom questions \u2192')
                     ])
              ])
        ]).

language_options -->
    html([ option([value(en)], 'English'),
           option([value(fr)], 'Français'),
           option([value(es)], 'Español')
         ]).

region_options -->
    html([ option([value(ahafo)], 'Ahafo'),
           option([value(ashanti)], 'Ashanti'),
           option([value(bono)], 'Bono'),
           option([value(bono_east)], 'Bono East'),
           option([value(central)], 'Central'),
           option([value(eastern)], 'Eastern'),
           option([value(greater_accra)], 'Greater Accra'),
           option([value(north_east)], 'North East'),
           option([value(northern)], 'Northern'),
           option([value(oti)], 'Oti'),
           option([value(savannah)], 'Savannah'),
           option([value(upper_east)], 'Upper East'),
           option([value(upper_west)], 'Upper West'),
           option([value(volta)], 'Volta'),
           option([value(western)], 'Western'),
           option([value(western_north)], 'Western North')
         ]).

begin_consultation(Request) :-
    http_parameters(Request,
                    [ region(Region, [oneof([ahafo, ashanti, bono, bono_east, central, eastern, greater_accra, north_east, northern, oti, savannah, upper_east, upper_west, volta, western, western_north])]),
                      language(Language, [oneof([en, fr, es])])
                      ,address(Address, [string, length >= 5])
                    ]),
    next_step([], [], Region, Language, Address).

answer_request(Request) :-
    http_parameters(Request,
                    [ symptom(Symptom, [atom]),
                      response(Response, [oneof([yes, no])]),
                      yes(YesAtom, [atom, default('')]),
                      no(NoAtom, [atom, default('')]),
                      region(Region, [oneof([ahafo, ashanti, bono, bono_east, central, eastern, greater_accra, north_east, northern, oti, savannah, upper_east, upper_west, volta, western, western_north])]),
                      language(Language, [oneof([en, fr, es])])
                      ,address(Address, [string, length >= 5])
                    ]),
    decode_answers(YesAtom, Yes0),
    decode_answers(NoAtom, No0),
    ( Response == yes -> sort([Symptom|Yes0], Yes), No = No0
    ; sort([Symptom|No0], No), Yes = Yes0
    ),
    next_step(Yes, No, Region, Language, Address).

next_step(Yes, No, Region, Language, Address) :-
    disease(Disease, Required, Advice, Specialist),
    \+ (member(S, Required), memberchk(S, No)),
    ( subset(Required, Yes) ->
        findall(facility(Category, Name, Details),
                hospital(Region, Category, Name, Details), Facilities),
        result_page(Disease, Advice, Specialist, Region, Facilities, Language, Address)
    ; member(Symptom, Required),
      \+ memberchk(Symptom, Yes),
      \+ memberchk(Symptom, No), !,
      question_page(Symptom, Yes, No, Region, Language, Address)
    ), !.
next_step(_, _, Region, Language, Address) :-
    findall(facility(Category, Name, Details),
            hospital(Region, Category, Name, Details), Facilities),
    diagnosis([], Disease, Advice, Specialist),
    result_page(Disease, Advice, Specialist, Region, Facilities, Language, Address).

question_page(Symptom, Yes, No, Region, Language, Address) :-
    localized_symptom(Language, Symptom, Label),
    ui_text(Language, question_prefix, QuestionPrefix),
    ui_text(Language, answered, AnsweredText),
    ui_text(Language, yes, YesText),
    ui_text(Language, no, NoText),
    ui_text(Language, cancel, CancelText),
    encode_answers(Yes, YesAtom),
    encode_answers(No, NoAtom),
    length(Yes, YesCount), length(No, NoCount), Answered is YesCount + NoCount,
    reply_html_page(
        [ title('Symptom question'),
          meta([name(viewport), content('width=device-width, initial-scale=1, viewport-fit=cover')]),
          meta([name('theme-color'), content('#e7f6fa')]),
          link([rel(manifest), href('/manifest.webmanifest')], []),
          link([rel(stylesheet), href('/style.css')], []),
          link([rel(stylesheet), href('/theme.css')], []),
          script([src('/background-carousel.js'), defer], []),
          script([src('/pwa.js'), defer], [])
        ],
        [ div(class(container),
              [ a([href('/')], ['\u2190 ', CancelText]),
                div(class(result),
                    [ p(class(category), [AnsweredText, ': ', Answered]),
                      h1([QuestionPrefix, ' ', Label, '?']),
                      p('Choose the answer that best describes how you feel.'),
                      form([action('/answer'), method(post), class(answer_form)],
                           [ input([type(hidden), name(symptom), value(Symptom)]),
                             input([type(hidden), name(yes), value(YesAtom)]),
                             input([type(hidden), name(no), value(NoAtom)]),
                             input([type(hidden), name(region), value(Region)]),
                             input([type(hidden), name(language), value(Language)]),
                             input([type(hidden), name(address), value(Address)]),
                             button([type(submit), name(response), value(yes)], YesText),
                             button([type(submit), name(response), value(no), class(no_button)], NoText)
                           ])
                    ]),
                div(class(notice), 'If symptoms are severe or urgent, stop and seek immediate medical care.')
              ])
        ]).

encode_answers([], '').
encode_answers(Answers, Atom) :- Answers \= [], atomic_list_concat(Answers, ',', Atom).

decode_answers('', []) :- !.
decode_answers(Atom, Answers) :- atomic_list_concat(Answers, ',', Atom).

localized_symptom(Language, Symptom, Label) :-
    symptom_text(Language, Symptom, Label), !.
localized_symptom(_, Symptom, Label) :- human_label(Symptom, Label).

symptom_options([]) --> [].
symptom_options([Symptom|Rest]) -->
    { human_label(Symptom, Label) },
    html(label(class(symptom),
               [input([type(checkbox), name(symptom), value(Symptom)]), Label])),
    symptom_options(Rest).

diagnose_request(Request) :-
    http_parameters(Request,
                    [ symptom(Selected, [list(atom), default([])]),
                      region(Region, [oneof([greater_accra, ashanti, volta])])
                    ]),
    diagnosis(Selected, Disease, Advice, Specialist),
    findall(facility(Category, Name, Details),
            hospital(Region, Category, Name, Details), Facilities),
    result_page(Disease, Advice, Specialist, Region, Facilities, en, '').

diagnosis(Selected, Disease, Advice, Specialist) :-
    findall(Count-result(D, A, S),
            ( disease(D, Required, A, S),
              subset(Required, Selected),
              length(Required, Count)
            ), Matches),
    Matches \= [], !,
    keysort(Matches, Sorted),
    reverse(Sorted, [_-result(Disease, Advice, Specialist)|_]).
diagnosis(_, unknown_disease,
          'The selected symptoms do not clearly match this small knowledge base. Please consult a medical professional.',
          'General Practitioner (GP) / Emergency Physician').

result_page(Disease, Advice, Specialist, Region, Facilities, Language, Address) :-
    human_label(Disease, DiseaseLabel),
    human_label(Region, RegionLabel),
    localized_advice(Language, Disease, Advice, DisplayAdvice),
    ui_text(Language, result, ResultText),
    ui_text(Language, specialist, SpecialistText),
    ui_text(Language, guidance, GuidanceText),
    ui_text(Language, facilities, FacilitiesText),
    reply_html_page(
        [ title('Diagnosis result'),
          meta([name(viewport), content('width=device-width, initial-scale=1, viewport-fit=cover')]),
          meta([name('theme-color'), content('#e7f6fa')]),
          link([rel(manifest), href('/manifest.webmanifest')], []),
          link([rel(stylesheet), href('/style.css')], []),
          link([rel(stylesheet), href('/theme.css')], []),
          script([src('/distance.js'), defer], []),
          script([src('/background-carousel.js'), defer], []),
          script([src('/pwa.js'), defer], [])
        ],
        [ div(class(container),
              [ a([href('/')], '\u2190 Start again'),
                h1(ResultText),
                div(class(result),
                    [ h2(DiseaseLabel),
                      p([strong([SpecialistText, ': ']), Specialist]),
                      p([strong([GuidanceText, ': ']), DisplayAdvice])
                    ]),
                div([id(address_verification), data_address(Address), data_region(Region)],
                    [ h2('Verify your address to see nearby facilities'),
                      p(['Address entered: ', Address]),
                      button([type(button), id(locate_button)], 'Verify address and find nearby care'),
                      p([id(location_status), class(category)],
                        'Your address is not stored. Verification uses an external map service.')
                    ]),
                section([id(facilities_section), hidden],
                    [ h2([FacilitiesText, ' ', RegionLabel]),
                      div(class(emergency_contact),
                          [strong('Medical emergency? '), 'Call Ghana emergency services: ',
                           a([href('tel:112')], '112')]),
                      div(class(facilities), \facility_cards(Facilities))
                    ]),
                div(class(notice),
                    ['This result is informational and cannot replace examination, testing, or advice from a licensed professional.'])
              ])
        ]).

facility_cards([]) --> html(p('No facilities are listed for this region.')).
facility_cards([facility(Category, Name, Details)|Rest]) -->
    { facility_coordinates(Name, Latitude, Longitude) },
    html(article([class(facility), data_name(Name), data_lat(Latitude), data_lon(Longitude)],
                 [ h3(Name), p(class(category), Category), p(Details),
                   \facility_contact(Name),
                   p(class(distance), 'Distance estimate not calculated.'),
                   a([class(directions), target('_blank'), rel(noopener)], 'Open live directions')
                 ])),
    facility_cards(Rest).

facility_contact(Name) -->
    { facility_phone(Name, Display, Dial),
      atom_concat('tel:', Dial, TelephoneLink)
    }, !,
    html(p(class(phone), [strong('Call: '), a([href(TelephoneLink)], Display)])).
facility_contact(_) -->
    html(p(class(phone_unverified), 'Telephone number not reliably verified.')).

% Public contacts verified from hospital or Ghana government sources.
facility_phone('Greater Accra Regional Hospital (Ridge)', '030 242 8477', '+233302428477').
facility_phone('Tema General Hospital', '030 330 2696', '+233303302696').
facility_phone('Nyaho Medical Centre', '030 708 6490', '+233307086490').
facility_phone('Narh-Bita Hospital', '050 712 0084', '+233507120084').
facility_phone('Korle-Bu Fevers Unit / Dental School Clinic', '030 266 7759', '+233302667759').
facility_phone('Komfo Anokye Teaching Hospital', '055 649 0029', '+233556490029').
facility_phone('Ho Teaching Hospital (Trafalgar / Trafaga)', '020 624 1929', '+233206241929').
facility_phone('Ho Royal Hospital', '020 893 8966', '+233208938966').
facility_phone('Cape Coast Teaching Hospital', '055 477 6225 (Emergency)', '+233554776225').
facility_phone('Baptist Medical Centre', '050 927 9608 (24/7 emergency)', '+233509279608').
facility_phone('Tamale Teaching Hospital', '059 185 4221', '+233591854221').
facility_phone('Holy Family Hospital', '020 221 9048', '+233202219048').
facility_phone('Upper East Regional Hospital', '038 202 2461', '+233382022461').
facility_phone('Upper West Regional Hospital', '020 004 1573', '+233200041573').

% Approximate facility coordinates used only for initial distance estimates.
facility_coordinates('Greater Accra Regional Hospital (Ridge)', 5.56162, -0.19868).
facility_coordinates('Tema General Hospital', 5.67422, -0.02516).
facility_coordinates('Nyaho Medical Centre', 5.60581, -0.18160).
facility_coordinates('Narh-Bita Hospital', 5.66940, -0.01920).
facility_coordinates('Korle-Bu Fevers Unit / Dental School Clinic', 5.53637, -0.22716).
facility_coordinates('Komfo Anokye Teaching Hospital', 6.69680, -1.62980).
facility_coordinates('MaxMedical Clinic', 6.66510, -1.62010).
facility_coordinates('Sunsite Diagnostics', 6.68850, -1.62440).
facility_coordinates('Ho Teaching Hospital (Trafalgar / Trafaga)', 6.60122, 0.48451).
facility_coordinates('Ho Royal Hospital', 6.61230, 0.47180).
facility_coordinates('Ho Municipal Hospital', 6.60800, 0.46850).
facility_coordinates('Goaso Municipal Hospital', 6.80360, -2.51720).
facility_coordinates('Bono Regional Hospital', 7.33990, -2.32680).
facility_coordinates('Holy Family Hospital', 7.58590, -1.93910).
facility_coordinates('Cape Coast Teaching Hospital', 5.13380, -1.27870).
facility_coordinates('Eastern Regional Hospital', 6.09410, -0.25910).
facility_coordinates('Baptist Medical Centre', 10.52710, -0.36980).
facility_coordinates('Tamale Teaching Hospital', 9.40750, -0.85650).
facility_coordinates('Worawora Government Hospital', 7.50240, 0.37810).
facility_coordinates('West Gonja Hospital', 9.08300, -1.81840).
facility_coordinates('Upper East Regional Hospital', 10.78560, -0.85140).
facility_coordinates('Upper West Regional Hospital', 10.06010, -2.50190).
facility_coordinates('Effia Nkwanta Regional Hospital', 4.92770, -1.77410).
facility_coordinates('Sefwi Wiawso Municipal Hospital', 6.20570, -2.48920).

all_symptoms(Symptoms) :-
    findall(Symptom, (disease(_, Required, _, _), member(Symptom, Required)), Raw),
    sort(Raw, Symptoms).

human_label(Atom, Label) :-
    atomic_list_concat(Words, '_', Atom),
    atomic_list_concat(Words, ' ', Lower),
    atom_chars(Lower, [First|Rest]),
    upcase_atom(First, Upper),
    atom_chars(Label, [Upper|Rest]).

stylesheet(_Request) :-
    format('Content-type: text/css; charset=UTF-8~n~n'),
    format('~s', [":root{font-family:Inter,Segoe UI,system-ui,sans-serif;color:#172b3a;background:#dcecf2}*{box-sizing:border-box}body{min-height:100vh;margin:0;background:#dcecf2}body:before{content:'';position:fixed;inset:0;pointer-events:none;background:linear-gradient(110deg,#eaf5f76b 0%,#dcecf052 48%,#b7d6df3d 100%);z-index:-1}.background_carousel{position:fixed;inset:0;z-index:-2;overflow:hidden}.background_slide{position:absolute;inset:0;background-size:cover;background-position:center;background-repeat:no-repeat;opacity:0;transform:scale(1.045);transition:opacity 1.6s ease,transform 7s ease}.background_slide.active{opacity:1;transform:scale(1)}.container{max-width:900px;margin:3rem auto;padding:0 1.2rem;text-shadow:0 1px 3px #fff,0 0 12px #ffffffdd}header{margin-bottom:1.5rem}h1{color:#075985;letter-spacing:-.025em}h2,h3{color:#163b50}.notice{background:transparent;border:0;padding:.5rem 0;margin:1rem 0;border-radius:0;box-shadow:none;backdrop-filter:none}form,.result,article{background:transparent;padding:.7rem 0;border:0;border-radius:0;box-shadow:none;backdrop-filter:none;-webkit-backdrop-filter:none}.carousel{position:relative;margin:0 0 1rem;overflow:hidden;border-radius:0}.carousel_track{display:grid}.carousel_slide{grid-area:1/1;min-height:132px;padding:1rem 4rem 1.35rem;display:flex;flex-direction:column;justify-content:center;opacity:0;visibility:hidden;transform:translateX(24px);transition:opacity .45s ease,transform .45s ease,visibility .45s;background:transparent;border:0;box-shadow:none;backdrop-filter:none}.carousel_slide.active{opacity:1;visibility:visible;transform:none}.carousel_slide p{max-width:620px;margin:.2rem 0;font-size:.88rem;line-height:1.4}.carousel_slide h2{margin:.1rem 0;font-size:1.2rem}.carousel_slide .category{font-size:.72rem;letter-spacing:.04em}.carousel_controls{position:absolute;inset:0;display:flex;align-items:center;justify-content:space-between;pointer-events:none;padding:.4rem}.carousel_controls button{pointer-events:auto}.carousel_prev,.carousel_next{width:32px;height:32px;margin:0;padding:0;border-radius:50%;font-size:1.35rem;line-height:1}.carousel_dots{position:absolute;left:50%;bottom:8px;display:flex;gap:6px;transform:translateX(-50%)}.carousel_dot{width:7px;height:7px;margin:0;padding:0;border-radius:50%;background:#8eabb8;box-shadow:none}.carousel_dot.active{background:#075985;transform:scale(1.2)}fieldset{border:0;padding:0;margin:0 0 1.2rem}legend{font-size:1.25rem;font-weight:700;margin-bottom:.8rem}.symptoms{display:grid;grid-template-columns:repeat(auto-fit,minmax(210px,1fr));gap:.65rem}.symptom{background:transparent;padding:.65rem 0;border:0;border-radius:0}.symptom input{margin-right:.55rem}select,input[type=text],button{display:block;width:100%;padding:.85rem;margin:.55rem 0 1rem;border-radius:9px;border:1px solid #8daab8;text-shadow:none}select,input[type=text]{background:#ffffffc4;color:#172b3a}button{background:linear-gradient(135deg,#0878ad,#075985);color:white;border:0;font-weight:700;cursor:pointer;box-shadow:0 7px 18px #07598535;transition:transform .18s ease,box-shadow .18s ease}button:hover{transform:translateY(-1px);box-shadow:0 10px 23px #07598545}.no_button{background:linear-gradient(135deg,#64748b,#475569)}.facilities{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:1rem}.category{color:#024f7a;font-weight:700}a{color:#064f73;font-weight:700;text-decoration:none}a:hover{text-decoration:underline}@media(prefers-reduced-motion:reduce){.background_slide{transition:none;transform:none}}@media(max-width:600px){.background_slide{background-position:62% center}.container{margin:1.5rem auto}.result,form,article{padding:.5rem 0}h1{font-size:1.8rem}.carousel_slide{padding:.85rem 2.9rem 1.25rem;min-height:150px}.carousel_slide h2{font-size:1.08rem}.carousel_slide p{font-size:.82rem}}"]),
    format('~s', [".landing_page{min-height:100vh;color:#f8fafc;background:linear-gradient(90deg,#07111ee8 0%,#0c1928c9 48%,#14243880 100%);text-shadow:none}.top_nav{height:92px;padding:0 clamp(1.5rem,5vw,6rem);display:flex;align-items:center;gap:2.5rem;background:#101b2beF;border-bottom:1px solid #ffffff12;position:relative;z-index:5}.brand{display:flex;align-items:center;color:#f8fafc;font-size:1.55rem;font-weight:800;letter-spacing:-.04em;white-space:nowrap}.brand strong{color:#22c7a9}.brand_mark{display:grid;place-items:center;width:44px;height:44px;margin-right:.65rem;border:1px solid #22c7a966;border-radius:12px;color:#22c7a9;background:#07111e}.nav_links{display:flex;align-items:center;gap:2.25rem;margin-left:auto}.nav_links a{color:#a9b5c6;font-weight:600}.nav_links a:hover{color:#fff;text-decoration:none}.nav_action{width:auto;padding:.8rem 1.35rem;border:1px solid #22c7a977;border-radius:10px;color:#fff;background:#22c7a91c}.hero{min-height:calc(100vh - 92px);padding:clamp(3rem,7vw,7rem) clamp(1.5rem,5vw,6rem) 2rem;display:grid;grid-template-columns:minmax(0,1.25fr) minmax(330px,.65fr);align-items:center;gap:clamp(2.5rem,6vw,7rem);position:relative}.hero_copy{max-width:850px}.eyebrow{display:inline-flex;gap:.7rem;align-items:center;padding:.65rem 1.15rem;border:1px solid #22c7a977;border-radius:999px;color:#5eead4;font-size:.78rem;font-weight:800;letter-spacing:.14em}.eyebrow span{font-size:1.3rem}.hero h1{margin:1.8rem 0 1.2rem;color:#fff;font-size:clamp(3rem,5.7vw,6.5rem);line-height:.94;letter-spacing:-.065em}.hero_intro{max-width:700px;color:#c1ccda;font-size:1.12rem;line-height:1.75}.feature_line{display:flex;flex-wrap:wrap;gap:1.4rem;margin-top:1.4rem;color:#d8e2ec;font-size:.88rem}.hero_form{padding:1.6rem!important;background:#111d2be6!important;border:1px solid #ffffff1c!important;border-radius:16px!important;box-shadow:0 24px 65px #0007!important;backdrop-filter:blur(16px)!important}.hero_form h2{margin:0;color:#fff;font-size:1.45rem}.hero_form>p{margin:.4rem 0 1.1rem;color:#9eacbd}.hero_form label{color:#dce5ef;font-size:.78rem;font-weight:700;text-transform:uppercase;letter-spacing:.06em}.hero_form select,.hero_form input[type=text]{background:#1b2939;color:#f8fafc;border:1px solid #405064;margin-top:.35rem}.hero_form button{margin-bottom:.4rem;background:linear-gradient(135deg,#20b99e,#0f8c7b);font-size:1rem}.form_grid{display:grid;grid-template-columns:1fr 1fr;gap:.8rem}.privacy_note{color:#95a5b6!important;font-size:.76rem;line-height:1.45}.hero_disclaimer{position:absolute;left:clamp(1.5rem,5vw,6rem);bottom:1.2rem;color:#93a4b6;font-size:.75rem}.landing_page .background_slide{filter:saturate(.82)}@media(max-width:900px){.nav_links{display:none}.nav_action{margin-left:auto}.hero{grid-template-columns:1fr;padding-top:3rem;padding-bottom:4rem}.hero h1{font-size:clamp(3rem,11vw,5.5rem)}.hero_form{max-width:620px}.hero_disclaimer{position:static;grid-column:1}}@media(max-width:560px){.top_nav{height:76px;padding:0 1rem}.brand{font-size:1.25rem}.brand_mark{width:38px;height:38px}.nav_action{font-size:.8rem;padding:.65rem .8rem}.hero{min-height:calc(100vh - 76px);padding:2rem 1rem 3rem}.hero h1{font-size:2.75rem}.eyebrow{font-size:.62rem;padding:.55rem .8rem}.form_grid{grid-template-columns:1fr}}"]),
    format('~s', [".background_controls{position:fixed;right:clamp(1rem,3vw,3rem);bottom:calc(1.1rem + env(safe-area-inset-bottom));z-index:20;display:flex;align-items:center;gap:.5rem;padding:.3rem .45rem;border:1px solid #ffffff26;border-radius:999px;background:#0b1624a8;backdrop-filter:blur(8px)}.background_controls button{margin:0;padding:0;width:29px;height:29px;border-radius:50%;display:grid;place-items:center;background:#ffffff17;border:1px solid #ffffff24;color:#fff;box-shadow:none;font-size:1.05rem}.background_controls button:hover{background:#22c7a9;transform:none}.background_dots{display:flex;gap:.35rem}.background_dots .background_dot{width:6px;height:6px;border:0;background:#ffffff66}.background_dots .background_dot.active{width:18px;border-radius:8px;background:#22c7a9}.hero_form{padding:1.35rem!important;background:transparent!important;border:0!important;border-radius:0!important;box-shadow:none!important;backdrop-filter:none!important;-webkit-backdrop-filter:none!important;text-shadow:0 2px 8px #000,0 0 18px #07111e}.hero_form h2{font-size:1.25rem}.hero_form>p{font-size:.84rem;margin:.35rem 0 1rem;color:#dbe5ef}.privacy_note{font-size:.68rem!important;margin:.65rem 0 0;color:#d6e0e9!important}.setup_form{max-width:620px;margin-top:1.25rem}.eyebrow{padding:.48rem .82rem;font-size:.67rem}.nav_action{padding:.62rem 1rem;font-size:.85rem;border-radius:8px}.install_action{display:block;width:auto;margin:0;padding:.62rem 1rem;border-radius:8px;background:#20b99e;color:#fff;box-shadow:none;font-size:.85rem;white-space:nowrap}.install_action[hidden]{display:none}@media(max-width:560px){.top_nav{padding-left:max(1rem,env(safe-area-inset-left));padding-right:max(1rem,env(safe-area-inset-right))}.nav_action{display:none}.install_action{margin-left:auto;min-height:42px}.background_controls{right:max(.75rem,env(safe-area-inset-right));bottom:calc(.6rem + env(safe-area-inset-bottom))}.background_controls button{width:30px;height:30px}.hero{padding-left:max(1rem,env(safe-area-inset-left));padding-right:max(1rem,env(safe-area-inset-right))}.hero_form{padding:1rem 0!important}.hero_form select,.hero_form input[type=text],.hero_form button{min-height:46px;font-size:16px}}"]).

theme_stylesheet(_Request) :-
    format('Content-type: text/css; charset=UTF-8~n~n'),
    format('~s', ["body:before{background:linear-gradient(110deg,#f7fcfdb5 0%,#e7f6fab0 48%,#cfeaf394 100%)}.background_carousel{z-index:0}.landing_page,.container{position:relative;z-index:2}.landing_page{color:#17364a;background:linear-gradient(90deg,#f8fcfd9c 0%,#e5f5f889 48%,#d2edf35c 100%)}body:has(.landing_page):before{z-index:1;background:linear-gradient(90deg,#eef9fc4a 0%,#e4f5f83d 55%,transparent 100%)}.top_nav{background:#f8fcf4d4;border-bottom:1px solid #9ccbd74d;box-shadow:0 5px 22px #2b607216}.brand{color:#12344a}.brand strong{color:#148aa0}.brand_mark{color:#148aa0;background:#eaf8fb;border-color:#42a9bb70}.nav_links a{color:#527080}.nav_links a:hover{color:#0f526b}.nav_action{color:#0d6078;background:#e3f5f8;border-color:#44a9ba88}.hero h1{color:#12344a;text-shadow:0 2px 12px #fff}.hero_intro{color:#355b6d}.feature_line{color:#284e61}.eyebrow{color:#087b91;background:#ffffff78;border-color:#3aa2b58a}.hero_form{color:#17364a!important;text-shadow:0 1px 8px #fff!important}.hero_form h2{color:#123f55}.hero_form>p{color:#3f6172!important}.hero_form label{color:#214f63}.hero_form select,.hero_form input[type=text]{background:#ffffffd9;color:#17364a;border-color:#7db6c5}.privacy_note{color:#416777!important}.hero_disclaimer{color:#456979}.background_controls{background:#f6fcf4c7;border-color:#82bac799;box-shadow:0 8px 25px #25596b22}.background_controls button{color:#176a80;background:#ffffffc9;border-color:#72aebc88}.background_controls button:hover{color:#fff;background:#2399ad}.background_dots .background_dot{background:#77a9b5}.background_dots .background_dot.active{background:#168ca2}.install_action{background:#168ca2}.container{color:#183b4d;text-shadow:0 1px 8px #fff}.container h1,.container h2,.container h3{color:#124d66}.category,a{color:#12677f}.phone a{display:inline-block;padding:.35rem .65rem;border-radius:7px;background:#daf3f7;color:#075f75;text-shadow:none}.phone_unverified{color:#6b7280;font-size:.82rem}.emergency_contact{margin:.75rem 0 1rem;padding:.8rem 1rem;border-left:4px solid #dc2626;background:#fff7f7d9;border-radius:8px;text-shadow:none}.emergency_contact a{font-size:1.15rem;color:#b91c1c;text-decoration:underline}.answer_form{display:flex;flex-wrap:wrap;gap:.75rem;align-items:center}.answer_form input[type=hidden]{display:none}.answer_form button{width:112px;min-height:44px;margin:.4rem 0;padding:.6rem 1rem}.answer_form .no_button{width:112px}@media(max-width:420px){.answer_form button,.answer_form .no_button{width:100px}}"]).

background_carousel_script(_Request) :-
    format('Content-type: application/javascript; charset=UTF-8~n~n'),
    format('~s', ["document.addEventListener('DOMContentLoaded',()=>{const urls=['/hospital-background.png','/hospital-background-2.png','/hospital-background-3.png','/hospital-background-4.jpg'],root=document.createElement('div');root.className='background_carousel';root.setAttribute('aria-hidden','true');urls.forEach((url,index)=>{const slide=document.createElement('div');slide.className='background_slide'+(index===0?' active':'');slide.style.backgroundImage=`url('${url}')`;root.appendChild(slide);const preload=new Image();preload.src=url});document.body.prepend(root);const slides=[...root.children];let current=0,timer;const controls=document.createElement('div');controls.className='background_controls';controls.innerHTML=`<button type=\"button\" class=\"background_prev\" aria-label=\"Previous hospital image\">&#8249;</button><div class=\"background_dots\">${urls.map((_,i)=>`<button type=\"button\" class=\"background_dot${i===0?' active':''}\" aria-label=\"Show hospital image ${i+1}\"></button>`).join('')}</div><button type=\"button\" class=\"background_next\" aria-label=\"Next hospital image\">&#8250;</button>`;if(document.querySelector('.landing_page'))document.body.appendChild(controls);const dots=[...controls.querySelectorAll('.background_dot')];const show=i=>{current=(i+slides.length)%slides.length;slides.forEach((slide,n)=>slide.classList.toggle('active',n===current));dots.forEach((dot,n)=>dot.classList.toggle('active',n===current))};const play=()=>{if(window.matchMedia('(prefers-reduced-motion: reduce)').matches)return;clearInterval(timer);timer=setInterval(()=>show(current+1),7000)};controls.querySelector('.background_prev').addEventListener('click',()=>{show(current-1);play()});controls.querySelector('.background_next').addEventListener('click',()=>{show(current+1);play()});dots.forEach((dot,i)=>dot.addEventListener('click',()=>{show(i);play()}));controls.addEventListener('mouseenter',()=>clearInterval(timer));controls.addEventListener('mouseleave',play);play()});"]).

carousel_script(_Request) :-
    format('Content-type: application/javascript; charset=UTF-8~n~n'),
    format('~s', ["document.addEventListener('DOMContentLoaded',()=>{const root=document.querySelector('.carousel');if(!root)return;const slides=[...root.querySelectorAll('.carousel_slide')],dots=[...root.querySelectorAll('.carousel_dot')];let current=0,timer;const show=i=>{current=(i+slides.length)%slides.length;slides.forEach((s,n)=>s.classList.toggle('active',n===current));dots.forEach((d,n)=>d.classList.toggle('active',n===current))};const play=()=>{clearInterval(timer);timer=setInterval(()=>show(current+1),5500)};root.querySelector('.carousel_prev').addEventListener('click',()=>{show(current-1);play()});root.querySelector('.carousel_next').addEventListener('click',()=>{show(current+1);play()});dots.forEach((d,n)=>d.addEventListener('click',()=>{show(n);play()}));root.addEventListener('mouseenter',()=>clearInterval(timer));root.addEventListener('mouseleave',play);root.addEventListener('focusin',()=>clearInterval(timer));root.addEventListener('focusout',play);show(0);play()});"]).

hospital_background(Request) :-
    http_reply_file('assets/hospital-care-background.png',
                    [cache(true)], Request).
hospital_background_2(Request) :-
    http_reply_file('assets/hospital-care-background-2.png',
                    [cache(true)], Request).
hospital_background_3(Request) :-
    http_reply_file('assets/hospital-care-background-3.png',
                    [cache(true)], Request).
hospital_background_4(Request) :-
    http_reply_file('assets/hospital-background-4.jpg',
                    [cache(true)], Request).

manifest_file(Request) :-
    http_reply_file('manifest.webmanifest',
                    [mime_type('application/manifest+json'), cache(false)], Request).
pwa_script(Request) :-
    http_reply_file('pwa.js',
                    [mime_type('application/javascript'), cache(false)], Request).
service_worker(Request) :-
    http_reply_file('sw.js',
                    [mime_type('application/javascript'), cache(false)], Request).
app_icon(Request) :-
    http_reply_file('assets/app-icon.svg',
                    [mime_type('image/svg+xml'), cache(true)], Request).

distance_script(_Request) :-
    format('Content-type: application/javascript; charset=UTF-8~n~n'),
    format('~s', ["document.addEventListener('DOMContentLoaded',()=>{const button=document.getElementById('locate_button');if(!button)return;const box=document.getElementById('address_verification'),status=document.getElementById('location_status'),section=document.getElementById('facilities_section'),address=box.getAttribute('data_address');const rad=x=>x*Math.PI/180;const distance=(a,b,c,d)=>{const R=6371,dp=rad(c-a),dl=rad(d-b),q=Math.sin(dp/2)**2+Math.cos(rad(a))*Math.cos(rad(c))*Math.sin(dl/2)**2;return 2*R*Math.asin(Math.sqrt(q))};button.addEventListener('click',async()=>{button.disabled=true;status.textContent='Verifying your address in Ghana...';try{const query=encodeURIComponent(address+', Ghana'),response=await fetch(`https://nominatim.openstreetmap.org/search?format=json&countrycodes=gh&limit=1&addressdetails=1&q=${query}`,{headers:{'Accept':'application/json'}});if(!response.ok)throw new Error('Map service unavailable');const places=await response.json();if(!places.length)throw new Error('Address not found');const originLat=Number(places[0].lat),originLon=Number(places[0].lon),cards=[...document.querySelectorAll('.facility')];cards.forEach(card=>{const lat=Number(card.getAttribute('data_lat')),lon=Number(card.getAttribute('data_lon')),km=distance(originLat,originLon,lat,lon),roadKm=km*1.25,minutes=Math.max(1,Math.round(roadKm/35*60));card.dataset.distance=roadKm;card.querySelector('.distance').textContent=`Approximately ${roadKm.toFixed(1)} km away · about ${minutes} minutes by car`;const link=card.querySelector('.directions');link.href=`https://www.google.com/maps/dir/?api=1&origin=${originLat},${originLon}&destination=${lat},${lon}&travelmode=driving`});const grid=section.querySelector('.facilities');cards.sort((a,b)=>Number(a.dataset.distance)-Number(b.dataset.distance)).forEach(card=>grid.appendChild(card));section.hidden=false;status.textContent=`Address verified near ${places[0].display_name}. Distances and times are estimates; use live directions for road and traffic details.`;button.textContent='Address verified';button.disabled=true}catch(error){status.textContent='We could not verify that address. Check the house address or GhanaPost GPS code and try again.';button.disabled=false}})});"]).

:- initialization(run, main).
