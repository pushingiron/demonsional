class StaticPagesController < ApplicationController

  def index
  end

  def xml_response
    p 'in xml_response'
    @xml = params[:format]
    p @xml
  end

end
