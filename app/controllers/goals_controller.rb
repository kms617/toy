class GoalsController < ApplicationController
  def index
    @goals = Goal.all.order(created_at: :desc)
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params)

    if @goal.save
      redirect_to @goal
      flash[:notice] = "Your goal has successfully been set!"
    else
      flash[:notice] = "There was a problem, please try again."
      render :new
    end
  end

  def show
    @goal = Goal.find(params[:id])
  end

  def edit
    @goal = Goal.find(params[:id])
  end

  def update
    @goal = Goal.find(params[:id])

    if @goal.update(goal_params)
      flash[:notice] = "Goal Updated"
      redirect_to goal_path
    else
      flash[:notice] = "There was a problem, please try again."
      render :edit
    end
  end

  def destroy
    @goal = Goal.find(params[:id])

    if @goal.destroy
      flash[:notice] = "Goal Deleted"
      redirect_to goals_path
    else
      flash[:alert] = "There was a problem, please try again."
      render :edit
    end
  end

  private

  def goal_params
    params.require(:goal).permit(:goal, :duration, :completed, :objective)
  end
end