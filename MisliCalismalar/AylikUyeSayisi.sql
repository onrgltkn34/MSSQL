select MONTH (CreateDate) Ay
	,YEAR (CreateDate) Yil
	,COUNT(*) UyeSayisi 
from Members (nolock) 
Group By MONTH (CreateDate)
	,YEAR (CreateDate)
order by YEAR (CreateDate)
  ,MONTH (CreateDate)
