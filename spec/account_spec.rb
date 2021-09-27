require 'account'

describe Account do
  let(:account) { described_class.new }
  let(:blank_statement) { 'date || credit || debit || balance' }
  let(:today) { Time.new.strftime('%d/%m/%Y') }

  describe '#statement' do
    it 'returns a blank statement initially' do
      expect(account.statement).to eq blank_statement
    end

    context 'account owner has topped up' do
      let(:expected_100) do
        [
          'date || credit || debit || balance',
          "#{today} || 100 || || 100"
        ].join("\n")
      end
      let(:expected_300) do
        [
          'date || credit || debit || balance',
          "#{today} || 100 || || 100",
          "#{today} || 100 || || 200",
          "#{today} || 100 || || 300"
        ].join("\n")
      end

      it 'can print a statement for transaction' do
        account.deposit
        expect(account.statement).to eq expected_100
      end

      it 'can calculate an account balance from multiple deposits' do
        3.times { account.deposit }
        expect(account.statement).to eq expected_300
      end
    end
  end
end
