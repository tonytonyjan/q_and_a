# frozen_string_literal: true

require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    @question = questions(:john)
    @others_question = questions(:mary)
  end

  test 'guest should read a question' do
    get question_url(@question)
    assert_response :success
  end

  test 'user should read a question' do
    sign_in_as(@user)
    get question_url(@question)
    assert_response :success
  end

  test 'guest should not create a question' do
    get new_question_url
    assert_redirected_to root_url
    post questions_url
    assert_redirected_to root_url
  end

  test 'user should creat a question' do
    sign_in_as(@user)
    get new_question_url
    assert_response :success

    assert_difference('Question.count') do
      post questions_url, params: {
        question: { title: 'title', content: 'content' }
      }
    end
    assert_redirected_to Question.last
  end

  test 'guest should not update a question' do
    get edit_question_url(@question)
    assert_redirected_to root_url
    patch question_url(@question)
    assert_redirected_to root_url
  end

  test 'user should update an owned question' do
    sign_in_as(@user)
    get edit_question_url(@question)
    assert_response :success
    content = SecureRandom.hex
    patch question_url(@question), params: { question: { content: content } }
    @question.reload
    assert_equal content, @question.content
    assert_redirected_to @question
  end

  test 'user should not update others\' question' do
    sign_in_as(@user)
    get edit_question_url(@others_question)
    assert_redirected_to root_url
    patch question_url(@others_question), params: {
      question: { content: 'content' }
    }
    assert_redirected_to root_url
  end

  test 'guest should not destroy a question' do
    assert_difference('Question.count', 0) do
      delete question_url(@question)
    end
    assert_redirected_to root_url
  end

  test 'user should destroy an owned question' do
    sign_in_as(@user)
    assert_difference('Question.count', -1) do
      delete question_url(@question)
    end
    assert_redirected_to root_url
  end

  test 'user should not destroy others\' question' do
    sign_in_as(@user)
    assert_difference('Question.count', 0) do
      delete question_url(@others_question)
    end
    assert_redirected_to root_url
  end
end
