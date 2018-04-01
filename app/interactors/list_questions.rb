# frozen_string_literal: true

class ListQuestions
  attr_reader :questions, :pagination

  def initialize(repo:, params:)
    @repo = repo
    @params = params
  end

  def perform
    questions = @repo.list
    questions = questions.search(@params[:q]) if @params[:q]
    paginate = Paginate.new(repo: questions, page: @params[:page].to_i)
    paginate.perform
    @pagination = paginate.pagination
    questions = paginate.records
    @questions = questions.map { |question| QuestionPresenter.new(question) }
  end
end
