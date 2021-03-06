class TasksController < ApplicationController
  before_filter :prepare_methodologies
  before_action :authenticate_user!
  before_action :set_task, only: [:edit, :update, :destroy]

  def index
    @tasks = Task.all.order(created_at: :desc)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @goal = Goal.find(params[:goal_id])
    @task = Task.new(task_params)
    @task.goal = @goal
    @task.user = current_user

    if @task.save
      flash[:notice] = "Step successfully taken!"
      redirect_to goal_path(@task.goal)
    else
      flash[:alert] = "There was a problem, please try again."
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:notice] = "Task Updated"
      redirect_to task_path(@task)
    else
      flash[:notice] = "There was a problem, please try again."
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:notice] = "Task Deleted"
      redirect_to goals_path
    else
      flash[:alert] = "There was a problem, please try again."
      render :edit
    end
  end

  private

  def set_task
    @task = Task.authorized_find(current_user, params[:id])
  end

  def task_params
    params.require(:task).permit(
      :goal_id,
      :focus,
      :methodology_id,
      :completed,
      :duration,
      :description,
      :action,
      :action_url,
      :secret,
      :user_id
    )
  end

  def prepare_methodologies
    @methodologies = Methodology.all
  end

  def authorize_user
    unless user_signed_in? and current_user.admin?
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
