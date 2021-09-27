require 'account'

describe Account do
  let(:account) { described_class.new }
  let(:blank_statement) { 'date || credit || debit || balance' }

  describe '#print_statement' do
    it 'prints a blank statement initially' do
      expect { account.print_statement }.to output(/#{blank_statement}$/)
        .to_stdout
    end
  end
end
