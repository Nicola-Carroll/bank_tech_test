class Account
  STATEMENT_HEADERS = 'date || credit || debit || balance'

  def initialize(transaction_log_class:)
    @transaction_log = transaction_log_class.new
  end

  def deposit(amount)
    @transaction_log.record_deposit(amount)
  end

  def withdraw(amount)
    @transaction_log.record_withdrawal(amount)
  end

  def statement
    statement = [STATEMENT_HEADERS]
    @transaction_log.transactions.each_with_index do |transaction, index|
      statement.push(render_transaction(index))
    end
    statement.join("\n")
  end

  private

  def credit(index)
    transaction = @transaction_log.transactions[index]
    "#{transaction[1]} " if transaction[1] > 0
  end

  def debit(index)
    transaction = @transaction_log.transactions[index]
    "#{-transaction[1]} " if transaction[1] < 0
  end

  def render_transaction(index)
    transaction = @transaction_log.transactions[index]
    "#{transaction[0]} ||" \
      " #{credit(index)}||" \
      " #{debit(index)}||" \
      " #{@transaction_log.total_following_transaction(index)}"
  end
end
