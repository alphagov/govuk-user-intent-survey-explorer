def associate_phrase_with_generic_phrase(phrase, generic_phrase)
  FactoryBot.create(:phrase_generic_phrase, phrase: phrase, generic_phrase: generic_phrase)
end