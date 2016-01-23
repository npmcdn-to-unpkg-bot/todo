class Api::V1::TasksController < ApplicationController

  skip_before_filter :verify_authenticity_token
  respond_to :json
  # before_filter :find_project
 
 def create
    authorize :read, Project 
    @project=Project.find(params[:id])
    @task=Task.new(task_params)
    @project.tasks<<@task
    if @project.save
      respond_to do |format|
        format.json{ render :json => @project}
      end
    end
  end

  def update
    @project = Project.where("tasks._id" => BSON::ObjectId(params[:id])).first
    @task=@project.tasks.find(params[:id])
    if @task.update(task_params)
      respond_to do |format|
        format.json{ render :json => @task}
      end
    end
  end

  def destroy
    #can't directly find task!
    project = Project.where("tasks._id" => BSON::ObjectId(params[:id])).first
    task=project.tasks.find(params[:id])
   respond_with task.delete
  end

  protected

  def task_params
    params.require(:task).permit(:name)
  end
  
end 