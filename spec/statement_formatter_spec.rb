# frozen_string_literal: true

require 'statement_formatter'

describe StatementFormatter do
  let(:statement_formatter) { described_class.new }

  let(:spoof_date) { Time.new(2021, 01, 01) }
  let(:spoof_date_formatted) do
    Time.new(2021, 01, 01).strftime(StatementFormatter::DATE_FORMAT)
  end

  describe '#statement' do
    let(:blank_statement) { "#{StatementFormatter::STATEMENT_HEADERS}\n" }

    it 'renders a blank statement correctly' do
      expect {
        statement_formatter.statement(
          historical_transaction_dates: [],
          historical_transaction_amounts: [],
          historical_balances: []
        )
      }.to output(blank_statement).to_stdout
    end

    context 'there have been deposits' do
      let(:expected_output) do
        "date || credit || debit || balance\n" \
          "#{spoof_date_formatted} || 100.00 || || 100.00\n" \
          "#{spoof_date_formatted} || 100.00 || || 200.00\n" \
          "#{spoof_date_formatted} || 100.00 || || 300.00\n"
      end
      let(:expected_output_decimals) do
        "date || credit || debit || balance\n" \
          "#{spoof_date_formatted} || 100.12 || || 100.12\n" \
          "#{spoof_date_formatted} || 100.55 || || 200.67\n"
      end

      it 'renders deposits correctly' do
        expect {
          statement_formatter.statement(
            historical_transaction_dates: [spoof_date, spoof_date, spoof_date],
            historical_transaction_amounts: [100, 100, 100],
            historical_balances: [100, 200, 300]
          )
        }.to output(expected_output).to_stdout
      end

      it 'rounds decimals correctly' do
        expect {
          statement_formatter.statement(
            historical_transaction_dates: [spoof_date, spoof_date],
            historical_transaction_amounts: [100.1211, 100.547],
            historical_balances: [100.1211, 200.6681]
          )
        }.to output(expected_output_decimals).to_stdout
      end
    end

    context 'there have been withdrawls' do
      let(:expected_output) do
        "date || credit || debit || balance\n" \
          "#{spoof_date_formatted} || 150.00 || || 150.00\n" \
          "#{spoof_date_formatted} || || 400.10 || -250.10\n" \
          "#{spoof_date_formatted} || 55.65 || || -194.45\n"
      end

      it 'renders deposits and withdrawals correctly' do
        expect {
          statement_formatter.statement(
            historical_transaction_dates: [spoof_date, spoof_date, spoof_date],
            historical_transaction_amounts: [150, -400.1, 55.65],
            historical_balances: [150, -250.1, -194.45]
          )
        }.to output(expected_output).to_stdout
      end
    end
  end
end
