class Account
  def initialize
    @transaction_log = []
  end

  def deposit(amount)
    @transaction_log << [Time.new.strftime('%d/%m/%Y'), amount]
  end

  def statement
    statement = ['date || credit || debit || balance']
    @transaction_log.each_with_index do |transaction, index|
      statement.push(
        "#{transaction[0]} || #{transaction[1]} || || #{@transaction_log[0, index].sum { |date, amount| amount } + transaction[1]}"
      )
    end
    statement.join("\n")
  end
end
