Use lib03_test_veribase_com

Declare @patiendid int =11111
		,@unit int = 257

delete from project where id= @patiendid and company= @unit
delete from patient05 where project =@patiendid and unit =@unit
delete from patient01 where id in (select patient from patient05 where project =@patiendid and unit =@unit) 
delete from patient07 where patientid in (select patient from patient05 where project =@patiendid and unit =@unit) 