declare
	@StartDate datetime,
	@EndDate datetime,
	@AccontId int 

set @StartDate='02.01.2013'
set @EndDate ='03.01.2013'
set @AccontId=354870

Select 
		count(*) transactionCount,
		isnull(Sum(AT.Debit-AT.Credit),0) Money,
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
		AT.ChannelCode,
		BAC.ChannelName,
		BA.BankAccountType
		into #tmp_kontrol
From 
		AccountTransactions (Nolock) AT
		Inner Join Accounts(Nolock) A on A.AccountId=AT.AccountId
		Inner Join BankAccounts(Nolock) BA On BA.AccountId=A.AccountId
		Inner Join Banks(Nolock) B On B.BankId=BA.BankId
		Inner Join BankBranchs(Nolock) BB On BB.BankBranchId=BA.BankBranchId
		Left Join BankAccountChannels BAC(nolock) ON BAC.AccountId = BA.AccountId And BAC.ChannelId = AT.ChannelCode Where 
		AT.TransactionType=7
		And BA.BankAccountType IN (1,0)
		And Date>= @StartDate 
		And Date< @EndDate
Group by AT.AccountId,BB.BranchName,
		B.BankName,
		A.AccountCode,
		AT.ChannelCode,
		BA.BankAccountType,
		BAC.ChannelName


select * 
from #tmp_kontrol (nolock) 
where AccountId=@AccontId and ChannelCode in (4)

drop table #tmp_kontrol