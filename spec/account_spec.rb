# frozen_string_literal: true

require 'account'
require 'statement_formatter'

describe Account do
  let(:transaction_log) do
    double :transaction_log,
           historical_transaction_dates: 'test',
           historical_transaction_amounts: 'test',
           historical_balances: 'test'
  end
  let(:transaction_log_class) do
    double :transaction_log_class, new: transaction_log
  end
  let(:transaction_class) { double :transaction_class }
  let(:statement_formatter) { double :statement_formatter, statement: 'test' }
  let(:statement_formatter_class) do
    double :statement_formatter_class, new: statement_formatter
  end
  let(:account) do
    described_class.new(
      transaction_class: transaction_class,
      transaction_log_class: transaction_log_class,
      statement_formatter_class: statement_formatter_class
    )
  end

  describe '#deposit' do
    it 'does not accept strings' do
      expect do
        account.deposit('100')
      end.to raise_error 'Invalid input, please enter a float'
    end

    it 'only accepts floats' do
      expect do
        account.deposit(100)
      end.to raise_error 'Invalid input, please enter a float'
    end

    it 'records a deposit in the transaction log' do
      expect(transaction_log).to receive(:record_transaction).with(100.0)
      account.deposit(100.0)
    end
  end

  describe '#withdraw' do
    it 'does not accept strings' do
      expect do
        account.withdraw('100')
      end.to raise_error 'Invalid input, please enter a float'
    end

    it 'only accepts floats' do
      expect do
        account.withdraw(100)
      end.to raise_error 'Invalid input, please enter a float'
    end

    it 'records a withdrawal in the transaction log' do
      expect(transaction_log).to receive(:record_transaction).with(-100.0)
      account.withdraw(100.0)
    end
  end

  describe '#statement' do
    it 'calls on the statement formatter class' do
      expect(statement_formatter).to receive(:statement)

      account.statement
    end

    it 'uses all historical transaction dates' do
      expect(transaction_log).to receive(:historical_transaction_dates)

      account.statement
    end

    it 'uses all historical transaction amounts' do
      expect(transaction_log).to receive(:historical_transaction_amounts)

      account.statement
    end

    it 'uses all historical balances' do
      expect(transaction_log).to receive(:historical_balances)

      account.statement
    end
  end
end
