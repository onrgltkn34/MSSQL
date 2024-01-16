select ltm.MemberId UyeNumarasý
		,lt.IntegrationId BiletNumarasi
		,case
			when lt.TicketType=0 then 'Çeyrek'
			when lt.TicketType=1 then 'Yarým'
			when lt.TicketType=2 then 'Tam'
		 End BiletTuru
		,lt.Prize KazanilanTutar
from LotteryTickets lt(nolock)
left join LotteryTicketMembers ltm(nolock) on ltm.IntegrationId=lt.IntegrationId
where  lt.Prize>0 and lt.ProgramId=2