# frozen_string_literal: true

require './lib/account'
require './lib/transaction'
require './lib/transaction_log'
require './lib/statement_formatter'

ACCOUNT =
  Account.new(
    transaction_class: Transaction,
    transaction_log_class: TransactionLog,
    statement_formatter_class: StatementFormatter
  )
