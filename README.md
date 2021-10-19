# Bank tech test

## Specification

This is a simple program which can be interacted with via a REPL, that replicates a bank account.

### Requirements
- Interactions via IRB
- Deposits
- Withdrawals
- Print account statements (date, amount, balance), showing history of transactions
- Data kept in memory (not a DB)

### Acceptance criteria

- **Given** a client makes a deposit of 1000 on 10-01-2023
- **And** a deposit of 2000 on 13-01-2023
- **And** a withdrawal of 500 on 14-01-2023
- **When** she prints her bank statement
- **Then** she would see

```
date || credit || debit || balance
14/01/2012 || || 500.00 || 2500.00
13/01/2012 || 2000.00 || || 3000.00
10/01/2012 || 1000.00 || || 1000.00
```

## Set up

### Technologies

- Ruby 3.0.2
- RSpec for testing
- Rubocop for formatting
- SimpleCov for test coverage
- Travis CI to run spec suite with each push

### Installation instructions

After cloning this repo, to install dependancies

```
cd bank_tech_test
bundle install
```

To run the full test suite

```
cd bank_tech_test
rspec
```

## Instructions for use

Clone this repo and initiate `irb`

```
git clone https://github.com/Nicola-Carroll/bank_tech_test.git
cd bank_tech_test
irb
```

Load the file `./lib/account`. The command `Account.new` has three optional arguments: `transaction_class:`, `transaction_log_class:`, and `statement_formatter_class:`. The defaults for these attributes are set as the corresponding classes defined within this directory.

```
3.0.2 :001 > require './lib/account'
 => true
3.0.2 :002 > account = Account.new
 =>
#<Account:0x00007f8c859f7270
 @statement_formatter=#<StatementFormatter:0x00007f8c859f6a50>,
 @transaction_log=#<TransactionLog:0x00007f8c859f71a8 @transaction_class=Transaction, @transactions=[]>> 
```

The account simulator can support depositing and withdrawing an amout of money represented by a Float, and printing a statement to `$stdout`.

```
3.0.2 :003 > account.deposit(100.0)
3.0.2 :004 > account.withdraw(50.0)
3.0.2 :005 > account.statement
date || credit || debit || balance
29/09/2021 || 100.00 || || 100.00
29/09/2021 || || 50.00 || 50.00
```


## Initial domain model

![image](https://user-images.githubusercontent.com/83607124/135060069-09e0b168-b1c0-42f5-b82e-fef3c7d52576.png)

## Final approach


| Class name  | Description | Knows about | Attributes | Methods
| ----------- | -----------------| ----------- | ---------- | ------- 
| `Account`  | The user interface of the account  | `StatementFormatter`, `Transaction`, `TransactionLog` | `statement_formatter`, `transaction_log` | `deposit`, `withdraw` - allows the user to deposit/withdraw money respectively, `statement` - prints the users latest statement
| `StatementFormatter`  | Formats a statement  | | | `statement` - formats a statement |
| `Transaction` | Stores data of a single transaction | | `date`, `amount` | |
| `TransactionLog` | Handles historical transactions | `Transaction` | `transaction_class`, `transactions` | `record_transaction` - initates a transaction and stores it, `historical_balances/transaction_dates/transaction_amounts` - returns an array of the respective historical data |

