class TestersController < ApplicationController
  before_action :authenticate!
  before_action :set_tester, only: %i[show edit update destroy]

  def index
    @testers = Tester.visible_by(current_user)
                     .preload(:subject)
                     .where(params.permit(:subject_id))

    @subjects = Subject.where(id: @testers.pluck(:subject_id)).all

    if @testers.empty?
      return redirect_to testers_url, alert: 'Pro tento předmět nebyly nalezeny žádné testery.'
    end
  end

  def new
    @tester = Tester.new
    @subjects = Subject.all
  end

  def create
    @tester = current_user.testers.new(tester_params)

    if @tester.save
      redirect_to testers_url, notice: 'Tester byl úspěšně vytvořen.'
    else
      redirect_back fallback_location: new_tester_url
    end
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
    params.require(:tester).permit(:title, :subject_id, :questions, :is_public)
  end
end
