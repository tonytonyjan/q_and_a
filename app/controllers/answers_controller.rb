# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :set_question
  before_action :authenticate_user!
  before_action :set_answer, only: %i[edit update destroy]
  before_action :authenticate_owner!, only: %i[edit update destroy]

  def new
    @answer = Answer.new
  end

  def create
    @answer = current_user.answers.new(answer_params)

    if @answer.save
      redirect_to question_path(@question, anchor: helpers.dom_id(@answer)),
                  notice: 'Answer was successfully created.'
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(@question, anchor: helpers.dom_id(@answer))
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to @question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:content).merge(question_id: @question.id)
  end

  def authenticate_owner!
    unless @answer.belongs_to?(current_user)
      redirect_back fallback_location: root_path, alert: 'you are not allowed'
    end
  end
end
