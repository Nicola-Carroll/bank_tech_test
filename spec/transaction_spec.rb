# frozen_string_literal: true

require 'timecop'

require 'transaction'

describe Transaction do
  let(:test_date) { Time.new(2021, 1, 1) }
  let(:transaction) { described_class.new(date: test_date, amount: 100) }

  describe '#new' do
    it 'stores the correct time' do
      expect(transaction.date).to eq test_date
    end

    it 'stores the correct amount' do
      expect(transaction.amount).to eq 100
    end
  end
end
