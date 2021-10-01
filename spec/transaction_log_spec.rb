# frozen_string_literal: true

require 'transaction_log'

describe TransactionLog do
  let(:today) { Time.new }
  let(:transaction_class) { double :transaction_class }
  let(:transaction_log) do
    described_class.new(transaction_class: transaction_class)
  end

  describe '#record_transaction' do
    let(:transaction100) { double :transaction, date: today, amount: 100 }

    it 'creates a new transaction for the correct amount' do
      allow(transaction_class).to receive(:new).with(
        date: anything,
        amount: 100
      )

      expect(transaction_class).to receive(:new).with(
        date: anything,
        amount: 100
      )
      transaction_log.record_transaction(100)
    end

    it 'creates a transaction for the current date' do
      allow(transaction_class).to receive(:new).with(
        date: anything,
        amount: anything
      )

      expect(Time).to receive(:new).with(no_args)
      transaction_log.record_transaction(100)
    end
  end

  context 'there have been deposits and withdrawals' do
    let(:transaction100) { double :transaction, date: today, amount: 100 }
    let(:variable_transaction) { double :variable, date: today }

    describe '#historical_transactions' do
      it 'records the date a deposit was made' do
        allow(transaction_class).to receive(:new).and_return(transaction100)

        transaction_log.record_transaction(100)
        expect(transaction_log.historical_transactions[:dates]).to eq [today]
      end

      it 'records the dates of all deposits' do
        allow(transaction_class).to receive(:new).and_return(transaction100)

        3.times { transaction_log.record_transaction(100) }
        expect(transaction_log.historical_transactions[:dates]).to eq [
             today,
             today,
             today
           ]
      end
    end

    it 'records the amount of a deposit' do
      allow(transaction_class).to receive(:new).and_return(transaction100)

      transaction_log.record_transaction(100)
      expect(transaction_log.historical_transactions[:amounts]).to eq [100]
    end

    it 'records the amount of all deposits' do
      allow(transaction_class).to receive(:new).and_return(variable_transaction)
      allow(variable_transaction).to receive(:amount).and_return(
        150,
        405,
        -50,
        240,
        -100
      )

      transaction_log.record_transaction(150)
      transaction_log.record_transaction(405)
      transaction_log.record_transaction(-50)
      transaction_log.record_transaction(240)
      transaction_log.record_transaction(-100)

      expect(transaction_log.historical_transactions[:amounts]).to eq [
           150,
           405,
           -50,
           240,
           -100
         ]
    end

    let(:transaction150) { double :transaction, date: today, amount: 150 }
    let(:transaction_negative50) do
      double :transaction, date: today, amount: -50
    end
    let(:transaction240) { double :transaction, date: today, amount: 240 }
    let(:transaction_negative100) do
      double :transaction, date: today, amount: -100
    end

    it 'can calculate the balance after a deposit' do
      allow(transaction_class).to receive(:new).and_return(transaction100)

      transaction_log.record_transaction(100)
      expect(transaction_log.historical_transactions[:balances]).to eq [100]
    end

    it 'can calculate the balance after multiple transactions' do
      allow(transaction_class).to receive(:new).and_return(
        transaction150,
        transaction_negative50,
        transaction240,
        transaction_negative100
      )
      allow(variable_transaction).to receive(:amount).and_return(
        150,
        -50,
        240,
        -100
      )

      transaction_log.record_transaction(150)
      transaction_log.record_transaction(-50)
      transaction_log.record_transaction(240)
      transaction_log.record_transaction(-100)

      expect(transaction_log.historical_transactions[:balances]).to eq [
           150,
           100,
           340,
           240
         ]
    end
  end
end
