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
    writeln('----------------------------------------').

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
    writeln('Current coverage regions: greater_accra, ashanti, volta.'),
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
