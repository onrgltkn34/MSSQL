Declare @Count int,@Sayi int=0
	,@IntegrationId varchar(50),
	@MemberId int , @KuponAdet int
 
set @Count= (select count(*) from Kamer)
 
 
Create table #tmp_kontrol
(
	KuponNumarasi int
	,Kupontarihi date
	,Betname nvarchar(max)
	,GtValue nvarchar(max)
	,EcValue nvarchar(max)
	,Sonuc nvarchar(max)
	,SistemliKombine nvarchar(max)
	,Tutar money
	,MaxKazanc money
	,KuponAdet int
	,ToplamOynanilanTutar money
	,ToplamGerçeklesenToplamTutar money
	,KuponDurumu nvarchar(max)
) 
 
 
while @Sayi<@Count
Begin
	
	
	set @IntegrationId=(select KuponNumarasi from Kamer where sayi=@Sayi+1)
	set @MemberId=32679757
	set @KuponAdet=(select Kupon_Adeti from Kamer where sayi=@Sayi+1)
	
	
	insert into #tmp_kontrol
	select  @Sayi KuponNumarasi,convert(date,ECM.CreateDate) Kupontarihi,
		case when StandartFlag=1 then 
			case when HandicapF1 IS not null  then '(B) ' + '('+Replace(convert(nvarchar(10),HandicapF1),'0','') + 'h) ' + MU.tr_Value  
				 when HandicapF2 IS not null then '(B) ' + MU.tr_Value + ' (' + Replace(convert(nvarchar(10),HandicapF2),'0','')+'h)' 
			      when HandicapFH1 IS not null  then '(B) ' + '('+Replace(convert(nvarchar(10),HandicapFH1),'0','') + 'h) ' + MU.tr_Value
			      when HandicapFH2 IS not null then '(B) ' + MU.tr_Value + ' (' + Replace(convert(nvarchar(10),HandicapFH2),'0','')+'h)'
				  Else '(B) ' + MU.tr_Value 
			 End
			 when StandartFlag=0 then 
			  case when HandicapF1 IS not null  then   '('+ Replace(convert(nvarchar(10),HandicapF1),'0','') + 'h) ' + MU.tr_Value  
				 when HandicapF2 IS not null then  MU.tr_Value + ' (' + Replace(convert(nvarchar(10),HandicapF2),'0','')+'h)' 
			      when HandicapFH1 IS not null  then '('+Replace(convert(nvarchar(10),HandicapFH1),'0','') + 'h) ' + MU.tr_Value
			      when HandicapFH2 IS not null then  MU.tr_Value + ' (' + Replace(convert(nvarchar(10),HandicapFH2),'0','')+'h)'
				  Else  MU.tr_Value 
			 End
			 end BetName 
		,MEGT.tr_Value GTValue
		,case when MEC.tr_Value is null then ECD.ChoiceName else MEC.tr_Value end ECValue
		,Isnull(case when ECD.Status=1 then 'Kazandý (' +convert(nvarchar(10),ER.HomeFirst)+':'+convert(nvarchar(10),ER.AwayFirst)+' '+convert(nvarchar(10),ER.HomeFinal)+':'+convert(nvarchar(10),ER.AwayFinal)+')'
			when ECD.Status=2 then 'Kaybetti (' +convert(nvarchar(10),ER.HomeFirst)+':'+convert(nvarchar(10),ER.AwayFirst)+' '+convert(nvarchar(10),ER.HomeFinal)+':'+convert(nvarchar(10),ER.AwayFinal)+')'
			when ECD.Status=0 then 'Bekliyor'
		End
			,case when ECM.Status=1 then 'Kazandý'
			when ECM.Status=2 then 'Kaybetti'
			when ECM.Status=0 then 'Bekliyor'
			End ) Sonuc
		,Case when ECM.CouponType=2 then 'Sistemli'
		   Else 'Kombine'
		   End SistemliKombine
		,ECM.Price Tutar
		,ECM.MaxPrize MaxKazanc
		,@KuponAdet KuponAdet
		,Ecm.Price*@KuponAdet ToplamOynanilanTutar
		,case when ECM.Status=1 then (ECM.Prize * @KuponAdet )   
			  else Isnull(ECM.Prize,0)
			  End ToplamGerçeklesenToplamTutar
	    ,case when ECM.Status=1 then 'Kazandý'
			when ECM.Status=2 then 'Kaybetti'
			when ECM.Status=0 then 'Bekliyor'
			End KuponDurumu
from [10.0.1.109].[ATGBet].[dbo].[EventCouponMasters] ECM (NOLOCK)
inner join [10.0.1.109].[ATGBet].[dbo].[EventCouponDetails] ECD (NOLOCK) on ECD.CouponId=ECM.CouponId
inner join [10.0.1.109].[ATGBet].[dbo].[EventBets] EB (NOLOCK) on EB.BetId=ECD.BetId
inner join [10.0.1.109].[ATGBet].[dbo].[Multilinguals] MU(nolock) on EB.BetName = MU.MultilingualId
inner join [10.0.1.109].[ATGBet].[dbo].[EventBetTypes] EBT (NOLOCK) on EB.BetTypeId=EBT.BetTypeId
inner join [10.0.1.109].[ATGBet].[dbo].[Multilinguals] MEBT(nolock) on EBT.BetTypeName = MEBT.MultilingualId
inner join [10.0.1.109].[ATGBet].[dbo].[EventGameTypes] EGT (NOLOCK) on EGT.GameTypeId=ECD.GameTypeId
inner join [10.0.1.109].[ATGBet].[dbo].[Multilinguals] MEGT (NOLOCK) on MEGT.MultilingualId=EGT.GameTypeName
inner join [10.0.1.109].[ATGBet].[dbo].[EventChoices] EC (NOLOCK) on EC.ChoiceId=ECD.ChoiceId
left outer join [10.0.1.109].[ATGBet].[dbo].[Multilinguals] MEC (NOLOCK) on MEC.MultilingualId=EC.ChoiceName
left outer join [10.0.1.109].[ATGBet].[dbo].[EventChoices] EC1 (NOLOCK) on EC1.ChoiceId=ECD.ChoiceId2
left outer join [10.0.1.109].[ATGBet].[dbo].[EventResults] ER (NOLOCK) on ECD.BetId=ER.BetId
inner join [10.0.1.109].[ATGBet].[dbo].[Members] M (NOLOCK) on M.MemberId=ECM.MemberId
where ECM.IntegrationId=@IntegrationId
and (@MemberId is null or M.MemberId=@MemberId)
	
	
	
	
	set @Sayi=@Sayi+1
End
 
 
 
 
select * from #tmp_kontrol


drop table #tmp_kontrol