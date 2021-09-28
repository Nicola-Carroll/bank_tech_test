# frozen_string_literal: true

# manages historical transactions of an account
class TransactionLog
  DATE_FORMAT = '%d/%m/%Y'

  attr_reader :transactions

  def initialize(transaction_class:)
    @transactions = []
    @transaction_class = transaction_class
  end

  def record_transaction(amount)
    @transactions <<
      @transaction_class.new(
        date: Time.new.strftime(DATE_FORMAT),
        amount: amount
      )
  end

  def total_following_transaction(index = @transactions.count - 1)
    return 0 if @transactions.empty?

    transaction = @transactions[index]
    @transactions[0, index].sum(&:amount) + transaction.amount
  end
end
