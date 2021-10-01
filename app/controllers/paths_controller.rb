class PathsController < ApplicationController

  def index
    @paths = current_user.paths.all.order("created_at DESC")
  end

  def show; end


  private

  def path_params
    params.require(:path).permit(:description, :object, :action, :user_id)
  end

end
