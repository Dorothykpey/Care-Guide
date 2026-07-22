% =========================================================================
% ALL-IN-ONE DISEASE DIAGNOSIS, DOCTOR SPECIALIST & REGIONAL ROUTING SYSTEM
% =========================================================================

:- dynamic known/2.

% -------------------------------------------------------------------------
% MAIN EXECUTION LOOP
% -------------------------------------------------------------------------
main :-
    retractall(known(_, _)),
    nl,
    writeln('========================================'),
    writeln('       DISEASE DIAGNOSIS SYSTEM         '),
    writeln('========================================'),
    writeln('Please answer questions with yes (y) or no (n).'),
    nl,
    execute_diagnosis.

% -------------------------------------------------------------------------
% DIAGNOSIS INFERENCE ENGINE
% -------------------------------------------------------------------------
% Flow A: A known disease matches the symptoms perfectly
execute_diagnosis :-
    disease(Disease, Symptoms, Advice, Specialist),
    check_all_symptoms(Symptoms), !,
    nl,
    writeln('----------------------------------------'),
    format('Final Diagnosis: ~w~n', [Disease]),
    format('Attending Doctor: ~w~n', [Specialist]),
    format('Advice:          ~w~n', [Advice]),
    writeln('----------------------------------------'),
    get_user_region_and_route.

% Flow B: Fallback if symptoms do not match anything in the database
execute_diagnosis :-
    nl,
    writeln('----------------------------------------'),
    writeln('Final Diagnosis: unknown_disease'),
    writeln('Attending Doctor: General Practitioner (GP) / Emergency Physician'),
    writeln('Advice:          The system could not identify the disease clearly. Please consult a medical professional.'),
    writeln('----------------------------------------'),
    offer_reproductive_health_consultation,
    get_user_region_and_route.

% This is a separate reproductive-health pathway, not a disease diagnosis.
offer_reproductive_health_consultation :-
    nl,
    writeln('Is your concern about a missed period or possible pregnancy? (y/n)'),
    read(Response),
    ( member(Response, [yes, y, 'YES', 'Y', 'Yes']) ->
        reproductive_health_consultation
    ; member(Response, [no, n, 'NO', 'N', 'No']) ->
        true
    ; writeln('>>> Invalid input! Please type y. or n.'),
      offer_reproductive_health_consultation
    ).

reproductive_health_consultation :-
    nl,
    writeln('PRIVATE REPRODUCTIVE-HEALTH GUIDANCE'),
    writeln('A missed period alone does not confirm pregnancy.'),
    writeln('Take a reliable pregnancy test as directed, or visit a clinic for testing.'),
    writeln('Have you had severe or one-sided abdominal pain, heavy bleeding, fainting, severe dizziness, fever, or foul-smelling discharge? (y/n)'),
    read(UrgentResponse),
    reproductive_urgency_advice(UrgentResponse),
    writeln('Are you considering ending a possible or confirmed pregnancy? (yes/no/unsure)'),
    read(Intention),
    reproductive_intention_advice(Intention),
    writeln('You do not need to justify your decision to this program.'),
    writeln('A qualified clinician can listen to your reasons without judgment, confirm the pregnancy and duration when needed, explain safe options, check for coercion, and respect your consent and privacy.'),
    writeln('Do not use unknown pills, herbs, chemicals, objects, or physical injury to try to end a pregnancy.').

reproductive_urgency_advice(Response) :-
    member(Response, [yes, y, 'YES', 'Y', 'Yes']), !,
    writeln('>>> URGENT: Seek emergency care now or call Ghana emergency services on 112.').
reproductive_urgency_advice(_) :-
    writeln('Arrange a timely consultation with a qualified reproductive-health professional.').

reproductive_intention_advice(yes) :- !,
    writeln('Ask a qualified provider for confidential pregnancy-options counselling and safe abortion care. Do not delay, because available care can depend on pregnancy duration and clinical circumstances.').
reproductive_intention_advice(y) :- !,
    reproductive_intention_advice(yes).
reproductive_intention_advice(unsure) :- !,
    writeln('Ask for unbiased pregnancy-options counselling so you can discuss your choices without pressure.').
reproductive_intention_advice(_) :-
    writeln('A clinician can assess the missed period, discuss pregnancy care if confirmed, and check other possible causes.').

% Recursively checks the list of symptoms
check_all_symptoms([]).
check_all_symptoms([Symptom|T]) :-
    verify_symptom(Symptom),
    check_all_symptoms(T).

% -------------------------------------------------------------------------
% USER INTERACTION & VALIDATION LAYER
% -------------------------------------------------------------------------
verify_symptom(Symptom) :- known(Symptom, yes), !.
verify_symptom(Symptom) :- known(Symptom, no), !, fail.
verify_symptom(Symptom) :-
    format('Do you experience ~w? ', [Symptom]),
    read(Response),
    process_response(Symptom, Response).

process_response(Symptom, Response) :-
    member(Response, [yes, y, 'YES', 'Y', 'Yes']), !,
    assertz(known(Symptom, yes)).

process_response(Symptom, Response) :-
    member(Response, [no, n, 'NO', 'N', 'No']), !,
    assertz(known(Symptom, no)),
    fail.

process_response(Symptom, _) :-
    writeln('>>> Invalid input! Please type y. or n.'),
    verify_symptom(Symptom).

% -------------------------------------------------------------------------
% REGIONAL GEOGRAPHIC ROUTING ENGINE
% -------------------------------------------------------------------------
get_user_region_and_route :-
    nl,
    writeln('To connect you with immediate medical attention, please share your region.'),
    writeln('Coverage includes all 16 regions of Ghana.'),
    writeln('Enter names in lowercase with underscores, for example: greater_accra, upper_east, or volta.'),
    ask_region(Region),
    nl,
    writeln('================================================================='),
    format('   RECOMMENDED MEDICAL FACILITIES IN THE ~w REGION ~n', [Region]),
    writeln('================================================================='),
    print_category_group(Region, 'Public General Hospital'),
    print_category_group(Region, 'Private Medical Center'),
    print_category_group(Region, 'Specialized Clinic'),
    writeln('================================================================='),
    nl.

ask_region(Region) :-
    write('Which region are you located in? (e.g., "greater_accra.", "ashanti.", "volta."): '),
    read(Input),
    (   hospital(Input, _, _, _) ->
        Region = Input
    ;
        writeln('>>> Sorry, that region is outside our database or misspelled.'),
        writeln('>>> Please enter lowercase names like: greater_accra. or ashanti.'), nl,
        ask_region(Region)
    ).

print_category_group(Region, Category) :-
    hospital(Region, Category, _, _), !, 
    format('~n[ CATEGORY: ~w ]~n', [Category]),
    forall(hospital(Region, Category, Name, Details), 
           format('  -> ~w (~w)~n', [Name, Details])).
print_category_group(_, _).

% -------------------------------------------------------------------------
% KNOWLEDGE BASE: DISEASES, SYMPTOMS, ADVICE & SPECIALISTS
% -------------------------------------------------------------------------
disease(tooth_decay,
        [toothache, tooth_sensitivity, visible_holes_in_teeth],
        'Maintain good oral hygiene, limit sugary foods, and visit a dental clinic for fillings or treatment.',
        'Dentist / Endodontist').

disease(malaria, 
        [fever, headache, chills, sweating, body_pain],
        'Visit a hospital or clinic for a malaria test and treatment.',
        'Infectious Disease Specialist / General Physician').

disease(typhoid, 
        [fever, stomach_pain, loss_of_appetite, weakness, diarrhea],
        'Drink clean water and visit a health professional for proper testing.',
        'Gastroenterologist / Internal Medicine Specialist').

disease(common_cold, 
        [runny_nose, sneezing, sore_throat, cough],
        'Rest, drink warm fluids, and monitor your symptoms.',
        'General Practitioner (GP) / Family Physician').

disease(flu, 
        [fever, cough, body_pain, tiredness, headache],
        'Rest well, drink fluids, and seek medical care if symptoms become serious.',
        'General Practitioner (GP) / Pulmonologist (if respiratory issues worsen)').

disease(food_poisoning, 
        [vomiting, diarrhea, stomach_pain, nausea],
        'Drink enough water and visit a clinic if vomiting or diarrhea continues.',
        'Gastroenterologist / Emergency Care Physician').

disease(pneumonia,
        [fever, cough, difficulty_breathing, chest_pain, weakness],
        'Seek prompt medical assessment. Difficulty breathing, blue lips, confusion, or severe chest pain requires emergency care.',
        'General Physician / Pulmonologist / Emergency Physician').

disease(asthma_flare,
        [wheezing, difficulty_breathing, chest_tightness, persistent_cough],
        'Use only your prescribed reliever inhaler as directed and seek urgent care if breathing remains difficult or speaking becomes hard.',
        'Pulmonologist / General Physician / Emergency Physician').

disease(urinary_tract_infection,
        [painful_urination, frequent_urination, lower_abdominal_pain, cloudy_or_strong_smelling_urine],
        'Visit a clinic for a urine test and appropriate treatment. Fever, back pain, vomiting, or pregnancy requires prompt assessment.',
        'General Physician / Urologist').

disease(migraine,
        [severe_headache, sensitivity_to_light, nausea, visual_disturbance],
        'Rest in a quiet dark room and seek medical advice. A sudden worst-ever headache, weakness, confusion, or trouble speaking is an emergency.',
        'General Physician / Neurologist').

disease(allergic_rhinitis,
        [sneezing, runny_nose, itchy_eyes, nasal_congestion],
        'Avoid known triggers and consult a pharmacist or clinician about safe symptom relief, especially if breathing is affected.',
        'General Physician / Allergy Specialist').

disease(tonsillitis,
        [sore_throat, painful_swallowing, fever, swollen_neck_glands],
        'Drink fluids and arrange a clinical examination. Seek urgent care for breathing difficulty, drooling, or inability to swallow.',
        'General Physician / Ear Nose and Throat Specialist').

disease(conjunctivitis,
        [red_eye, itchy_eye, eye_discharge, watery_eye],
        'Avoid rubbing the eye, wash your hands frequently, and obtain clinical advice. Eye pain, injury, or reduced vision needs urgent assessment.',
        'General Physician / Ophthalmologist').

disease(skin_infection,
        [red_swollen_skin, skin_warmth, skin_pain, pus_or_discharge],
        'Keep the area clean and seek medical assessment. Rapidly spreading redness, fever, severe pain, or facial involvement requires urgent care.',
        'General Physician / Dermatologist').

disease(diabetes_warning_signs,
        [frequent_urination, excessive_thirst, unexplained_weight_loss, blurred_vision, tiredness],
        'Arrange a blood glucose test promptly. Vomiting, deep or rapid breathing, confusion, or severe weakness requires emergency care.',
        'General Physician / Endocrinologist').

disease(anaemia,
        [tiredness, weakness, pale_skin, dizziness, shortness_of_breath_on_exertion],
        'Visit a clinician for examination and a blood count. Chest pain, fainting, severe breathlessness, or active bleeding requires urgent care.',
        'General Physician / Haematologist').

disease(acid_reflux,
        [burning_chest_after_meals, sour_taste_in_mouth, belching, symptoms_worse_when_lying_down],
        'Avoid large late meals and known triggers, and seek clinical advice if symptoms persist. New or severe chest pain must be assessed urgently.',
        'General Physician / Gastroenterologist').

disease(sinusitis,
        [facial_pain_or_pressure, nasal_congestion, thick_nasal_discharge, reduced_sense_of_smell],
        'Rest, drink fluids, and seek medical advice if symptoms are severe, persistent, or worsening. Eye swelling, confusion, or severe headache needs urgent care.',
        'General Physician / Ear Nose and Throat Specialist').

disease(ear_infection,
        [ear_pain, reduced_hearing, ear_discharge, fever],
        'Arrange a clinical ear examination and keep objects and unprescribed drops out of the ear. Swelling behind the ear or severe illness requires urgent care.',
        'General Physician / Ear Nose and Throat Specialist').

disease(dehydration,
        [excessive_thirst, dry_mouth, reduced_urination, dizziness, weakness],
        'Take frequent small amounts of safe oral fluids or oral rehydration solution. Confusion, fainting, inability to drink, or very little urine requires urgent care.',
        'General Physician / Emergency Physician').

disease(chickenpox,
        [itchy_blistering_rash, fever, tiredness, loss_of_appetite],
        'Avoid close contact with pregnant people, newborns, and immunocompromised people, and seek clinical advice. Breathing trouble, confusion, or severe illness is urgent.',
        'General Physician / Paediatrician / Dermatologist').

disease(scabies,
        [intense_nighttime_itching, small_bumpy_rash, rash_between_fingers, household_members_itching],
        'Seek confirmation and treatment advice from a clinician or pharmacist. Close household contacts and clothing or bedding may also need coordinated treatment.',
        'General Physician / Dermatologist').

% -------------------------------------------------------------------------
% KNOWLEDGE BASE: HOSPITALS CATEGORIZED BY REGION
% -------------------------------------------------------------------------
% Greater Accra Region Facilities
hospital(greater_accra, 'Public General Hospital', 'Greater Accra Regional Hospital (Ridge)', '24/7 Emergency - Located in Accra').
hospital(greater_accra, 'Public General Hospital', 'Tema General Hospital', 'Community 12 Emergency Block - Located in Tema').
hospital(greater_accra, 'Private Medical Center', 'Nyaho Medical Centre', 'Fast-track walk-ins - Airport Residential Area').
hospital(greater_accra, 'Private Medical Center', 'Narh-Bita Hospital', 'Excellent emergency check-ups - Near Tema Center').
hospital(greater_accra, 'Specialized Clinic', 'Korle-Bu Fevers Unit / Dental School Clinic', 'Highly recommended for specialized dental & infectious cases').

% Ashanti Region Facilities
hospital(ashanti, 'Public General Hospital', 'Komfo Anokye Teaching Hospital', 'Main Emergency Block & Oral Health Unit - Kumasi').
hospital(ashanti, 'Private Medical Center', 'MaxMedical Clinic', 'Minimal wait times - Located in Ahodwo, Kumasi').
hospital(ashanti, 'Specialized Clinic', 'Sunsite Diagnostics', 'Quick lab turnarounds for blood panels - Kumasi').

% Volta Region Facilities
hospital(volta, 'Public General Hospital', 'Ho Teaching Hospital (Trafalgar / Trafaga)', '24/7 Tertiary Referral, Emergency & Oral Maxillofacial Clinic').
hospital(volta, 'Private Medical Center', 'Ho Royal Hospital', 'Quality private medical care - Deme Road, Ho').
hospital(volta, 'Specialized Clinic', 'Ho Municipal Hospital', 'Award-winning maternal and general public care - Ho').

% Additional regions of Ghana
hospital(ahafo, 'Public General Hospital', 'Goaso Municipal Hospital', 'Municipal referral hospital - Goaso').
hospital(bono, 'Public General Hospital', 'Bono Regional Hospital', 'Regional referral hospital - Sunyani').
hospital(bono_east, 'Public General Hospital', 'Holy Family Hospital', 'Regional referral services - Techiman').
hospital(central, 'Public General Hospital', 'Cape Coast Teaching Hospital', 'Teaching and emergency hospital - Cape Coast').
hospital(eastern, 'Public General Hospital', 'Eastern Regional Hospital', 'Regional referral hospital - Koforidua').
hospital(north_east, 'Public General Hospital', 'Baptist Medical Centre', 'Major referral hospital - Nalerigu').
hospital(northern, 'Public General Hospital', 'Tamale Teaching Hospital', 'Tertiary referral and emergency care - Tamale').
hospital(oti, 'Public General Hospital', 'Worawora Government Hospital', 'General medical services - Worawora').
hospital(savannah, 'Public General Hospital', 'West Gonja Hospital', 'District and referral services - Damongo').
hospital(upper_east, 'Public General Hospital', 'Upper East Regional Hospital', 'Regional referral and emergency care - Bolgatanga').
hospital(upper_west, 'Public General Hospital', 'Upper West Regional Hospital', 'Regional referral and emergency care - Wa').
hospital(western, 'Public General Hospital', 'Effia Nkwanta Regional Hospital', 'Regional referral hospital - Sekondi').
hospital(western_north, 'Public General Hospital', 'Sefwi Wiawso Municipal Hospital', 'Municipal and referral services - Sefwi Wiawso').
