require 'account'
require 'transaction_log'

describe Account do
  let(:transaction_log) { double :transaction_log }
  let(:transaction_log_class) do
    double :transaction_log_class, new: transaction_log
  end
  let(:account) do
    described_class.new(transaction_log_class: transaction_log_class)
  end

  let(:blank_statement) { 'date || credit || debit || balance' }
  let(:today) { Time.new.strftime('%d/%m/%Y') }

  describe '#deposit' do
    it 'records a deposit in the transaction log' do
      expect(transaction_log).to receive(:record_deposit).with(100)
      account.deposit(100)
    end
  end

  describe '#withdraw' do
    it 'records a withdrawal in the transaction log' do
      expect(transaction_log).to receive(:record_withdrawal).with(100)
      account.withdraw(100)
    end
  end

  describe '#statement' do
    it 'returns a blank statement initially' do
      allow(transaction_log).to receive(:transactions).and_return([])
      expect(account.statement).to eq blank_statement
    end

    context 'account owner has topped' do
      let(:expect_100) do
        [
          'date || credit || debit || balance',
          "#{today} || 100 || || 100"
        ].join("\n")
      end
      let(:expect_300) do
        [
          'date || credit || debit || balance',
          "#{today} || 100 || || 100",
          "#{today} || 100 || || 200",
          "#{today} || 100 || || 300"
        ].join("\n")
      end
      let(:expect_795) do
        [
          'date || credit || debit || balance',
          "#{today} || 150 || || 150",
          "#{today} || 405 || || 555",
          "#{today} || 240 || || 795"
        ].join("\n")
      end

      it 'can print a statement for one deposit' do
        allow(transaction_log).to receive(:transactions).and_return(
          [[today, 100]]
        )
        allow(transaction_log).to receive(:total_following_transaction)
          .and_return(100)
        expect(account.statement).to eq expect_100
      end

      it 'can calculate account balance from multiple deposits of 100' do
        allow(transaction_log).to receive(:transactions).and_return(
          [[today, 100], [today, 100], [today, 100]]
        )
        allow(transaction_log).to receive(:total_following_transaction)
          .and_return(100, 200, 300)
        expect(account.statement).to eq expect_300
      end

      it 'can handle varying deposit amounts' do
        allow(transaction_log).to receive(:transactions).and_return(
          [[today, 150], [today, 405], [today, 240]]
        )
        allow(transaction_log).to receive(:total_following_transaction)
          .and_return(150, 555, 795)
        expect(account.statement).to eq expect_795
      end
    end

    context 'account owner makes a withdrawal' do
      let(:expect_negative_100) do
        [
          'date || credit || debit || balance',
          "#{today} || || 100 || -100"
        ].join("\n")
      end
      let(:expect_negative_300) do
        [
          'date || credit || debit || balance',
          "#{today} || || 100 || -100",
          "#{today} || || 100 || -200",
          "#{today} || || 100 || -300"
        ].join("\n")
      end

      let(:expect_175) do
        [
          'date || credit || debit || balance',
          "#{today} || 150 || || 150",
          "#{today} || || 40 || 110",
          "#{today} || 65 || || 175"
        ].join("\n")
      end

      it 'can print a statement for one withdrawal' do
        allow(transaction_log).to receive(:transactions).and_return(
          [[today, -100]]
        )
        allow(transaction_log).to receive(:total_following_transaction)
          .and_return(-100)
        expect(account.statement).to eq expect_negative_100
      end

      it 'can calculate an account balance from multiple withdrawals of 100' do
        allow(transaction_log).to receive(:transactions).and_return(
          [[today, -100], [today, -100], [today, -100]]
        )
        allow(transaction_log).to receive(:total_following_transaction)
          .and_return(-100, -200, -300)
        expect(account.statement).to eq expect_negative_300
      end

      it 'can combine deposits and withdrawals' do
        allow(transaction_log).to receive(:transactions).and_return(
          [[today, 150], [today, -40], [today, 65]]
        )
        allow(transaction_log).to receive(:total_following_transaction)
          .and_return(150, 110, 175)
        expect(account.statement).to eq expect_175
      end
    end
  end
end
