Declare @StartDate datetime, @EndDate datetime , @ProgramId int
Set @StartDate='06.29.2012'
Set @EndDate='06.29.2012'
Set @ProgramId=19

Select 	convert (date,LT.SoldDate) Tarih
		,M.tr_Value BiletTuru
		--,LT.TicketType
		,SUM(Case When LT.Status >= 2 then 1 else 0 end) SatilanBilet
		,Count(distinct LTM.MemberId) ToplamUyeSayisi
From LotteryTickets LT(nolock) 
Inner Join LotteryTicketMembers LTM (nolock) on LTM.IntegrationId=LT.IntegrationId
Inner Join SchemaEnumValues SEV(nolock) ON LT.TicketType = SEV.SchemaEnumValue And SEV.SchemaEnumId = 31
Inner Join Multilinguals M(nolock) ON SEV.SchemaEnumDesc = M.MultilingualId
Where convert (date,LT.SoldDate) >= @StartDate and convert (date,LT.SoldDate) <=@EndDate and LT.ProgramId=@ProgramId
Group By convert (date,LT.SoldDate),tr_Value, LT.TicketType
Order By convert (date,LT.SoldDate),LT.TicketType



-----Toplamda SatilanBilet Sayisi ve Uniuqe Üye Sayýsý
Select 	convert (date,LT.SoldDate) Tarih
		,SUM(Case When LT.Status >= 2 then 1 else 0 end) SatilanBilet
		,Count(distinct LTM.MemberId) ToplamUyeSayisi
From LotteryTickets LT(nolock) 
Inner Join LotteryTicketMembers LTM (nolock) on LTM.IntegrationId=LT.IntegrationId
Inner Join SchemaEnumValues SEV(nolock) ON LT.TicketType = SEV.SchemaEnumValue And SEV.SchemaEnumId = 31
Inner Join Multilinguals M(nolock) ON SEV.SchemaEnumDesc = M.MultilingualId
Where convert (date,LT.SoldDate) >= @StartDate and convert (date,LT.SoldDate) <=@EndDate and Lt.ProgramId=@ProgramId
Group By convert (date,LT.SoldDate)--,LT.TicketType
Order By convert (date,LT.SoldDate)




