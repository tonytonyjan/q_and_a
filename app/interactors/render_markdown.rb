# frozen_string_literal: true

class RenderMarkdown
  def initialize(text)
    @text = text
  end

  def to_html
    CommonMarker.render_html(@text)
  end
end
