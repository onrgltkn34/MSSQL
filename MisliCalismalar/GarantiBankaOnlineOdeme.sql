Select *
,(select MemberId from MemberAccounts ma(nolock) where ma.AccountId=BankAutomaticPaybackLogs.MemberAccountId ) 
from BankAutomaticPaybackLogs(nolock) 
Where MemberAccountId IN(Select AccountId From MemberAccounts(nolock) Where MemberId ='32797040')
And MethodName = 'GetOnlineTrfToGaranti' 

