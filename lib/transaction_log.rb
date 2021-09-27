class TransactionLog
  attr_reader :transactions

  def initialize
    @transactions = []
  end

  def record_deposit(amount)
    @transactions << [Time.new.strftime('%d/%m/%Y'), amount]
  end

  def record_withdrawal(amount)
    record_deposit(-amount)
  end

  def total_following_transaction(index = (@transactions.count - 1))
    return 0 if @transactions.empty?
    transaction = @transactions[index]
    @transactions[0, index].sum { |date, amount| amount } + transaction[1]
  end
end
