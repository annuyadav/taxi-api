class JourneyController < ApplicationController
  before_action :set_journey, only: [:start, :end, :payment_amount]

  def create
    journey = Journey.new(start_latitude: journey_params[:latitude],
                          start_longitude: journey_params[:longitude],
                          conditions: {color: journey_params[:color]})
    if journey.save
      json_response({journey: journey, message: 'Taxi Assigned Successfully'}, :created)
    else
      json_response('No Taxi Available')
    end
  end

  def start
    json_response({message: @journey.start_journey})
  end

  def end
    message = @journey.end_journey(end_latitude: journey_params[:latitude], end_longitude: journey_params[:longitude])
    json_response({message: message})
  end

  def payment_amount
    json_response({payment_amount: @journey.payment_amount})
  end

  private

  def journey_params
    params.require(:journey).permit(:latitude, :longitude, :color)
  end

  def set_journey
    @journey = Journey.find(params[:id])
  end
end

