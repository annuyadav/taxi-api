require 'rails_helper'

describe DistanceCalculator do
  include DistanceCalculator

  describe 'distance between' do
    it 'gives the distance between two points' do
      expect(distance_between(10,16,13,20)).to eq(5.0)
    end
  end
end