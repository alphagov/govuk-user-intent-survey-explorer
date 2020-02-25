# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Device.create(name: "Mobile")
Device.create(name: "Desktop")
Device.create(name: "Tablet")
Device.create(name: "Not specified")

Channel.create(name: "Direct")
Channel.create(name: "Email")
Channel.create(name: "(Other)")
Channel.create(name: "Social")
Channel.create(name: "Organic Search")
Channel.create(name: "Referral")
Channel.create(name: "Not specified")

Question.create(question_number: 1, question_text: "Are you using GOV.UK for professional or personal reasons?")
Question.create(question_number: 2, question_text: "What kind of work do you do?")
Question.create(question_number: 3, question_text: "Describe why you came to GOV.UK today")
Question.create(question_number: 4, question_text: "Have you found what you were looking for?")
Question.create(question_number: 5, question_text: "Overall, how did you feel about your visit to GOV.UK today?")
Question.create(question_number: 6, question_text: "Have you been anywhere else for help with this already?")
Question.create(question_number: 7, question_text: "Where did you go for help?")
Question.create(question_number: 8, question_text: "If you wish to comment further, please do so here")
