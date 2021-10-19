# frozen_string_literal: true

# formats a statement for a bank account
class StatementFormatter
  STATEMENT_HEADERS = 'date || credit || debit || balance'
  DATE_FORMAT = '%d/%m/%Y'

  def statement(historical_transactions)
    statement_rows(
      historical_transactions[:dates],
      historical_transactions[:amounts],
      historical_transactions[:balances]
    ).each { |row| puts row }
  end

  private

  def statement_rows(
    historical_transaction_dates,
    historical_transaction_amounts,
    historical_balances
  )
    rows = [STATEMENT_HEADERS]
    historical_transaction_dates.each_with_index do |date, index|
      rows.push(
        transaction(
          date,
          historical_transaction_amounts[index],
          historical_balances[index]
        )
      )
    end
    rows
  end

  def credit(amount)
    "#{string_with_two_decimals(amount)} " if amount.positive?
  end

  def debit(amount)
    credit(-amount) if amount.negative?
  end

  def balance(amount)
    string_with_two_decimals(amount)
  end

  def date_as_string(date)
    date.strftime(DATE_FORMAT)
  end

  def transaction(date, amount, total)
    "#{date_as_string(date)} ||" \
      " #{credit(amount)}||" \
      " #{debit(amount)}||" \
      " #{balance(total)}"
  end

  def string_with_two_decimals(number)
    format('%.2f', number)
  end
end
