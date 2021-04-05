class StaticPagesController < ApplicationController

  def index
  end

  def xml_response
    @xml = params
  end

end
