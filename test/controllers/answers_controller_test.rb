# frozen_string_literal: true

require 'test_helper'

class AnswersControllerTest < ActionDispatch::IntegrationTest
  include ActionView::RecordIdentifier

  setup do
    @user = users(:john)
    @answer = answers(:john_to_mary)
    @question = @answer.question
    @others_answer = answers(:mary_to_john)
  end

  test 'guest should not create an answer' do
    get new_question_answer_url(@question)
    assert_redirected_to root_url
    post question_answers_url(@question)
    assert_redirected_to root_url
  end

  test 'user should create an answer' do
    sign_in_as(@user)
    get new_question_answer_url(@question)
    assert_response :success

    content = SecureRandom.hex
    assert_difference('Answer.count') do
      post question_answers_url(@question), params: { answer: {
        content: content
      } }
    end
    assert_equal content, Answer.last.content
    assert_equal @question, Answer.last.question
    assert_equal @user, Answer.last.user
    assert_redirected_to question_url(@question, anchor: dom_id(Answer.last))
  end

  test 'guest should not update an answer' do
    get edit_question_answer_url(@question, @answer)
    assert_redirected_to root_url
    patch question_answer_url(@question, @answer)
    assert_redirected_to root_url
  end

  test 'user should update an owned answer' do
    sign_in_as(@user)
    get edit_question_answer_url(@question, @answer)
    assert_response :success

    content = SecureRandom.hex
    patch question_answer_url(@question, @answer), params: {
      answer: { content: content }
    }
    @answer.reload
    assert_equal content, @answer.content
    assert_redirected_to question_path(@question, anchor: dom_id(@answer))
  end

  test 'user should not update others\' answer' do
    sign_in_as(@user)
    get edit_question_answer_url(@others_answer.question, @others_answer)
    assert_redirected_to root_url

    patch question_answer_url(@others_answer.question, @others_answer)
    assert_redirected_to root_url
  end

  test 'guest should not destroy an answer' do
    assert_difference('Answer.count', 0) do
      delete question_answer_url(@question, @answer)
    end
    assert_redirected_to root_url
  end

  test 'user should destroy an owned answer' do
    sign_in_as(@user)
    assert_difference('Answer.count', -1) do
      delete question_answer_url(@question, @answer)
    end
    assert_redirected_to @question
  end

  test 'user should not destroy others\' answer' do
    sign_in_as(@user)
    assert_difference('Answer.count', 0) do
      delete question_answer_url(@others_answer.question, @others_answer)
    end
    assert_redirected_to root_url
  end
end
