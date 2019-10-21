drop table cached_lookup_tab;

create table cached_lookup_tab(
	id	number(10)	not null,
	description	varchar2(50)	not null
);

alter table cached_lookup_tab add (
	constraint cached_lookup_tab_pk primary key(id)
);

declare
	type t_tab is table of NUMBER;	
	l_tab	t_tab := t_tab();
begin
	for i in 1 .. 1000 LOOP
		l_tab.extend;
		l_tab(l_tab.last) := i;
	end loop;
	
	forall i in l_tab.first .. l_tab.last
		insert into cached_lookup_tab(id, description)
		values(l_tab(i), 'Description for '|| to_char(l_tab(i)));
	
	commit;
end;
/

EXEC DBMS_STATS.GATHER_TABLE_STATS(USER,'cached_lookup_tab', cascade => TRUE);
