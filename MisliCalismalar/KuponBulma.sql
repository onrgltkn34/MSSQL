Declare @IntegrationId varchar(50),
@MemberId int , @KuponAdet int


set @IntegrationId='063753421300054282240084940216'
set @MemberId=32679757
set @KuponAdet=200


select  convert(date,ECM.CreateDate) Kupontarihi,
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
from EventCouponMasters ECM (NOLOCK)
inner join EventCouponDetails ECD (NOLOCK) on ECD.CouponId=ECM.CouponId
inner join EventBets EB (NOLOCK) on EB.BetId=ECD.BetId
inner join Multilinguals MU(nolock) on EB.BetName = MU.MultilingualId
inner join EventBetTypes EBT (NOLOCK) on EB.BetTypeId=EBT.BetTypeId
inner join Multilinguals MEBT(nolock) on EBT.BetTypeName = MEBT.MultilingualId
inner join EventGameTypes EGT (NOLOCK) on EGT.GameTypeId=ECD.GameTypeId
inner join Multilinguals MEGT (NOLOCK) on MEGT.MultilingualId=EGT.GameTypeName
inner join EventChoices EC (NOLOCK) on EC.ChoiceId=ECD.ChoiceId
left outer join Multilinguals MEC (NOLOCK) on MEC.MultilingualId=EC.ChoiceName
left outer join EventChoices EC1 (NOLOCK) on EC1.ChoiceId=ECD.ChoiceId2
left outer join EventResults ER (NOLOCK) on ECD.BetId=ER.BetId
inner join Members M (NOLOCK) on M.MemberId=ECM.MemberId
where ECM.IntegrationId=@IntegrationId
and (@MemberId is null or M.MemberId=@MemberId)