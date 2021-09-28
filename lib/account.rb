# frozen_string_literal: true

# account interface, processes deposits, withdrawals, and returns statemnts
class Account
  STATEMENT_HEADERS = 'date || credit || debit || balance'

  def initialize(transaction_log_class:)
    @transaction_log = transaction_log_class.new
  end

  def deposit(amount)
    raise 'Invalid input, please enter a float' unless amount.is_a?(Float)

    @transaction_log.record_deposit(amount)
  end

  def withdraw(amount)
    raise 'Invalid input, please enter a float' unless amount.is_a?(Float)

    @transaction_log.record_withdrawal(amount)
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
    "#{'%.2f' % transaction[1]} " if (transaction[1]).positive?
  end

  def debit(index)
    transaction = @transaction_log.transactions[index]
    "#{'%.2f' % -transaction[1]} " if (transaction[1]).negative?
  end

  def total(index)
    '%.2f' % @transaction_log.total_following_transaction(index)
  end

  def render_transaction(index)
    transaction = @transaction_log.transactions[index]
    "#{transaction[0]} ||" \
      " #{credit(index)}||" \
      " #{debit(index)}||" \
      " #{total(index)}"
  end
end
