class Admin::TasksController < Admin::AdminController
  before_action :set_journey
  before_action :set_step
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  def index
    @tasks = @step.tasks.all
  end

  # GET /tasks/new
  def new
    @task = @step.new_task
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @task = @step.tasks.new(task_params)

    if @task.save
      redirect_to admin_journey_step_tasks_url(@task.step.journey, @task.step), notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tasks/1
  def update
    task_class = task_params[:type]
    raise unless task_class.in?(Task.subclasses.map(&:name))
	  @task = @task.becomes!(task_class.constantize)
    if @task.update(task_params)
      redirect_to admin_journey_step_tasks_url(@task.step.journey, @task.step), notice: 'Task was successfully updated.'
    else
	  render :edit
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to admin_journey_step_tasks_url(@task.step.journey, @task.step), notice: 'Task was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_journey
    @journey = Journey.find_by!(slug: params[:journey_id])
  end

  def set_step
    @step = @journey.steps.find_by!(slug: params[:step_id])
  end

  def set_task
    @task = @step.tasks.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:step_id, :title, :type, :url, :url_title, :position)
  end
end
