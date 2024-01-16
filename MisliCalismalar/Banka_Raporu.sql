declare
	@StartDate datetime,
	@EndDate datetime 

set @StartDate='01.01.2012'
set @EndDate ='01.01.2013'

BEGIN
	SET NOCOUNT ON;
	Select 
			count(*) transactionCount,
			isnull(Sum(AT.Debit),0) sumDebit,
			Max(date) maxDate,
			AT.AccountId,
			BB.BranchName,
			(case AT.AccountId 
				when 283811 then 
					B.BankName + ' (Mobile Ödeme)'
				else
					B.BankName 
				end ) BankName,
			A.AccountCode,
			BA.BankAccountType
	From 
			AccountTransactions (Nolock) AT,
			Accounts(Nolock) A,
			BankAccounts(Nolock) BA ,
			Banks(Nolock) B,
			BankBranchs(Nolock) BB
	Where 
			AT.TransactionType=7
			And A.AccountId=AT.AccountId
			And BA.AccountId=A.AccountId
			And B.BankId=BA.BankId
			And BB.BankBranchId=BA.BankBranchId
			And BA.BankAccountType IN (1,0)
			And Date>= @StartDate 
			And Date<= @EndDate
	Group by AT.AccountId,BB.BranchName,
			B.BankName,
			A.AccountCode,
			BA.BankAccountType
	SET NOCOUNT OFF;
END



