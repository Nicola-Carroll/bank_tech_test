##Specification

###Requirements
- Interactions via IRB
- Deposits
- Withdrawals
- Print account statements (date, amount, balance), showing history of transactions
- Data kept in memory (not a DB)

###Acceptance criteria

**Given** a client makes a deposit of 1000 on 10-01-2023
**And** a deposit of 2000 on 13-01-2023
**And** a withdrawal of 500 on 14-01-2023
**When** she prints her bank statement
**Then** she would see

```
date || credit || debit || balance
14/01/2012 || || 500.00 || 2500.00
13/01/2012 || 2000.00 || || 3000.00
10/01/2012 || 1000.00 || || 1000.00
```

##Initial domain model

![image](https://user-images.githubusercontent.com/83607124/135060069-09e0b168-b1c0-42f5-b82e-fef3c7d52576.png)

