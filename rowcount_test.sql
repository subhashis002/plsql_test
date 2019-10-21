create table rowcount_test as 
select * from all_users;

set serveroutput on
begin
	update rowcount_test
	set username = username;
	dbms_output.put_line('Rows affected: '||SQL%ROWCOUNT);
end;
/

drop table rowcount_test;
