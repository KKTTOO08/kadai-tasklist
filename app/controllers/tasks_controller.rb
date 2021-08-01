class TasksController < ApplicationController
    before_action :require_user_logged_in
    before_action :correct_user, only: [:destroy, :update, :edit]
    
    def index
        @tasks = Task.all
    end
    
    def show
        @task = Task.find(params[:id])
    end
    
    #toppagesの方で作成
    #def new
        #@task = Task.new
    #end
    
    def create
        @task = current_user.tasks.build(task_params)
        
        if @task.save
            flash[:success] = 'タスクが正常に記録されました'
            redirect_to root_url
        else
          @pagy, @tasks = pagy(current_user.tasks.order(id: :desc))
          flash.now[:danger] = 'タスクの記録に失敗しました。'
          render 'toppages/index'
        end
    end
    
    def edit
        @task = Task.find(params[:id])
    end
    
    #要修正
    def update
        if @task.update(task_params)
        flash[:success] = 'タスクは正常に更新されました'
        redirect_to root_url
        else
        flash.now[:danger] = 'タスクは更新されませんでした'
        render :edit
        end
    end
    
    def destroy
        @task.destroy
        flash[:success] = 'タスクは正常に削除されました'
        redirect_back(fallback_location: root_path)
    end
    
    private
    
    def task_params
        params.require(:task).permit(:content, :status)
    end
    
    def correct_user
        @task = current_user.tasks.find_by(id: params[:id])
        unless @task
            redirect_to root_url
        end
    end
    
end
