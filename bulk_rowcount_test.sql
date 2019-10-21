create table bulk_rowcount_test as 
select * from all_users;

set serveroutput on
declare
	type t_array_tab is table of varchar2(30);
	l_array t_array_tab := t_array_tab('SCOTT','SYS','SYSTEM','DBSNMP','BANANA');
begin
	forall i in l_array.first .. l_array.last
		delete from bulk_rowcount_test
		where username = l_array(i);

	for i in l_array.first .. l_array.last LOOP
		DBMS_OUTPUT.put_line('Element: '||RPAD(l_array(i),15,' ') || ' Rows affected: '|| SQL%BULK_ROWCOUNT(i));
	end LOOP;
end;
/

drop table bulk_rowcount_test;
