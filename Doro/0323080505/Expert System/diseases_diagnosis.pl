% Disease Diagnosis Expert System
% Artificial Intelligence Practical Work

:- dynamic known/2.

main :-
    retractall(known(_, _)),
    nl,
    write('========================================'), nl,
    write('       DISEASE DIAGNOSIS SYSTEM'), nl,
    write('========================================'), nl,
    write('Please answer the questions with yes or no.'), nl,
    nl,
    diagnose(Disease),
    nl,
    write('----------------------------------------'), nl,
    write('Final Diagnosis: '), write(Disease), nl,
    give_advice(Disease),
    write('----------------------------------------'), nl.

diagnose(malaria) :-
    symptom(fever),
    symptom(headache),
    symptom(chills),
    symptom(sweating),
    symptom(body_pain), !.

diagnose(typhoid) :-
    symptom(fever),
    symptom(stomach_pain),
    symptom(loss_of_appetite),
    symptom(weakness),
    symptom(diarrhea), !.

diagnose(common_cold) :-
    symptom(runny_nose),
    symptom(sneezing),
    symptom(sore_throat),
    symptom(cough), !.

diagnose(flu) :-
    symptom(fever),
    symptom(cough),
    symptom(body_pain),
    symptom(tiredness),
    symptom(headache), !.

diagnose(food_poisoning) :-
    symptom(vomiting),
    symptom(diarrhea),
    symptom(stomach_pain),
    symptom(nausea), !.

diagnose(unknown_disease).

give_advice(malaria) :-
    write('Advice: You may have malaria. Visit a hospital or clinic for a malaria test and treatment.'), nl.

give_advice(typhoid) :-
    write('Advice: You may have typhoid. Drink clean water and visit a health professional for proper testing.'), nl.

give_advice(common_cold) :-
    write('Advice: You may have common cold. Rest, drink warm fluids, and monitor your symptoms.'), nl.

give_advice(flu) :-
    write('Advice: You may have flu. Rest well, drink fluids, and seek medical care if symptoms become serious.'), nl.

give_advice(food_poisoning) :-
    write('Advice: You may have food poisoning. Drink enough water and visit a clinic if vomiting or diarrhea continues.'), nl.

give_advice(unknown_disease) :-
    write('Advice: The system could not identify the disease clearly. Please consult a medical professional.'), nl.

symptom(Symptom) :-
    known(Symptom, yes), !.

symptom(Symptom) :-
    known(Symptom, no), !, fail.

symptom(Symptom) :-
    ask(Symptom).

ask(Symptom) :-
    write('Do you have '),
    write(Symptom),
    write('? '),
    read(Response),
    nl,
    (
        Response == yes ->
        assertz(known(Symptom, yes))
    ;
        assertz(known(Symptom, no)),
        fail
    ).