class Account
  def initialize
    @transaction_log = []
  end

  def deposit(amount)
    @transaction_log << [Time.new.strftime('%d/%m/%Y'), amount]
  end

  def withdraw(amount)
    deposit(-amount)
  end

  def statement
    statement = ['date || credit || debit || balance']
    @transaction_log.each_with_index do |transaction, index|
      statement.push(render_transaction(index))
    end
    statement.join("\n")
  end

  private

  def account_balance_following_transaction(index)
    transaction = @transaction_log[index]
    @transaction_log[0, index].sum { |date, amount| amount } + transaction[1]
  end

  def render_transaction(index)
    transaction = @transaction_log[index]
    "#{transaction[0]} || #{credit(index)}|| #{debit(index)}|| #{account_balance_following_transaction(index)}"
  end

  def credit(index)
    transaction = @transaction_log[index]
    "#{transaction[1]} " if transaction[1] > 0
  end

  def debit(index)
    transaction = @transaction_log[index]
    "#{-transaction[1]} " if transaction[1] < 0
  end
end
