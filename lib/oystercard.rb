class Oystercard

  attr_reader :balance, :entry_station, :exit_station, :journeys

  MAX_BALANCE = 90
  MIN_FARE = 1

  def initialize
    @balance = 0
    @journeys = []
  end

  def top_up(amount)
    fail "Cannot have more than £#{MAX_BALANCE}" if over_max?(amount)
    @balance += amount
  end

  def touch_in(station)
    fail "Insufficient funds! Your balance is #{@balance},"\
    " minimum fare is #{MIN_FARE}" if minimum_fare?
    @entry_station = station
    @exit_station = nil
  end

  def touch_out(station)
    deduct(MIN_FARE)
    @exit_station = station
    @journeys << {entry_station: @entry_station, exit_station: @exit_station}
    @entry_station = nil
  end

  def in_journey?
    !!@entry_station
  end

  def save_journey
  end

  private

  def over_max?(amount)
    @balance + amount > MAX_BALANCE
  end

  def minimum_fare?
    @balance < MIN_FARE
  end

  def deduct(amount)
    @balance -= amount
  end

end
