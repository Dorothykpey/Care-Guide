% Local user-interface translations. English is used as a safe fallback.

language(en, 'English').
language(fr, 'Français').
language(es, 'Español').
language(tw, 'Twi').
language(ee, 'Eʋegbe').
language(gaa, 'Ga').
language(ha, 'Hausa').
language(ada, 'Dangme / Adangbe').
language(dag, 'Dagbani').
language(fat, 'Fante').

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
text(zh, begin, '开始咨询').
text(zh, region, '您所在的地区').
text(zh, language, '语言').
text(zh, question_prefix, '您是否有').
text(zh, yes, '是').
text(zh, no, '否').
text(zh, cancel, '取消咨询').
text(zh, answered, '已回答的问题').
text(zh, result, '您的结果').
text(zh, specialist, '建议咨询的专科医生').
text(zh, guidance, '健康建议').
text(zh, facilities, '医疗机构位于').
text(zh, location_button, '使用我的位置估算距离').

text(tw, begin, 'Fi nhwehwɛmu no ase').
text(tw, region, 'Wo mantam').
text(tw, language, 'Kasa').
text(tw, question_prefix, 'So wote').
text(tw, yes, 'Aane').
text(tw, no, 'Dabi').
text(tw, cancel, 'Gyae nhwehwɛmu no').
text(tw, answered, 'Nsɛmmisa a woabua').
text(tw, result, 'Wo nhwehwɛmu aba').
text(tw, specialist, 'Obenfo a wɔkamfo no').
text(tw, guidance, 'Akwankyerɛ').
text(tw, facilities, 'Ayaresabea ahorow wɔ').
text(tw, location_button, 'Fa me beae bu akwansin no').

text(ee, begin, 'Dze dodokpɔ la gɔme').
text(ee, region, 'Wò nutome').
text(ee, language, 'Gbegbɔgblɔ').
text(ee, question_prefix, 'Ðe èsele').
text(ee, yes, 'Ɛ̃').
text(ee, no, 'Ao').
text(ee, cancel, 'Tɔ asi le dodokpɔ la ŋu').
text(ee, answered, 'Nyabiase siwo ŋu nèɖo').
text(ee, result, 'Wò dodokpɔ me').
text(ee, specialist, 'Dɔkta si wòle be nàkpɔ').
text(ee, guidance, 'Mɔfiame').
text(ee, facilities, 'Kɔdziƒewo le').
text(ee, location_button, 'Zã nye nɔƒe nàbu didiƒe').

text(gaa, begin, 'Shishi tsɔɔmɔ lɛ').
text(gaa, region, 'Bo mantam').
text(gaa, language, 'Gbee').
text(gaa, question_prefix, 'Boote').
text(gaa, yes, 'Ɛɛ').
text(gaa, no, 'Daabi').
text(gaa, cancel, 'Gbo tsɔɔmɔ lɛ').
text(gaa, answered, 'Biŋmaa ni bohe').
text(gaa, result, 'Bo tsɔɔmɔ hetoo').
text(gaa, specialist, 'Dɔkta ni amɛkɛ bo').
text(gaa, guidance, 'Kwan tsɔɔmɔ').
text(gaa, facilities, 'Ayaresabea yɛ').
text(gaa, location_button, 'Tsɔ mi nɔɔhe bu kwan lɛ').

text(ha, begin, 'Fara binciken').
text(ha, region, 'Yankinku').
text(ha, language, 'Harshe').
text(ha, question_prefix, 'Kuna jin').
text(ha, yes, 'Eh').
text(ha, no, 'A’a').
text(ha, cancel, 'Soke binciken').
text(ha, answered, 'Tambayoyin da aka amsa').
text(ha, result, 'Sakamakonku').
text(ha, specialist, 'Kwararren likitan da aka ba da shawara').
text(ha, guidance, 'Shawara').
text(ha, facilities, 'Asibitoci a').
text(ha, location_button, 'Yi amfani da wurina don kimanta nisa').

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
symptom_text(fr, difficulty_breathing, 'des difficultés à respirer').
symptom_text(fr, chest_pain, 'une douleur thoracique').
symptom_text(fr, wheezing, 'une respiration sifflante').
symptom_text(fr, chest_tightness, 'une oppression thoracique').
symptom_text(fr, persistent_cough, 'une toux persistante').
symptom_text(fr, painful_urination, 'une douleur en urinant').
symptom_text(fr, frequent_urination, 'des envies fréquentes d’uriner').
symptom_text(fr, lower_abdominal_pain, 'une douleur au bas-ventre').
symptom_text(fr, cloudy_or_strong_smelling_urine, 'une urine trouble ou à forte odeur').
symptom_text(fr, severe_headache, 'un mal de tête intense').
symptom_text(fr, sensitivity_to_light, 'une sensibilité à la lumière').
symptom_text(fr, visual_disturbance, 'des troubles visuels').
symptom_text(fr, itchy_eyes, 'des démangeaisons aux yeux').
symptom_text(fr, nasal_congestion, 'une congestion nasale').
symptom_text(fr, painful_swallowing, 'une douleur en avalant').
symptom_text(fr, swollen_neck_glands, 'des ganglions gonflés dans le cou').
symptom_text(fr, red_eye, 'un œil rouge').
symptom_text(fr, itchy_eye, 'un œil qui démange').
symptom_text(fr, eye_discharge, 'un écoulement de l’œil').
symptom_text(fr, watery_eye, 'un larmoiement').
symptom_text(fr, red_swollen_skin, 'une peau rouge et gonflée').
symptom_text(fr, skin_warmth, 'une peau anormalement chaude').
symptom_text(fr, skin_pain, 'une douleur de la peau').
symptom_text(fr, pus_or_discharge, 'du pus ou un écoulement').
symptom_text(fr, excessive_thirst, 'une soif excessive').
symptom_text(fr, unexplained_weight_loss, 'une perte de poids inexpliquée').
symptom_text(fr, blurred_vision, 'une vision floue').
symptom_text(fr, pale_skin, 'une peau pâle').
symptom_text(fr, dizziness, 'des vertiges').
symptom_text(fr, shortness_of_breath_on_exertion, 'un essoufflement à l’effort').
symptom_text(fr, burning_chest_after_meals, 'une brûlure dans la poitrine après les repas').
symptom_text(fr, sour_taste_in_mouth, 'un goût acide dans la bouche').
symptom_text(fr, belching, 'des éructations').
symptom_text(fr, symptoms_worse_when_lying_down, 'des symptômes aggravés en position couchée').
symptom_text(fr, facial_pain_or_pressure, 'une douleur ou pression au visage').
symptom_text(fr, thick_nasal_discharge, 'un écoulement nasal épais').
symptom_text(fr, reduced_sense_of_smell, 'une diminution de l’odorat').
symptom_text(fr, ear_pain, 'une douleur à l’oreille').
symptom_text(fr, reduced_hearing, 'une diminution de l’audition').
symptom_text(fr, ear_discharge, 'un écoulement de l’oreille').
symptom_text(fr, dry_mouth, 'une bouche sèche').
symptom_text(fr, reduced_urination, 'une diminution des urines').
symptom_text(fr, itchy_blistering_rash, 'une éruption de cloques qui démange').
symptom_text(fr, intense_nighttime_itching, 'des démangeaisons intenses la nuit').
symptom_text(fr, small_bumpy_rash, 'une éruption de petits boutons').
symptom_text(fr, rash_between_fingers, 'une éruption entre les doigts').
symptom_text(fr, household_members_itching, 'des démangeaisons chez d’autres membres du foyer').
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
symptom_text(es, difficulty_breathing, 'dificultad para respirar').
symptom_text(es, chest_pain, 'dolor en el pecho').
symptom_text(es, wheezing, 'silbidos al respirar').
symptom_text(es, chest_tightness, 'opresión en el pecho').
symptom_text(es, persistent_cough, 'tos persistente').
symptom_text(es, painful_urination, 'dolor al orinar').
symptom_text(es, frequent_urination, 'necesidad frecuente de orinar').
symptom_text(es, lower_abdominal_pain, 'dolor en la parte baja del abdomen').
symptom_text(es, cloudy_or_strong_smelling_urine, 'orina turbia o con olor fuerte').
symptom_text(es, severe_headache, 'dolor de cabeza intenso').
symptom_text(es, sensitivity_to_light, 'sensibilidad a la luz').
symptom_text(es, visual_disturbance, 'alteraciones visuales').
symptom_text(es, itchy_eyes, 'picazón en los ojos').
symptom_text(es, nasal_congestion, 'congestión nasal').
symptom_text(es, painful_swallowing, 'dolor al tragar').
symptom_text(es, swollen_neck_glands, 'ganglios inflamados en el cuello').
symptom_text(es, red_eye, 'ojo rojo').
symptom_text(es, itchy_eye, 'picazón en el ojo').
symptom_text(es, eye_discharge, 'secreción ocular').
symptom_text(es, watery_eye, 'ojo lloroso').
symptom_text(es, red_swollen_skin, 'piel roja e hinchada').
symptom_text(es, skin_warmth, 'calor en la piel').
symptom_text(es, skin_pain, 'dolor en la piel').
symptom_text(es, pus_or_discharge, 'pus o secreción').
symptom_text(es, excessive_thirst, 'sed excesiva').
symptom_text(es, unexplained_weight_loss, 'pérdida de peso inexplicable').
symptom_text(es, blurred_vision, 'visión borrosa').
symptom_text(es, pale_skin, 'piel pálida').
symptom_text(es, dizziness, 'mareos').
symptom_text(es, shortness_of_breath_on_exertion, 'falta de aire con el esfuerzo').
symptom_text(es, burning_chest_after_meals, 'ardor en el pecho después de comer').
symptom_text(es, sour_taste_in_mouth, 'sabor ácido en la boca').
symptom_text(es, belching, 'eructos').
symptom_text(es, symptoms_worse_when_lying_down, 'síntomas peores al acostarse').
symptom_text(es, facial_pain_or_pressure, 'dolor o presión facial').
symptom_text(es, thick_nasal_discharge, 'secreción nasal espesa').
symptom_text(es, reduced_sense_of_smell, 'disminución del olfato').
symptom_text(es, ear_pain, 'dolor de oído').
symptom_text(es, reduced_hearing, 'disminución de la audición').
symptom_text(es, ear_discharge, 'secreción del oído').
symptom_text(es, dry_mouth, 'boca seca').
symptom_text(es, reduced_urination, 'disminución de la orina').
symptom_text(es, itchy_blistering_rash, 'sarpullido con ampollas y picazón').
symptom_text(es, intense_nighttime_itching, 'picazón intensa por la noche').
symptom_text(es, small_bumpy_rash, 'sarpullido de pequeños bultos').
symptom_text(es, rash_between_fingers, 'sarpullido entre los dedos').
symptom_text(es, household_members_itching, 'picazón en otros miembros del hogar').

advice_text(fr, tooth_decay, 'Maintenez une bonne hygiène bucco-dentaire, limitez les aliments sucrés et consultez un dentiste.').
advice_text(fr, malaria, 'Rendez-vous dans un établissement de santé pour un test de paludisme et un traitement approprié.').
advice_text(fr, typhoid, 'Buvez de l’eau potable et consultez un professionnel de santé pour des analyses.').
advice_text(fr, common_cold, 'Reposez-vous, buvez des liquides chauds et surveillez vos symptômes.').
advice_text(fr, flu, 'Reposez-vous, hydratez-vous et consultez si les symptômes deviennent graves.').
advice_text(fr, food_poisoning, 'Hydratez-vous et consultez si les vomissements ou la diarrhée persistent.').
advice_text(fr, pneumonia, 'Consultez rapidement. Une difficulté respiratoire importante, des lèvres bleues, une confusion ou une forte douleur thoracique est une urgence.').
advice_text(fr, asthma_flare, 'Utilisez uniquement votre inhalateur prescrit et consultez en urgence si la respiration reste difficile.').
advice_text(fr, urinary_tract_infection, 'Consultez pour une analyse d’urine et un traitement adapté. La fièvre, les douleurs dorsales ou la grossesse nécessitent une évaluation rapide.').
advice_text(fr, migraine, 'Reposez-vous dans un endroit calme et sombre et demandez un avis médical. Un mal de tête soudain et extrême est une urgence.').
advice_text(fr, allergic_rhinitis, 'Évitez les déclencheurs connus et demandez conseil à un pharmacien ou à un médecin.').
advice_text(fr, tonsillitis, 'Buvez des liquides et faites-vous examiner. Une difficulté à respirer ou à avaler nécessite des soins urgents.').
advice_text(fr, conjunctivitis, 'Évitez de frotter l’œil, lavez-vous les mains et consultez. Une douleur ou une baisse de vision nécessite une évaluation urgente.').
advice_text(fr, skin_infection, 'Gardez la zone propre et consultez. Une rougeur qui s’étend rapidement, de la fièvre ou une douleur intense nécessite des soins urgents.').
advice_text(fr, diabetes_warning_signs, 'Faites rapidement contrôler votre glycémie. Des vomissements, une respiration profonde, une confusion ou une faiblesse sévère nécessitent des soins urgents.').
advice_text(fr, anaemia, 'Consultez pour un examen et une prise de sang. Une douleur thoracique, un évanouissement ou un essoufflement sévère est urgent.').
advice_text(fr, acid_reflux, 'Évitez les repas copieux tardifs et consultez si les symptômes persistent. Une douleur thoracique nouvelle ou intense doit être évaluée en urgence.').
advice_text(fr, sinusitis, 'Reposez-vous, hydratez-vous et consultez si les symptômes persistent ou s’aggravent. Un gonflement de l’œil ou une confusion est urgent.').
advice_text(fr, ear_infection, 'Faites examiner l’oreille et n’y introduisez aucun objet ni goutte non prescrite. Un gonflement derrière l’oreille nécessite des soins urgents.').
advice_text(fr, dehydration, 'Buvez fréquemment de petites quantités de liquide sûr ou une solution de réhydratation. Une confusion ou l’incapacité de boire est urgente.').
advice_text(fr, chickenpox, 'Évitez le contact avec les personnes enceintes, les nouveau-nés et les personnes immunodéprimées, et demandez un avis médical.').
advice_text(fr, scabies, 'Demandez confirmation et traitement à un professionnel. Les proches, les vêtements et la literie peuvent nécessiter un traitement coordonné.').
advice_text(es, tooth_decay, 'Mantenga una buena higiene bucal, limite los alimentos azucarados y visite a un dentista.').
advice_text(es, malaria, 'Acuda a un centro de salud para realizar una prueba de malaria y recibir tratamiento.').
advice_text(es, typhoid, 'Beba agua potable y consulte a un profesional de salud para realizar pruebas.').
advice_text(es, common_cold, 'Descanse, beba líquidos calientes y vigile sus síntomas.').
advice_text(es, flu, 'Descanse, beba líquidos y busque atención si los síntomas se agravan.').
advice_text(es, food_poisoning, 'Manténgase hidratado y acuda a una clínica si persisten los vómitos o la diarrea.').
advice_text(es, pneumonia, 'Busque evaluación médica pronto. La dificultad respiratoria grave, labios azules, confusión o dolor fuerte en el pecho es una emergencia.').
advice_text(es, asthma_flare, 'Use únicamente su inhalador recetado y busque atención urgente si continúa la dificultad para respirar.').
advice_text(es, urinary_tract_infection, 'Acuda a una clínica para un análisis de orina. La fiebre, dolor de espalda o embarazo requieren evaluación rápida.').
advice_text(es, migraine, 'Descanse en un lugar oscuro y tranquilo y consulte a un profesional. Un dolor de cabeza súbito y extremo es una emergencia.').
advice_text(es, allergic_rhinitis, 'Evite los desencadenantes conocidos y consulte a un farmacéutico o profesional sobre un alivio seguro.').
advice_text(es, tonsillitis, 'Beba líquidos y solicite una evaluación. La dificultad para respirar o tragar requiere atención urgente.').
advice_text(es, conjunctivitis, 'No se frote el ojo, lávese las manos y consulte. El dolor ocular o la pérdida de visión requiere atención urgente.').
advice_text(es, skin_infection, 'Mantenga limpia la zona y busque evaluación médica. El enrojecimiento rápido, fiebre o dolor intenso requiere atención urgente.').
advice_text(es, diabetes_warning_signs, 'Solicite pronto una prueba de glucosa. Los vómitos, respiración profunda, confusión o debilidad grave requieren atención urgente.').
advice_text(es, anaemia, 'Acuda a un profesional para una evaluación y análisis de sangre. El dolor en el pecho, desmayo o falta de aire grave es urgente.').
advice_text(es, acid_reflux, 'Evite comidas grandes y tardías y consulte si los síntomas persisten. Un dolor nuevo o fuerte en el pecho requiere evaluación urgente.').
advice_text(es, sinusitis, 'Descanse, beba líquidos y consulte si empeora o persiste. La hinchazón del ojo o confusión requiere atención urgente.').
advice_text(es, ear_infection, 'Solicite un examen del oído y no introduzca objetos ni gotas no recetadas. La hinchazón detrás del oído requiere atención urgente.').
advice_text(es, dehydration, 'Tome pequeñas cantidades frecuentes de líquidos seguros o solución de rehidratación. La confusión o incapacidad para beber es urgente.').
advice_text(es, chickenpox, 'Evite el contacto con embarazadas, recién nacidos y personas inmunodeprimidas, y solicite orientación médica.').
advice_text(es, scabies, 'Solicite confirmación y tratamiento profesional. Los contactos del hogar, ropa y ropa de cama pueden necesitar tratamiento coordinado.').

localized_advice(Language, Disease, _, Text) :- advice_text(Language, Disease, Text), !.
localized_advice(_, _, Default, Default).
