% =====================================================
% Disease Diagnosis Expert System
% Assignment: Practical Expert System using Prolog
% Tool: SWI-Prolog
% =====================================================

% This tells Prolog that yes/1 and no/1 can change during execution.
:- dynamic yes/1, no/1.

% -------------------------------
% Start the expert system
% -------------------------------

start :-
    write('======================================'), nl,
    write(' TROPICAL DISEASE DIAGNOSIS SYSTEM'), nl,
    write('======================================'), nl,
    write('Please answer the following questions with yes. or no.'), nl,
    nl,
    diagnose(Disease),
    nl,
    write('Possible Diagnosis: '),
    write(Disease), nl,
    give_advice(Disease),
    nl,
    undo.

% -------------------------------
% Disease diagnosis rules
% -------------------------------

diagnose(malaria) :-
    symptom(fever),
    symptom(headache),
    symptom(chills),
    symptom(sweating),
    symptom(body_ache), !.

diagnose(typhoid) :-
    symptom(fever),
    symptom(headache),
    symptom(stomach_pain),
    symptom(loss_of_appetite),
    symptom(weakness), !.

diagnose(cholera) :-
    symptom(diarrhea),
    symptom(vomiting),
    symptom(dehydration),
    symptom(stomach_cramps), !.

diagnose(cold_or_flu) :-
    symptom(cough),
    symptom(sore_throat),
    symptom(runny_nose),
    symptom(sneezing),
    symptom(fever), !.

diagnose(unknown_disease).

% -------------------------------
% Advice / treatment suggestions
% -------------------------------

give_advice(malaria) :-
    write('Advice: You may have malaria.'), nl,
    write('Please visit a hospital or clinic for a malaria test.'), nl,
    write('Drink enough water and avoid self-medication.').

give_advice(typhoid) :-
    write('Advice: You may have typhoid fever.'), nl,
    write('Please visit a hospital for a blood or stool test.'), nl,
    write('Drink clean water and eat safe food.').

give_advice(cholera) :-
    write('Advice: You may have cholera.'), nl,
    write('Take oral rehydration solution immediately.'), nl,
    write('Visit a health facility quickly because dehydration can be dangerous.').

give_advice(cold_or_flu) :-
    write('Advice: You may have cold or flu.'), nl,
    write('Rest well, drink fluids, and see a doctor if symptoms become severe.').

give_advice(unknown_disease) :-
    write('Advice: The system could not identify a specific disease.'), nl,
    write('Please consult a medical professional for proper diagnosis.').

% -------------------------------
% Symptom checking
% -------------------------------

symptom(S) :-
    yes(S), !.

symptom(S) :-
    no(S), !, fail.

symptom(S) :-
    ask(S).

% -------------------------------
% Ask user questions
% -------------------------------

ask(fever) :-
    write('Do you have a fever? '),
    read(Response),
    process_response(fever, Response).

ask(headache) :-
    write('Do you have a headache? '),
    read(Response),
    process_response(headache, Response).

ask(chills) :-
    write('Are you experiencing chills? '),
    read(Response),
    process_response(chills, Response).

ask(sweating) :-
    write('Are you sweating excessively? '),
    read(Response),
    process_response(sweating, Response).

ask(body_ache) :-
    write('Do you have body aches? '),
    read(Response),
    process_response(body_ache, Response).

ask(stomach_pain) :-
    write('Do you have stomach pain? '),
    read(Response),
    process_response(stomach_pain, Response).

ask(loss_of_appetite) :-
    write('Have you lost your appetite? '),
    read(Response),
    process_response(loss_of_appetite, Response).

ask(weakness) :-
    write('Are you feeling weak? '),
    read(Response),
    process_response(weakness, Response).

ask(diarrhea) :-
    write('Are you experiencing diarrhea? '),
    read(Response),
    process_response(diarrhea, Response).

ask(vomiting) :-
    write('Are you vomiting? '),
    read(Response),
    process_response(vomiting, Response).

ask(dehydration) :-
    write('Are you experiencing dehydration? '),
    read(Response),
    process_response(dehydration, Response).

ask(stomach_cramps) :-
    write('Do you have stomach cramps? '),
    read(Response),
    process_response(stomach_cramps, Response).

ask(cough) :-
    write('Do you have a cough? '),
    read(Response),
    process_response(cough, Response).

ask(sore_throat) :-
    write('Do you have a sore throat? '),
    read(Response),
    process_response(sore_throat, Response).

ask(runny_nose) :-
    write('Do you have a runny nose? '),
    read(Response),
    process_response(runny_nose, Response).

ask(sneezing) :-
    write('Are you sneezing? '),
    read(Response),
    process_response(sneezing, Response).

% -------------------------------
% Process user answer
% -------------------------------

process_response(Symptom, yes) :-
    assertz(yes(Symptom)), !.

process_response(Symptom, no) :-
    assertz(no(Symptom)), fail.

process_response(Symptom, _) :-
    write('Please answer only yes. or no.'), nl,
    ask(Symptom).

% -------------------------------
% Clear stored answers after diagnosis
% -------------------------------

undo :-
    retract(yes(_)),
    fail.

undo :-
    retract(no(_)),
    fail.

undo.