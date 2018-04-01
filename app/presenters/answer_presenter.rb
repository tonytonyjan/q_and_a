# frozen_string_literal: true

class AnswerPresenter < DelegateClass(Answer)
  def initialize(answer)
    super
  end

  def avatar
    user.avatar
  end

  def author
    user.name
  end

  def html_content
    RenderMarkdown.new(content).to_html
  end
end
