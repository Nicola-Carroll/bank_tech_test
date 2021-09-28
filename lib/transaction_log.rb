# frozen_string_literal: true

# calculates account balance based on historical transactions
class TransactionLog
  DATE_FORMAT = '%d/%m/%Y'

  attr_reader :transactions

  def initialize
    @transactions = []
  end

  def record_transaction(amount)
    @transactions << { date: Time.new.strftime(DATE_FORMAT), amount: amount }
  end

  def total_following_transaction(index = @transactions.count - 1)
    return 0 if @transactions.empty?

    transaction = @transactions[index]
    @transactions[0, index].sum do |previous_transaction|
      previous_transaction[:amount]
    end + transaction[:amount]
  end
end
