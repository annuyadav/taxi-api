require 'rails_helper'

RSpec.describe Taxi, type: :model do
  let!(:taxi) { FactoryGirl.create(:taxi, location_latitude: 11.1, location_longitude: 122.1) }

  # factory
  it 'has a valid factory' do
    expect(taxi).to be_valid
  end

  # db columns
  describe 'db columns' do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
    it { is_expected.to have_db_column(:location_latitude).of_type(:decimal) }
    it { is_expected.to have_db_column(:location_longitude).of_type(:decimal) }
    it { is_expected.to have_db_column(:color).of_type(:string) }
    it { is_expected.to have_db_column(:booked).of_type(:boolean) }
  end

  # scopes
  describe 'scope' do
    describe 'available scope' do
      it 'should return taxis which are available' do
        expect(Taxi.available_taxis).to include(taxi)
      end
      it 'should not return taxis which are not available' do
        taxi.update_attribute(:booked, true)
        expect(Taxi.available_taxis).not_to include(taxi)
      end
    end
  end

  # class methods
  describe 'class methods' do
    describe '.nearest_to' do
      it 'gives the taxi nearest to the given location' do
        taxi_1 = Taxi.create!(location_latitude: 0.0, location_longitude: 0.0)
        taxi_2 = Taxi.create!(location_latitude: 10, location_longitude: 20)
        taxi_3 = Taxi.create!(location_latitude: 8, location_longitude: 9)
        expect(Taxi.nearest_to(14, 8)).to eq(taxi_3)
      end

      it 'gives nil if there are no taxi available' do
        Taxi.create!(location_latitude: 0.0, location_longitude: 0.0).assign
        Taxi.create!(location_latitude: 10, location_longitude: 20).assign
        Taxi.create!(location_latitude: 8, location_longitude: 9).assign
        taxi.assign
        expect(Taxi.nearest_to(14, 8)).to eq(nil)
      end

      it 'gives the taxi nearest to the given location with the condition' do
        taxi_1 = Taxi.create!(location_latitude: 0.0, location_longitude: 0.0, color: 'pink')
        taxi_2 = Taxi.create!(location_latitude: 10, location_longitude: 20)
        taxi_3 = Taxi.create!(location_latitude: 8, location_longitude: 9, color: 'pink')
        expect(Taxi.nearest_to(14, 8, {color: 'pink'})).to eq(taxi_3)
      end

      it 'gives nil if there is no taxi with the condition is available' do
        taxi_1 = Taxi.create!(location_latitude: 0.0, location_longitude: 0.0)
        taxi_2 = Taxi.create!(location_latitude: 10, location_longitude: 20)
        taxi_3 = Taxi.create!(location_latitude: 8, location_longitude: 9)
        expect(Taxi.nearest_to(14, 8, {color: 'pink'})).to eq(nil)
      end
    end
  end

  # validations
  describe 'validations' do
    describe 'location_latitude' do
      context 'when location_latitude is present' do
        it 'should save the record successfully' do
          expect { FactoryGirl.create(:taxi) }.to change(Taxi, :count).by(1)
        end
      end
      context 'when location_latitude is not present' do
        it 'should raise error while saving' do
          initial_count = Taxi.count
          expect { FactoryGirl.create(:taxi, location_latitude: '') }.to raise_error(ActiveRecord::RecordInvalid)
          final_count = Taxi.count
          expect(initial_count).to eq(final_count)
        end
      end
    end

    describe 'location_longitude' do
      context 'when location_longitude is present' do
        it 'should save the record successfully' do
          expect { FactoryGirl.create(:taxi) }.to change(Taxi, :count).by(1)
        end
      end
      context 'when location_longitude is not present' do
        it 'should raise error while saving' do
          initial_count = Taxi.count
          expect { FactoryGirl.create(:taxi, location_longitude: '') }.to raise_error(ActiveRecord::RecordInvalid)
          final_count = Taxi.count
          expect(initial_count).to eq(final_count)
        end
      end
    end
  end

  describe 'distance to' do
    it 'gives the distance from itself to a given point' do
      taxi = Taxi.new(location_latitude: 0.0, location_longitude: 0.0)
      expect(taxi.distance_to(3, 4)).to eq(5.0)
    end
  end

  describe 'booked' do
    it 'should return true if taxi is booked' do
      taxi = Taxi.new(location_latitude: 0.0, location_longitude: 0.0)
      taxi.assign
      expect(taxi).to be_booked
    end

    it 'should return false if taxi is not booked' do
      taxi = Taxi.new(location_latitude: 0.0, location_longitude: 0.0)
      expect(taxi).not_to be_booked
    end
  end

  describe 'assign' do
    it 'should assign a taxi' do
      taxi = Taxi.new(location_latitude: 0.0, location_longitude: 0.0)
      taxi.assign
      expect(taxi).to be_booked
    end
  end

  describe 'unassign' do
    it 'should change the booked status of a taxi' do
      taxi = create(:taxi)
      taxi.unassign
      expect(taxi).not_to be_booked
    end
  end

  describe 'hipster' do
    it 'should be a hipster car if the color is pink' do
      taxi = Taxi.new(location_latitude: 0.0, location_longitude: 0.0, color: 'pink')
      expect(taxi).to be_hipster
    end

    it 'should not be a hipster if the color is nil' do
      taxi = Taxi.new(location_latitude: 0.0, location_longitude: 0.0)
      expect(taxi).not_to be_hipster
    end

    it 'should not be a hipster if the color is not pink' do
      taxi = Taxi.new(location_latitude: 0.0, location_longitude: 0.0, color: 'blue')
      expect(taxi).not_to be_hipster
    end
  end
end