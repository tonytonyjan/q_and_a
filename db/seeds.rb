# frozen_string_literal: true

user = User.create!(
  name: '簡煒航',
  google_uid: '106993981418226624133',
  avatar: 'https:////lh6.googleusercontent.com/-juhg9DCk0C4/AAAAAAAAAAI/AAAAAAAAExA/D9XgaOsOVkA/photo.jpg'
)

markdown = <<~CONTENT
  # header

  * **item 1**
  * *item 2*
  * [item 3](#)

  ```
  code block
  ```
CONTENT

user.questions.create!(
  [
    {
      title: 'Markdown Example',
      content: markdown
    }
  ] * 6
)

question = Question.last
Answer.create!(
  [
    { content: '**hello** *world*!', user_id: user.id, question_id: question.id }
  ] * 6
)
