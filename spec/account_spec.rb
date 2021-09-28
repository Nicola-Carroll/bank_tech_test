# frozen_string_literal: true

require 'account'

describe Account do
  let(:transaction_log) { double :transaction_log }
  let(:transaction_log_class) do
    double :transaction_log_class, new: transaction_log
  end
  let(:transaction_class) { double :transaction_class }
  let(:account) do
    described_class.new(
      transaction_log_class: transaction_log_class,
      transaction_class: transaction_class
    )
  end

  let(:blank_statement) { Account::STATEMENT_HEADERS }
  let(:today) { Time.new.strftime('%d/%m/%Y') }

  describe '#deposit' do
    it 'does not accept strings' do
      expect do
        account.deposit('100')
      end.to raise_error 'Invalid input, please enter a float'
    end

    it 'only accepts floats' do
      expect do
        account.deposit(100)
      end.to raise_error 'Invalid input, please enter a float'
    end

    it 'records a deposit in the transaction log' do
      expect(transaction_log).to receive(:record_transaction).with(100.0)
      account.deposit(100.0)
    end
  end

  describe '#withdraw' do
    it 'does not accept strings' do
      expect do
        account.withdraw('100')
      end.to raise_error 'Invalid input, please enter a float'
    end

    it 'only accepts floats' do
      expect do
        account.withdraw(100)
      end.to raise_error 'Invalid input, please enter a float'
    end

    it 'records a withdrawal in the transaction log' do
      expect(transaction_log).to receive(:record_transaction).with(-100.0)
      account.withdraw(100.0)
    end
  end

  describe '#statement' do
    it 'returns a blank statement initially' do
      allow(transaction_log).to receive(:transactions).and_return([])
      expect(account.statement).to eq blank_statement
    end

    context 'account owner has topped' do
      let(:transaction100) { double :transaction, date: today, amount: 100 }

      let(:expect100) do
        [Account::STATEMENT_HEADERS, "#{today} || 100.00 || || 100.00"].join(
          "\n"
        )
      end
      let(:expect300) do
        [
          Account::STATEMENT_HEADERS,
          "#{today} || 100.00 || || 100.00",
          "#{today} || 100.00 || || 200.00",
          "#{today} || 100.00 || || 300.00"
        ].join("\n")
      end
      let(:expect795) do
        [
          Account::STATEMENT_HEADERS,
          "#{today} || 150.00 || || 150.00",
          "#{today} || 405.00 || || 555.00",
          "#{today} || 240.00 || || 795.00"
        ].join("\n")
      end

      it 'can print a statement for one deposit' do
        allow(transaction_log).to receive(:transactions).and_return(
          [transaction100]
        )
        allow(transaction_log).to receive(:total_following_transaction)
          .and_return(100.0)
        expect(account.statement).to eq expect100
      end

      it 'can calculate account balance from multiple deposits of 100' do
        allow(transaction_log).to receive(:transactions).and_return(
          [transaction100, transaction100, transaction100]
        )
        allow(transaction_log).to receive(:total_following_transaction)
          .and_return(100.0, 200.0, 300.0)
        expect(account.statement).to eq expect300
      end

      context 'the top up amount is varied' do
        let(:transaction150) { double :transaction, date: today, amount: 150 }
        let(:transaction405) { double :transaction, date: today, amount: 405 }
        let(:transaction240) { double :transaction, date: today, amount: 240 }

        it 'can handle varying deposit amounts' do
          allow(transaction_log).to receive(:transactions).and_return(
            [transaction150, transaction405, transaction240]
          )
          allow(transaction_log).to receive(:total_following_transaction)
            .and_return(150.0, 555.0, 795.0)
          expect(account.statement).to eq expect795
        end
      end
    end

    context 'account owner makes a withdrawal' do
      let(:transaction_negative100) do
        double :transaction, date: today, amount: -100
      end

      let(:expect_negative100) do
        [Account::STATEMENT_HEADERS, "#{today} || || 100.00 || -100.00"].join(
          "\n"
        )
      end
      let(:expect_negative300) do
        [
          Account::STATEMENT_HEADERS,
          "#{today} || || 100.00 || -100.00",
          "#{today} || || 100.00 || -200.00",
          "#{today} || || 100.00 || -300.00"
        ].join("\n")
      end

      let(:expect175) do
        [
          Account::STATEMENT_HEADERS,
          "#{today} || 150.00 || || 150.00",
          "#{today} || || 40.00 || 110.00",
          "#{today} || 65.00 || || 175.00"
        ].join("\n")
      end

      it 'can print a statement for one withdrawal' do
        allow(transaction_log).to receive(:transactions).and_return(
          [transaction_negative100]
        )
        allow(transaction_log).to receive(:total_following_transaction)
          .and_return(-100.0)
        expect(account.statement).to eq expect_negative100
      end

      it 'can calculate an account balance from multiple withdrawals of 100' do
        allow(transaction_log).to receive(:transactions).and_return(
          [
            transaction_negative100,
            transaction_negative100,
            transaction_negative100
          ]
        )
        allow(transaction_log).to receive(:total_following_transaction)
          .and_return(-100, -200, -300)
        expect(account.statement).to eq expect_negative300
      end

      context 'the top-up/withdrawal amount varies' do
        let(:transaction150) { double :transaction, date: today, amount: 150 }
        let(:transaction_negative40) do
          double :transaction, date: today, amount: -40
        end
        let(:transaction65) { double :transaction, date: today, amount: 65 }

        it 'can combine deposits and withdrawals' do
          allow(transaction_log).to receive(:transactions).and_return(
            [transaction150, transaction_negative40, transaction65]
          )
          allow(transaction_log).to receive(:total_following_transaction)
            .and_return(150.0, 110.0, 175.0)
          expect(account.statement).to eq expect175
        end
      end
    end
  end
end
