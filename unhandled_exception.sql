set serveroutput on
declare 
	type t_tab is table of exception_test.id%TYPE;
	
	l_tab t_tab	:= t_tab();
begin
	for i in 1 .. 100 LOOP
		l_tab.extend;
		l_tab(l_tab.last) := i;
	end LOOP;
	
	l_tab(50) := NULL;
	
	EXECUTE IMMEDIATE 'TRUNCATE TABLE exception_test';
	
	forall i in l_tab.first .. l_tab.last 
		insert into exception_test
		values(l_tab(i));
end;
/

set echo on
select count(*) from exception_test;
set echo off
	