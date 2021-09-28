# frozen_string_literal: true

require 'transaction_log'

describe TransactionLog do
  let(:today) { Time.new.strftime(TransactionLog::DATE_FORMAT) }
  let(:transaction_class) { double :transaction_class }
  let(:transaction_log) do
    described_class.new(transaction_class: transaction_class)
  end
  let(:variable_transaction) { double :variable, date: today }

  describe '#total_following_transaction' do
    it 'returns zero initially' do
      expect(transaction_log.total_following_transaction).to eq 0
    end

    context 'there have been deposits' do
      let(:transaction100) { double :transaction, date: today, amount: 100 }

      it 'can calculate a total following one deposit' do
        allow(transaction_class).to receive(:new).and_return(transaction100)
        transaction_log.record_transaction(100)
        expect(transaction_log.total_following_transaction).to eq 100
      end

      it 'can calculate an account balance from multiple deposits of 100' do
        allow(transaction_class).to receive(:new).and_return(transaction100)
        3.times { transaction_log.record_transaction(100) }
        expect(transaction_log.total_following_transaction).to eq 300
      end

      it 'can handle varying deposit amounts' do
        allow(transaction_class).to receive(:new).and_return(
          variable_transaction
        )
        allow(variable_transaction).to receive(:amount).and_return(
          150,
          405,
          240
        )
        transaction_log.record_transaction(150)
        transaction_log.record_transaction(405)
        transaction_log.record_transaction(240)
        expect(transaction_log.total_following_transaction).to eq 795
      end
    end

    context 'there have been withdrawals' do
      let(:transaction_negative100) do
        double :transaction, date: today, amount: -100
      end

      it 'can calculate a total following one withdrawal' do
        allow(transaction_class).to receive(:new).and_return(
          transaction_negative100
        )
        transaction_log.record_transaction(-100)
        expect(transaction_log.total_following_transaction).to eq(-100)
      end

      it 'can calculate an account balance from multiple withdrawals of 100' do
        allow(transaction_class).to receive(:new).and_return(
          transaction_negative100
        )
        3.times { transaction_log.record_transaction(-100) }
        expect(transaction_log.total_following_transaction).to eq(-300)
      end

      it 'can combine deposits and withdrawals' do
        allow(transaction_class).to receive(:new).and_return(
          variable_transaction
        )
        allow(variable_transaction).to receive(:amount).and_return(150, -40, 65)
        transaction_log.record_transaction(150)
        transaction_log.record_transaction(-40)
        transaction_log.record_transaction(65)
        expect(transaction_log.total_following_transaction).to eq 175
      end
    end
  end
end
