select * 
from InteltekTransactions  (nolock)
where MemberId= 32660065 
	and convert(date,StartDate)='05.05.2013' 
	and ErrorCode not in ('')
order by StartDate desc