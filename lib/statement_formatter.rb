# frozen_string_literal: true

# formats a statement for a bank account
class StatementFormatter
  STATEMENT_HEADERS = 'date || credit || debit || balance'

  def credit(amount)
    "#{string_with_two_decimals(amount)} " if amount.positive?
  end

  def debit(amount)
    "#{string_with_two_decimals(-amount)} " if amount.negative?
  end

  def balance(amount)
    string_with_two_decimals(amount)
  end

  def transaction(date, amount, total)
    "#{date} ||" \
      " #{credit(amount)}||" \
      " #{debit(amount)}||" \
      " #{balance(total)}"
  end

  def statement(
    historical_transaction_dates:,
    historical_transaction_amounts:,
    historical_balances:
  )
    statement = [STATEMENT_HEADERS]
    historical_transaction_dates.each_with_index do |date, index|
      statement.push(
        transaction(
          date,
          historical_transaction_amounts[index],
          historical_balances[index]
        )
      )
    end
    statement.join("\n")
  end

  def string_with_two_decimals(number)
    format('%.2f', number)
  end
end
