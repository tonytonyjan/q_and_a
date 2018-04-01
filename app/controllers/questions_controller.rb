# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_question, only: %i[show edit update destroy]
  before_action :authenticate_owner!, only: %i[edit update destroy]

  def index
    list_questions = ListQuestions.new(repo: Question, params: params)
    list_questions.perform
    @questions = list_questions.questions
    @pagination = list_questions.pagination
  end

  def show
    paginate = Paginate.new(repo: @question.answers.list, page: params[:page].to_i)
    paginate.perform
    @question = QuestionPresenter.new(@question)
    @pagination = paginate.pagination
    @answers = paginate.records.map { |answer| AnswerPresenter.new(answer) }
  end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = current_user.questions.create(question_params)

    if @question.save
      redirect_to @question, notice: 'Question was successfully created.'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to root_url, notice: 'Question was successfully destroyed.'
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :content)
  end

  def authenticate_owner!
    unless @question.belongs_to?(current_user)
      redirect_back fallback_location: root_path, alert: 'you are not allowed'
    end
  end
end
