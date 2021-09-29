# frozen_string_literal: true

# manages historical transactions of an account
class TransactionLog
  DATE_FORMAT = '%d/%m/%Y'

  def initialize(transaction_class:)
    @transactions = []
    @transaction_class = transaction_class
  end

  def record_transaction(amount)
    @transactions << @transaction_class.new(date: Time.new, amount: amount)
  end

  def historical_transaction_dates
    @transactions.map { |transaction| transaction.date }
  end

  def historical_transaction_amounts
    @transactions.map { |transaction| transaction.amount }
  end

  def historical_balances
    @transactions.each_with_index.map do |transaction, index|
      total_following_transaction(index)
    end
  end

  private

  def total_following_transaction(index = @transactions.count - 1)
    return nil if @transactions.empty?

    transaction = @transactions[index]
    @transactions[0, index].sum(&:amount) + transaction.amount
  end
end
