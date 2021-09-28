# frozen_string_literal: true

# the user interface of the bank account
class Account
  def initialize(
    transaction_class:,
    transaction_log_class:,
    statement_formatter_class:
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
    @statement_formatter.statement(
      historical_transaction_dates:
        @transaction_log.historical_transaction_dates,
      historical_transaction_amounts:
        @transaction_log.historical_transaction_amounts,
      historical_balances: @transaction_log.historical_balances
    )
  end
end
