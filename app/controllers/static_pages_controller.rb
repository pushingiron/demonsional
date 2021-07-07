class StaticPagesController < ApplicationController

  before_action :authenticate_user!

  def index
  end

  def demo_this
    p 'demo this'
  end

  def create_demo
    p params
  end

  def xml_response
    p 'in xml_response'
    @xml = params[:format]
    p @xml
  end

end
