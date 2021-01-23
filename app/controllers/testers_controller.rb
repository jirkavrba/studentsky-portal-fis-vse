class TestersController < ApplicationController
  before_action :authenticate!
  before_action :set_tester, only: %i[show edit update destroy]
  
  def index
  end

  def new
    @subjects = Subject.all
    @tester = Tester.new
  end

  def store
    @tester = current_user.testers.new tester_params
  end

  def show
    authorize! :view, @tester
  end

  def edit
    authorize! :manage, @tester
  end

  def update
    authorize! :manage, @tester
  end

  def destroy
    authorize! :manage, @tester
  end

  private

  def set_tester
    @tester = Tester.find params[:id]
  end

  def tester_params
    params.require(:tester).permit(:title, :subject_id, :questions)
  end
end
