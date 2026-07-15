% Local user-interface translations. English is used as a safe fallback.

language(en, 'English').
language(fr, 'Français').
language(es, 'Español').

text(en, begin, 'Begin consultation').
text(fr, begin, 'Commencer la consultation').
text(es, begin, 'Comenzar la consulta').
text(en, region, 'Your region').
text(fr, region, 'Votre région').
text(es, region, 'Su región').
text(en, language, 'Language').
text(fr, language, 'Langue').
text(es, language, 'Idioma').
text(en, question_prefix, 'Do you experience').
text(fr, question_prefix, 'Ressentez-vous').
text(es, question_prefix, '¿Tiene').
text(en, yes, 'Yes'). text(fr, yes, 'Oui'). text(es, yes, 'Sí').
text(en, no, 'No'). text(fr, no, 'Non'). text(es, no, 'No').
text(en, cancel, 'Cancel consultation').
text(fr, cancel, 'Annuler la consultation').
text(es, cancel, 'Cancelar la consulta').
text(en, answered, 'Questions answered').
text(fr, answered, 'Questions répondues').
text(es, answered, 'Preguntas respondidas').
text(en, result, 'Your result').
text(fr, result, 'Votre résultat').
text(es, result, 'Su resultado').
text(en, specialist, 'Suggested specialist').
text(fr, specialist, 'Spécialiste suggéré').
text(es, specialist, 'Especialista sugerido').
text(en, guidance, 'Guidance').
text(fr, guidance, 'Conseils').
text(es, guidance, 'Orientación').
text(en, facilities, 'Medical facilities in').
text(fr, facilities, 'Établissements médicaux en').
text(es, facilities, 'Centros médicos en').
text(en, location_button, 'Use my location to estimate distance').
text(fr, location_button, 'Utiliser ma position pour estimer la distance').
text(es, location_button, 'Usar mi ubicación para estimar la distancia').

ui_text(Language, Key, Text) :- text(Language, Key, Text), !.
ui_text(_, Key, Text) :- text(en, Key, Text).

symptom_text(fr, fever, 'de la fièvre').
symptom_text(fr, headache, 'des maux de tête').
symptom_text(fr, chills, 'des frissons').
symptom_text(fr, sweating, 'des sueurs').
symptom_text(fr, body_pain, 'des douleurs corporelles').
symptom_text(fr, cough, 'de la toux').
symptom_text(fr, tiredness, 'de la fatigue').
symptom_text(fr, vomiting, 'des vomissements').
symptom_text(fr, diarrhea, 'de la diarrhée').
symptom_text(fr, nausea, 'des nausées').
symptom_text(fr, toothache, 'une douleur dentaire').
symptom_text(fr, tooth_sensitivity, 'une sensibilité dentaire').
symptom_text(fr, visible_holes_in_teeth, 'des caries visibles').
symptom_text(fr, stomach_pain, 'des douleurs abdominales').
symptom_text(fr, loss_of_appetite, 'une perte d’appétit').
symptom_text(fr, weakness, 'une faiblesse').
symptom_text(fr, runny_nose, 'le nez qui coule').
symptom_text(fr, sneezing, 'des éternuements').
symptom_text(fr, sore_throat, 'un mal de gorge').
symptom_text(es, fever, 'fiebre').
symptom_text(es, headache, 'dolor de cabeza').
symptom_text(es, chills, 'escalofríos').
symptom_text(es, sweating, 'sudoración').
symptom_text(es, body_pain, 'dolor corporal').
symptom_text(es, cough, 'tos').
symptom_text(es, tiredness, 'cansancio').
symptom_text(es, vomiting, 'vómitos').
symptom_text(es, diarrhea, 'diarrea').
symptom_text(es, nausea, 'náuseas').
symptom_text(es, toothache, 'dolor de muelas').
symptom_text(es, tooth_sensitivity, 'sensibilidad dental').
symptom_text(es, visible_holes_in_teeth, 'caries visibles').
symptom_text(es, stomach_pain, 'dolor de estómago').
symptom_text(es, loss_of_appetite, 'pérdida de apetito').
symptom_text(es, weakness, 'debilidad').
symptom_text(es, runny_nose, 'secreción nasal').
symptom_text(es, sneezing, 'estornudos').
symptom_text(es, sore_throat, 'dolor de garganta').

advice_text(fr, tooth_decay, 'Maintenez une bonne hygiène bucco-dentaire, limitez les aliments sucrés et consultez un dentiste.').
advice_text(fr, malaria, 'Rendez-vous dans un établissement de santé pour un test de paludisme et un traitement approprié.').
advice_text(fr, typhoid, 'Buvez de l’eau potable et consultez un professionnel de santé pour des analyses.').
advice_text(fr, common_cold, 'Reposez-vous, buvez des liquides chauds et surveillez vos symptômes.').
advice_text(fr, flu, 'Reposez-vous, hydratez-vous et consultez si les symptômes deviennent graves.').
advice_text(fr, food_poisoning, 'Hydratez-vous et consultez si les vomissements ou la diarrhée persistent.').
advice_text(es, tooth_decay, 'Mantenga una buena higiene bucal, limite los alimentos azucarados y visite a un dentista.').
advice_text(es, malaria, 'Acuda a un centro de salud para realizar una prueba de malaria y recibir tratamiento.').
advice_text(es, typhoid, 'Beba agua potable y consulte a un profesional de salud para realizar pruebas.').
advice_text(es, common_cold, 'Descanse, beba líquidos calientes y vigile sus síntomas.').
advice_text(es, flu, 'Descanse, beba líquidos y busque atención si los síntomas se agravan.').
advice_text(es, food_poisoning, 'Manténgase hidratado y acuda a una clínica si persisten los vómitos o la diarrea.').

localized_advice(Language, Disease, _, Text) :- advice_text(Language, Disease, Text), !.
localized_advice(_, _, Default, Default).
