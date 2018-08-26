class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]

  # GET /todos
  def index
    @todos = current_user.todos
    json_response(@todos)
  end
  # POST /todos
  def create
    # create! instead of create
    # the model will raise an exception ActiveRecord::RecordInvalid
    # this way we avoid deep nested if statements in the controller
    # we can then rescue from the ExceptionHandler module (controllers/concerns/exception_handler)
    @todo = current_user.todos.create!(todo_params)
    if @todo
      json_response(@todo, :created)
    else
      json_response(@todo, :unprocessable_entity)
    end
  end
  # GET /todos/:id
  def show
    if @todo
      json_response(@todo)
    else
      json_response(@todo, :not_found)
    end
  end
  def update
    @todo.update(todo_params)
    head :no_content
  end
  def destroy
    @todo.destroy
    head :no_content
  end

  private
  def todo_params
    # whitelist params
    params.permit(:title)
  end
  def set_todo
    @todo = Todo.find(params[:id])
  end
end
