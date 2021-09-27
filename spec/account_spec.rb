require 'account'

describe Account do
  let(:account) { described_class.new }
  let(:blank_statement) { 'date || credit || debit || balance' }
  let(:today) { Time.new.strftime('%d/%m/%Y') }

  describe '#statement' do
    it 'returns a blank statement initially' do
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
        account.deposit(100)
        expect(account.statement).to eq expect_100
      end

      it 'can calculate an account balance from multiple deposits of 100' do
        3.times { account.deposit(100) }
        expect(account.statement).to eq expect_300
      end

      it 'can handle varying deposit amounts' do
        account.deposit(150)
        account.deposit(405)
        account.deposit(240)
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
        account.withdraw(100)
        expect(account.statement).to eq expect_negative_100
      end

      it 'can calculate an account balance from multiple withdrawals of 100' do
        3.times { account.withdraw(100) }
        expect(account.statement).to eq expect_negative_300
      end

      it 'can combine deposits and withdrawals' do
        account.deposit(150)
        account.withdraw(40)
        account.deposit(65)
        expect(account.statement).to eq expect_175
      end
    end
  end
end
