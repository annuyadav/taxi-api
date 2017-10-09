class Journey < ApplicationRecord
  include DistanceCalculator

  # ==== Constants =================================================
  PERKM = 2.0
  PERMIN = 1.0
  HIPSTERCAR = 5.0

  # ==== Validations ===============================================
  validates :taxi, :start_latitude, :start_longitude, presence: true
  validates :end_latitude, :end_longitude, presence: true, if: Proc.new { |journey| journey.ended? }

  # ==== Callbacks =================================================
  before_validation :assign_taxi, if: :new_record?

  # ==== Associations ==============================================
  belongs_to :taxi

  # ==== Enum ======================================================
  enum state: [:unstarted, :started, :ended]

  # ==== Attribute accessor ========================================
  attr_accessor :conditions


  def start_journey
    if unstarted?
      if self.update_attributes(start_time: DateTime.current, state: 'started')
        'Journey Started Successfully'
      end
    else
      'Unable to start the journey'
    end
  end

  def end_journey(destination)
    if started?
      if self.update_attributes(end_time: DateTime.current,
                                end_latitude: destination[:end_latitude],
                                end_longitude: destination[:end_longitude],
                                state: 'ended')
        taxi.unassign
        "Journey Ended Successfully and the amount is: #{payment_amount}"
      else
        "Unable to end journey because: #{self.errors.full_messages.join(' ')}"
      end
    else
      'Unable to End the journey'
    end

  end

  def payment_amount
    if ended?
      (travelled_time * PERMIN + travelled_distance * PERKM + extras.to_f).ceil
    else
      'Unable to calculate Amount of journey'
    end
  end

  private
  def travelled_time
    (end_time - start_time)/60
  end

  def travelled_distance
    distance_between(start_latitude, start_longitude, end_latitude, end_longitude)
  end

  def extras
    HIPSTERCAR if taxi.hipster?
  end

  def assign_taxi
    self.taxi = Taxi.nearest_to(self.start_latitude, self.start_longitude, conditions)
    self.taxi.assign if self.taxi
  end
end