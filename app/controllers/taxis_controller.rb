class TaxisController < ApplicationController

  def index
    @taxis = Taxi.all
    json_response(@taxis)
  end
end
