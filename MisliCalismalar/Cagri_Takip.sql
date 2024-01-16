select * from HelpDeskCalls hdc(nolock) 
Inner Join HelpDeskCallLogs hdcl (nolock) on hdcl.CallId = hdc.CallId
where hdc.MemberId='32568221'

