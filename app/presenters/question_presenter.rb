# frozen_string_literal: true

class QuestionPresenter < DelegateClass(Question)
  def initialize(question)
    super
  end

  def avatar
    user.avatar
  end

  def author
    user.name
  end

  def number_of_answers
    answers.size
  end

  def html_content
    RenderMarkdown.new(content).to_html
  end
end
