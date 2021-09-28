# frozen_string_literal: true

# the account interface, processes deposits, withdrawals, and returns statemnts
class Account
  STATEMENT_HEADERS = 'date || credit || debit || balance'

  def initialize(transaction_log_class:, transaction_class:)
    @transaction_log =
      transaction_log_class.new(transaction_class: transaction_class)
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
    statement = [STATEMENT_HEADERS]
    @transaction_log.transactions.each_with_index do |_transaction, index|
      statement.push(render_transaction(index))
    end
    statement.join("\n")
  end

  private

  def credit(index)
    transaction = @transaction_log.transactions[index]
    "#{string_with_two_decimals(transaction.amount)} " if transaction.amount.positive?
  end

  def debit(index)
    transaction = @transaction_log.transactions[index]
    "#{string_with_two_decimals(-transaction.amount)} " if transaction.amount.negative?
  end

  def total(index)
    string_with_two_decimals(
      @transaction_log.total_following_transaction(index)
    )
  end

  def render_transaction(index)
    transaction = @transaction_log.transactions[index]
    "#{transaction.date} ||" \
      " #{credit(index)}||" \
      " #{debit(index)}||" \
      " #{total(index)}"
  end

  def string_with_two_decimals(number)
    format('%.2f', number)
  end
end
