class Oystercard

  attr_reader :balance, :in_use, :entry_station

  MAX_BALANCE = 90
  MIN_FARE = 1
  def initialize
    @balance = 0
    @entry_station
  end

  def top_up(amount)
    fail "Can not have more than £#{MAX_BALANCE}" if over_max?(amount)
    @balance += amount
  end

  def touch_in(station)
    fail "Insufficient funds! Your balance is #{@balance},"\
    " minimum fare is #{MIN_FARE}" if minimum_fare?
    # @in_use = true
    @entry_station = station
  end

  def touch_out
    deduct(MIN_FARE)
    # @in_use = false
    @entry_station = nil
  end

  def in_journey?
    !!@entry_station
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
