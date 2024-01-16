select IP, COUNT(Ip) Connection
from Sessions (nolock)
where convert(date,LoginTime) =CONVERT(date,getdate())
group by IP
having COUNT(Ip)>999
order by COUNT(Ip)  desc