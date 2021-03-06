class LessonsController < ApplicationController
  def show
    @program = Program.find(params[:program_id])
    @lesson = @program.lessons.find(params[:id])
    @surveys = @lesson.surveys.order(:created_at)
    @instructor = @lesson.instructor

    if @surveys.length > 0
      sum_lo = @surveys.reduce(0) do |acc, survey|
        acc + survey.lo_rating
      end
      @avg_lo_rating = (sum_lo.to_f / @surveys.length).round(1)

      sum_delivery = @surveys.reduce(0) do |acc, survey|
        acc + survey.delivery_rating
      end
      @avg_delivery_rating = (sum_delivery.to_f / @surveys.length).round(1)

      sum_comfort = @surveys.reduce(0) do |acc, survey|
        acc + survey.comfort_rating
      end
      @avg_comfort_rating = (sum_comfort.to_f / @surveys.length).round(1)
    else
      @avg_lo_rating = 0
      @avg_delivery_rating = 0
      @avg_comfort_rating = 0
    end

  end

  def new
    @program = Program.find(params[:program_id])
    @lesson = @program.lessons.new
    @suggested_lesson_number = @program.lessons.length
    @instructors = @program.users
  end

  def create
    @program = Program.find(params[:program_id])
    @lesson = @program.lessons.new(lesson_params)
    if @lesson.save
      redirect_to program_lesson_path(@program, @lesson)
    else
      render :new
    end
  end

  def edit
    @program = Program.find(params[:program_id])
    @lesson = @program.lessons.find(params[:id])
    @instructors = @program.users
  end

  def update
    @program = Program.find(params[:program_id])
    @lesson = @program.lessons.find(params[:id])
    if @lesson.update(lesson_params)
      redirect_to program_lesson_path(@program, @lesson)
    else
      render :edit
    end
  end

  def destroy
    @program = Program.find(params[:program_id])
    @lesson = @program.lessons.find(params[:id])
    if @lesson.destroy
      redirect_to program_path(@program)
    else
      render :edit
    end
  end

  private

  def lesson_params
    params.require(:lesson).permit(:number, :name, :date, :start_time, :end_time, :user_id)
  end
end
