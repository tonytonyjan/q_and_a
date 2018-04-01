# frozen_string_literal: true

require 'test_helper'

class RenderMarkdownTest < ActiveSupport::TestCase
  test 'it works' do
    assert_html(<<~EXPECTED, RenderMarkdown.new(<<~ACTUALL).to_html)
      <h1>title</h1>
      <ul>
        <li>one</li>
        <li>two</li>
      </ul>
      <p>paragraph and <a href="#">link</a></p>
    EXPECTED
      # title

      * one
      * two

      paragraph and [link](#)
    ACTUALL
  end

  private

  def assert_html(expected, actuall)
    assert_equal normalize(expected), normalize(actuall)
  end

  def normalize(xml)
    document = REXML::Document.new("<html>#{xml.strip}</html>")
    normalized = Class.new(REXML::Formatters::Pretty) do
      def write_text(node, output)
        super(node.to_s.strip, output)
      end
    end
    normalized.new.write(document, result = String.new)
    result
  end
end
