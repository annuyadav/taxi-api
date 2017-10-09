require 'rails_helper'

RSpec.describe 'JourneyController API', type: :request do

  describe 'POST create' do
    it 'assigns a taxi to a customer in the given location' do
      taxi = Taxi.create!(location_latitude: 0, location_longitude: 0)
      args = {
          journey: {
              latitude: 10,
              longitude: 10
          }}

      expect {
        post '/journey', args
      }.to change { Journey.count }.by(1)
      expect(taxi.reload).to be_booked
      _body = response.body
      _response = JSON.parse(_body)
      expect(_response['message']).to eq('Taxi Assigned Successfully')
     end

    it 'assigns an hipster taxi when requested' do
      taxi = Taxi.create!(location_latitude: 0, location_longitude: 0, color: 'pink')
      args = {
          journey: {
              latitude: 10,
              longitude: 10,
              color: 'pink'
          }}
      expect {
        post '/journey', args
      }.to change { Journey.count }.by(1)
      expect(taxi.reload).to be_booked
      _body = response.body
      _response = JSON.parse(_body)
      expect(_response['message']).to eq('Taxi Assigned Successfully')
    end

    it 'responds with a failure message if there are no taxis available' do
      args = {
          journey: {
              latitude: 10,
              longitude: 10
          }}
      expect {
        post '/journey', args
      }.to change { Journey.count }.by(0)
      expect(response.body).to include('No Taxi Available')
    end
  end

  describe 'PUT start' do
    it 'starts the journey from the customer location' do
      journey = create(:unstarted_journey)
      put "/journey/#{journey.id}/start"
      expect(journey.reload.start_time).not_to be_nil
      _body = response.body
      _response = JSON.parse(_body)
      expect(_response['message']).to eq('Journey Started Successfully')
    end

    it 'returns an error message when start is called on a a started journey' do
      journey = create(:started_journey)
      put "/journey/#{journey.id}/start"
      _body = response.body
      _response = JSON.parse(_body)
      expect(_response['message']).to eq('Unable to start the journey')
    end

    it 'returns an error message when start is called on a a ended journey' do
      journey = create(:ended_journey)
      put "/journey/#{journey.id}/start"
      _body = response.body
      _response = JSON.parse(_body)
      expect(_response['message']).to eq('Unable to start the journey')
    end

  end

  describe 'PUT end' do
    it 'ends the journey at the given location and unassigns the taxi' do
      taxi = create(:taxi)
      journey = create(:started_journey, taxi: taxi)
      args = {
          id: journey.id,
          journey: {
              latitude: 10,
              longitude: 20
          }}
      put "/journey/#{journey.id}/end", args
      _body = response.body
      _response = JSON.parse(_body)
      expect(_response['message']).to eq('Journey Ended Successfully and the amount is: 45')
      expect(taxi).not_to be_booked
    end

    it 'gives an error message for an unstarted journey' do
      journey = create(:unstarted_journey)
      args = {
          id: journey.id,
          journey: {
              latitude: 10,
              longitude: 20
          }}
      put "/journey/#{journey.id}/end", args
      _body = response.body
      _response = JSON.parse(_body)
      expect(_response['message']).to eq('Unable to End the journey')
    end

    it 'gives an error message for an ended journey' do
      journey = create(:ended_journey)
      args = {
          id: journey.id,
          journey: {
              latitude: 10,
              longitude: 20
          }}
      put "/journey/#{journey.id}/end", args
      _body = response.body
      _response = JSON.parse(_body)
      expect(_response['message']).to eq('Unable to End the journey')
    end

    it 'gives an error message for invalid arguments' do
      journey = create(:started_journey)
      args = {
          id: journey.id,
          journey: {
              latitude: 10
          }}
      put "/journey/#{journey.id}/end", args
      _body = response.body
      _response = JSON.parse(_body)
      expect(_response['message']).to eq("Unable to end journey because: End longitude can't be blank")
    end
  end

  describe 'GET payment amount' do
    it 'gets the amount that has to be paid by the customer for the journey' do
      journey = create(:ended_journey)
      get "/journey/#{journey.id}/payment_amount"
      _body = response.body
      _response = JSON.parse(_body)
      expect(_response['payment_amount']).to eq(20)
    end

    it 'gives an error message for a journey that is unstarted' do
      journey = create(:unstarted_journey)
      get "/journey/#{journey.id}/payment_amount"
      _body = response.body
      _response = JSON.parse(_body)
      expect(_response['payment_amount']).to eq('Unable to calculate Amount of journey')
    end

    it 'gives an error message for a journey that is started' do
      journey = create(:started_journey)
      get "/journey/#{journey.id}/payment_amount"
      _body = response.body
      _response = JSON.parse(_body)

      expect(_response['payment_amount']).to eq('Unable to calculate Amount of journey')
    end
  end
end
