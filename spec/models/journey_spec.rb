require 'rails_helper'

RSpec.describe Journey, type: :model do
  let!(:journey) { FactoryGirl.create(:journey, start_latitude: 11.1, start_longitude: 122.1) }

  # factory
  it 'has a valid factory' do
    expect(journey).to be_valid
  end

  # db columns
  describe 'db columns' do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
    it { is_expected.to have_db_column(:taxi_id).of_type(:integer) }
    it { is_expected.to have_db_column(:start_latitude).of_type(:decimal) }
    it { is_expected.to have_db_column(:start_longitude).of_type(:decimal) }
    it { is_expected.to have_db_column(:end_latitude).of_type(:decimal) }
    it { is_expected.to have_db_column(:end_longitude).of_type(:decimal) }
    it { is_expected.to have_db_column(:start_time).of_type(:datetime) }
    it { is_expected.to have_db_column(:end_time).of_type(:datetime) }
  end

  # associations
  describe 'associations' do
    it { is_expected.to belong_to(:taxi) }
  end

  # validations

  describe 'validations' do
    it 'assigns a customer location to a taxi' do
      latitude = 10
      longitude = 20
      taxi = Taxi.create(location_latitude: 0, location_longitude: 0)
      journey = Journey.new(start_latitude: latitude, start_longitude: longitude)
      journey.save
      expect(journey.errors.full_messages).to eq([])
      expect(taxi.reload).to be_booked
    end

    it 'should not assign a taxi if no taxi is available' do
      latitude = 10
      longitude = 20
      journey = Journey.new(start_latitude: latitude, start_longitude: longitude)
      journey.save
      expect(journey.errors.full_messages).to eq(["Taxi can't be blank"])
    end

    it 'should accept conditions about the taxi when assigning a taxi to a customer' do
      latitude = 10
      longitude = 20
      taxi = Taxi.create(location_latitude: 0, location_longitude: 0, color: 'pink')
      journey = Journey.new(start_latitude: latitude, start_longitude: longitude, conditions: {color: 'pink'})
      journey.save
      expect(journey.errors.full_messages).to eq([])
      expect(taxi.reload).to be_booked
    end

    it 'should not assign a taxi if no taxi with the given condition is available' do
      latitude = 10
      longitude = 20
      Taxi.create(location_latitude: 10, location_longitude: 10)
      journey = Journey.new(start_latitude: latitude, start_longitude: longitude, conditions: {color: 'pink'})
      journey.save
      expect(journey.errors.full_messages).to eq(["Taxi can't be blank"])
    end

    it 'should assign a taxi with conditions if that is the closest to the customer' do
      latitude = 10
      longitude = 20
      taxi_1 = Taxi.create(location_latitude: 10, location_longitude: 10, color: 'pink')
      taxi_2 = Taxi.create(location_latitude: 10, location_longitude: 20)
      journey = Journey.new(start_latitude: latitude, start_longitude: longitude, conditions: {color: 'pink'})
      journey.save
      expect(journey.errors.full_messages).to eq([])
      expect(taxi_1.reload).to be_booked
      expect(taxi_2.reload).not_to be_booked
    end
  end

  describe 'distance to' do
    it 'gives the distance from itself to a given point' do
      taxi = Taxi.new(location_latitude: 0.0, location_longitude: 0.0)
      expect(taxi.distance_to(3, 4)).to eq(5.0)
    end
  end

  describe 'start_journey' do
    it 'adds the start time of the trip' do
      Taxi.create(location_latitude: 0, location_longitude: 0)
      journey = Journey.create!(start_latitude: 10, start_longitude: 10)
      journey.start_journey
      expect(journey.start_time).not_to be_nil
    end
  end

  describe 'end_journey' do
    it 'adds the end time and end location of the trip' do
      journey = create(:started_journey)
      journey = Journey.find(journey.id)
      journey.end_journey(end_latitude: 10, end_longitude: 20)
      expect(journey.end_latitude).to eq(10)
      expect(journey.end_longitude).to eq(20)
      expect(journey.end_time).not_to be_nil
    end

    it 'unassigns the taxi' do
      taxi = create(:taxi)
      journey = create(:started_journey, taxi: taxi)
      journey = Journey.find(journey.id)
      journey.end_journey(end_latitude: 10, end_longitude: 20)
      expect(taxi).not_to be_booked
    end
  end

  describe 'payment amount' do
    it 'returns the amount that has to be paid by the customer for the ride' do
      t = Time.now
      journey = create(:ended_journey, start_time: t, end_time: t + 30.minutes)
      journey = Journey.find(journey.id)
      expect(journey.payment_amount).to eq(50)
    end

    it 'returns the amount with the extras when a hipster taxi is used' do
      t = Time.now
      taxi = Taxi.create!(location_latitude: 0, location_longitude: 0, color: 'pink')
      journey = create(:ended_journey,taxi: taxi, start_time: t, end_time: t + 30.minutes)
      journey = Journey.find(journey.id)
      expect(journey.reload.payment_amount).to eq(55)
    end
  end
end