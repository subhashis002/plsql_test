create or replace package cached_lookup_api as 
	procedure populate_tab;
	procedure get_cached_info (p_id IN cached_lookup_tab.id%TYPE,
								p_info OUT cached_lookup_tab%ROWTYPE
								);
	procedure get_db_info(p_id IN cached_lookup_tab.id%TYPE,
								p_info OUT cached_lookup_tab%ROWTYPE
								);
end cached_lookup_api;
/
show errors

create or replace package body cached_lookup_api as 

type t_tab is table of cached_lookup_tab%ROWTYPE INDEX by binary_integer;
g_tab t_tab;

procedure populate_tab as 
begin
	for i in (select * from cached_lookup_tab)
	LOOP
		g_tab(i.id) := i;
	end LOOP;
end populate_tab;

procedure get_cached_info(p_id in cached_lookup_tab.id%TYPE,
							p_info out cached_lookup_tab%ROWTYPE) AS
begin
	p_info := g_tab(p_id);
end get_cached_info;

procedure get_db_info(p_id in cached_lookup_tab.id%TYPE,
						p_info out cached_lookup_tab%ROWTYPE) AS
begin
	select * into p_info
	from cached_lookup_tab
	where id = p_id;
end get_db_info;

begin
	populate_tab;
end cached_lookup_api;
/
show errors