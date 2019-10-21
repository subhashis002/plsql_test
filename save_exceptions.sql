set serveroutput on
declare 
	type t_tab is table of exception_test%ROWTYPE;
	
	l_tab		t_tab := t_tab();
	l_error_count	NUMBER;
	
	ex_dml_errors	EXCEPTION;
	PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
begin	
	FOR i in 1 .. 100 LOOP
		l_tab.extend;
		l_tab(l_tab.last).id := i;
	END LOOP;
	
	l_tab(50).id := NULL;
	l_tab(51).id := NULL;
	
	EXECUTE IMMEDIATE 'TRUNCATE TABLE exception_test';
	
	BEGIN
		FORALL i in l_tab.first .. l_tab.last save exceptions
			insert into exception_test
			values l_tab(i);
	EXCEPTION
		WHEN ex_dml_errors THEN
			l_error_count := SQL%BULK_EXCEPTIONS.count;
			dbms_output.put_line('Number of failure: '|| l_error_count);
			
			for i IN 1 .. l_error_count LOOP
				dbms_output.put_line('Error: '||i||' Array Index '||SQL%BULK_EXCEPTIONS(i).error_index || ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
			end LOOP;
	END;
end;
/

set echo on
select count(*) from exception_test;
set echo off
