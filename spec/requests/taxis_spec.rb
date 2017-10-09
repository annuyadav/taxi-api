require 'rails_helper'

RSpec.describe 'TaxisController API', type: :request do
  # Test suite for GET /taxis
  before do
    5.times {create(:taxi)}
  end
  describe 'GET /taxis' do
    # make HTTP get request before each example
    before { get '/taxis' }

    it 'returns taxis' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(Taxi.all.size)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end