class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_admin!, only: [:destroy, :show, :edit] # `only` part if applicable
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @users = User.all
  end

  def edit; end

  def show; end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
end
