module Constants
  BEGINNING_OF_TODAY = Time.now.in_time_zone("Tokyo").beginning_of_day
  BEGINNING_OF_TOMORROW = BEGINNING_OF_TODAY.tomorrow
end