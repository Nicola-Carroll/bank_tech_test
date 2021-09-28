# frozen_string_literal: true

require 'transaction_log'

describe TransactionLog do
  let(:today) { Time.new.strftime(TransactionLog::DATE_FORMAT) }
  let(:transaction_class) { double :transaction_class }
  let(:transaction_log) do
    described_class.new(transaction_class: transaction_class)
  end

  context 'there have been deposits and withdrawals' do
    let(:transaction100) { double :transaction, date: today, amount: 100 }
    let(:variable_transaction) { double :variable, date: today }

    context 'there have been deposits' do
      describe '#historical_transaction_dates' do
        it 'records the date a deposit was made' do
          allow(transaction_class).to receive(:new).and_return(transaction100)

          transaction_log.record_transaction(100)
          expect(transaction_log.historical_transaction_dates).to eq [today]
        end

        it 'records the dates of all deposits' do
          allow(transaction_class).to receive(:new).and_return(transaction100)

          3.times { transaction_log.record_transaction(100) }
          expect(transaction_log.historical_transaction_dates).to eq [
               today,
               today,
               today
             ]
        end
      end

      describe '#historical_transaction_amounts' do
        it 'records the amount of a deposit' do
          allow(transaction_class).to receive(:new).and_return(transaction100)

          transaction_log.record_transaction(100)
          expect(transaction_log.historical_transaction_amounts).to eq [100]
        end

        it 'records the amount of all deposits' do
          allow(transaction_class).to receive(:new).and_return(
            variable_transaction
          )
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

          expect(transaction_log.historical_transaction_amounts).to eq [
               150,
               405,
               -50,
               240,
               -100
             ]
        end
      end

      describe '#historical_balances' do
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
          expect(transaction_log.historical_balances).to eq [100]
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

          expect(transaction_log.historical_balances).to eq [150, 100, 340, 240]
        end
      end
    end
  end
end
