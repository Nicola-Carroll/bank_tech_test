require 'account'

describe Account do
  let(:account) { described_class.new }
  let(:blank_statement) { 'date || credit || debit || balance' }
  let(:today) { Time.new.strftime('%d/%m/%Y') }

  describe '#statement' do
    it 'returns a blank statement initially' do
      expect(account.statement).to eq blank_statement
    end

    describe '#deposit' do
      let(:expected) do
        [
          'date || credit || debit || balance',
          "#{today} || 100 || || 100"
        ].join("\n")
      end

      it 'can print one transaction' do
        account.deposit
        expect(account.statement).to eq expected
      end
    end
  end
end
