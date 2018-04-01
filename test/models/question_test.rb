# frozen_string_literal: true

require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test '#search' do
    question = users(:john)
               .questions
               .create!(title: 'hello world', content: 'mad world')
    assert Question.search('hello').exists?(question.id)
    assert Question.search('HELLO').exists?(question.id)
    assert Question.search('world').exists?(question.id)
    assert Question.search('worlds').exists?(question.id)
    assert Question.search('mad').exists?(question.id)
    assert Question.search('madness').exists?(question.id)
    refute Question.search('test').exists?(question.id)
  end
end
