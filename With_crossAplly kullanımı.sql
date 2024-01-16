set nocount on;

declare @x int = 1000000
		,@sonuc datetime = getdate()

;WITH a1 AS (
     SELECT 1 as nu
	 union all 
	 select 1 as nu
	 	 union all 
	 select 1 as nu
	 	 union all 
	 select 1 as nu
	 	 union all 
	 select 1 as nu
	 --	 union all 
	 --select 1 as nu
     )
   
, a2 AS (
          SELECT 1 as nu
	 union all 
	 select 1 as nu
	 	 union all 
	 select 1 as nu
	 	 union all 
	 select 1 as nu
	 	 	 union all 
	 select 1 as nu


     )
, a3 AS (
     select a1.nu from a1
		cross apply (select * from a2 where a2.nu=a1.nu) a
     )
, a4 AS (
     select a2.nu from a2
		cross apply (select * from a3 where a3.nu=a2.nu) a
     )
, a5 AS (
     select a3.nu from a3
		cross apply (select * from a4 where a4.nu=a3.nu) a
     )
, a6 AS (
     select a4.nu from a4
		cross apply (select * from a5 where a5.nu=a4.nu) a
     )


select top (@x) a1.nu , ROW_NUMBER () over(order by a1.nu desc) 
from a1
cross apply (select * from a6 where a6.nu=a1.nu) a


select (GETDATE() - @sonuc)



