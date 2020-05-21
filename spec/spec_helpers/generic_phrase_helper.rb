def associate_phrase_with_generic_phrase(phrase, generic_phrase)
  FactoryBot.create(:phrase_generic_phrase, phrase: phrase, generic_phrase: generic_phrase)
end

def create_generic_phrase_model(verb_text, adjective_text)
  FactoryBot.create(:generic_phrase, verb: FactoryBot.create(:verb, name: verb_text), adjective: FactoryBot.create(:adjective, name: adjective_text))
end
