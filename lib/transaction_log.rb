# frozen_string_literal: true

# calculates account balance based on historical transactions
class TransactionLog
  DATE_FORMAT = '%d/%m/%Y'

  attr_reader :transactions

  def initialize
    @transactions = []
  end

  def record_deposit(amount)
    @transactions << { date: Time.new.strftime(DATE_FORMAT), amount: amount }
  end

  def record_withdrawal(amount)
    record_deposit(-amount)
  end

  def total_following_transaction(index = (@transactions.count - 1))
    return 0 if @transactions.empty?

    transaction = @transactions[index]
    @transactions[0, index].sum { |transaction| transaction[:amount] } +
      transaction[:amount]
  end
end
