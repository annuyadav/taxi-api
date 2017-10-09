FactoryGirl.define do
  factory :journey do
    taxi { create(:taxi) }
    start_latitude '9.99'
    start_longitude '9.99'
    end_latitude '19.99'
    end_longitude '29.99'
  end

  factory :unstarted_journey, class: Journey do
    taxi { create(:taxi) }
    start_latitude 0.0
    start_longitude 0.0
    state 0
  end

  factory :started_journey, class: Journey do
    taxi { create(:taxi) }
    start_latitude 0.0
    start_longitude 0.0
    start_time { DateTime.current }
    state 1
  end

  factory :ended_journey, class: Journey do
    taxi { create(:taxi) }
    start_latitude 0.0
    start_longitude 0.0
    end_latitude 10.0
    end_longitude 0.0
    start_time { DateTime.current }
    end_time { DateTime.current }
    state 2
  end
end
