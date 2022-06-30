class StatusMessagesController < ApplicationController

  def import_page
    render text: "Hello World"
  end

  def import
    p 'here'
    StatusMessages.import(current_user, params[:file])
  end
end
