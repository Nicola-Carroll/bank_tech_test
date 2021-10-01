# frozen_string_literal: true
require './lib/transaction'
require './lib/transaction_log'
require './lib/statement_formatter'

# the user interface of the bank account
class Account
  def initialize(
    transaction_class: Transaction,
    transaction_log_class: TransactionLog,
    statement_formatter_class: StatementFormatter
  )
    @transaction_log =
      transaction_log_class.new(transaction_class: transaction_class)
    @statement_formatter = statement_formatter_class.new
  end

  def deposit(amount)
    raise 'Invalid input, please enter a float' unless amount.is_a?(Float)

    @transaction_log.record_transaction(amount)
  end

  def withdraw(amount)
    raise 'Invalid input, please enter a float' unless amount.is_a?(Float)

    @transaction_log.record_transaction(-amount)
  end

  def statement
    @statement_formatter.statement(@transaction_log.historical_transactions)
  end
end
