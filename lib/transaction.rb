# frozen_string_literal: true

# an instance just stores the data of an individual transaction
class Transaction
  attr_reader :date, :amount

  def initialize(date:, amount:)
    @date = date
    @amount = amount
  end
end
