class Taxi < ApplicationRecord
  include DistanceCalculator

  # ==== Validations ===============================================
  validates :location_latitude, :location_longitude, presence: true

  # ==== Scopes ====================================================
  scope :available_taxis, -> { where(booked: false) }

  def self.nearest_to(latitude, longitude, condition={})
    Taxi.available_taxis.where(condition)
        .inject do |nearest_taxi, taxi|
      nearest_taxi.distance_to(latitude, longitude) < taxi.distance_to(latitude, longitude) ? nearest_taxi : taxi
    end
  end

  def distance_to(latitude, longitude)
    distance_between(location_latitude, location_longitude, latitude, longitude)
  end

  def hipster?
    color == 'pink'
  end

  def assign
    update_attribute(:booked, true)
  end

  def unassign
    update_attribute(:booked, false)
  end
end
