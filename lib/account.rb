class Account
  def initialize
    @transaction_log = []
  end

  def deposit
    @transaction_log << [Time.new.strftime('%d/%m/%Y'), 100]
  end

  def statement
    statement = ['date || credit || debit || balance']
    @transaction_log.each_with_index do |transaction, index|
      statement.push("#{transaction[0]} || 100 || || #{100 * (index + 1)}")
    end
    statement.join("\n")
  end
end
