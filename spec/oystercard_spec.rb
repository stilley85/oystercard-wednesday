require 'oystercard'

describe Oystercard do

  max_balance = Oystercard::MAX_BALANCE
  minimum_fare = Oystercard::MIN_FARE

  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  let(:journey) { {entry_station: entry_station, exit_station: exit_station} }

  context '#initialize' do

    it "initializes with a balance of 0" do
      expect(subject.balance).to eq(0)
    end

    it "initializes with in_journey? set to false" do
      expect(subject.in_journey?).to eq(false)
    end

    it 'initializes an entry station variable with nil value' do
      expect(subject.entry_station).to eq nil
    end

    it "initializes with an empty journey history" do
      expect(subject.journeys).to be_empty
    end

  end

  context '#top_up' do

    it 'tops up card balance with given amount' do
      expect { subject.top_up(10) }.to change { subject.balance }.by(10)
    end

    it 'prevents top up if that would exceed maximum_balance' do
      subject.top_up(max_balance)
      expect { subject.top_up(1) }.to raise_error("Cannot have more than £#{max_balance}")
    end

  end

  context 'touching in and out (money added to card)' do

    before(:each) do
      subject.top_up(max_balance)
      subject.touch_in(entry_station)
    end

    context "#touch_in" do

      it "in_journey? changed to true when touch_in is called" do
        expect(subject.in_journey?).to eq(true)
      end

      it 'touches in and remembers entry station' do
        expect(subject.entry_station).to eq(entry_station)
      end

      it 'sets exit station to nil when touching in' do
        subject.touch_out(exit_station)
        subject.touch_in(entry_station)
        expect(subject.exit_station).to eq(nil)
      end

    end

    context "#touch_out" do

      before(:each) do
        subject.touch_out(exit_station)
      end

      it "in_journey? changed to false when touch_out is called" do
        expect(subject.in_journey?).to eq(false)
      end

      it "deducts minimum fare from balance when touching out" do
        expect{ subject.touch_out(exit_station) }.to change{ subject.balance }.by(-minimum_fare)
      end

      it 'sets entry station to nil when touching out' do
        expect(subject.entry_station).to eq(nil)
      end

      it "remembers the exit station when touching out" do
        expect(subject.exit_station).to eq(exit_station)
      end

    context "#save_journey" do
      it "saves the journey history when touching out" do
        expect(subject.journeys).to eq([journey])
      end
    end

    end

  end

end
