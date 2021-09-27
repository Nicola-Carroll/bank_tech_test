# frozen_string_literal: true

require 'transaction_log'

describe TransactionLog do
  let(:transaction_log) { described_class.new }
  let(:today) { Time.new.strftime(TransactionLog::DATE_FORMAT) }

  describe '#total_following_transaction' do
    it 'returns zero initially' do
      expect(transaction_log.total_following_transaction).to eq 0
    end

    context 'there have been deposits' do
      it 'can calculate a total following one deposit' do
        transaction_log.record_deposit(100)
        expect(transaction_log.total_following_transaction).to eq 100
      end

      it 'can calculate an account balance from multiple deposits of 100' do
        3.times { transaction_log.record_deposit(100) }
        expect(transaction_log.total_following_transaction).to eq 300
      end

      it 'can handle varying deposit amounts' do
        transaction_log.record_deposit(150)
        transaction_log.record_deposit(405)
        transaction_log.record_deposit(240)
        expect(transaction_log.total_following_transaction).to eq 795
      end
    end

    context 'there have been withdrawals' do
      it 'can calculate a total following one withdrawal' do
        transaction_log.record_withdrawal(100)
        expect(transaction_log.total_following_transaction).to eq(-100)
      end

      it 'can calculate an account balance from multiple withdrawals of 100' do
        3.times { transaction_log.record_withdrawal(100) }
        expect(transaction_log.total_following_transaction).to eq(-300)
      end

      it 'can combine deposits and withdrawals' do
        transaction_log.record_deposit(150)
        transaction_log.record_withdrawal(40)
        transaction_log.record_deposit(65)
        expect(transaction_log.total_following_transaction).to eq 175
      end
    end
  end
end
