set serveroutput on
declare
	type t_forall_test_tab is table of forall_test%ROWTYPE;
	type t_idx_tab is table of BINARY_INTEGER;
	
	l_tab t_forall_test_tab := t_forall_test_tab();
	l_idx_tab	t_idx_tab	:=t_idx_tab();
begin
	FOR i IN 1 .. 1000 LOOP
		l_tab.extend;
		l_tab(l_tab.last).id		:=i;
		l_tab(l_tab.last).code		:=to_char(i);
		l_tab(l_tab.last).description := 'Description: '||to_char(i);
		if mod(i,100) = 0 then
			l_idx_tab.extend;
			l_idx_tab(l_idx_tab.last) := i;
		end if;
	end LOOP;
	
	execute immediate 'TRUNCATE TABLE forall_test';
	
	forall i in values of l_idx_tab
		insert into forall_test values l_tab(i);
	commit;
end;
/
