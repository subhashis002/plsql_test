set verify off
set serveroutput on

declare 
	l_seed BINARY_INTEGER;
	l_start NUMBER;
	l_loops	NUMBER := 1000000;
	l_id	cached_lookup_tab.id%TYPE;
	l_row	cached_lookup_tab%ROWTYPE;
begin

	--Seed the random number generator.
	l_seed := TO_NUMBER(TO_CHAR(SYSDATE,'YYYYDDMMSS'));
	DBMS_RANDOM.initialize(val => l_seed);
	
	-- Time the cached lookup.
	l_start := DBMS_UTILITY.get_time;
	
	FOR i IN 1 .. l_loops LOOP
		l_id := TRUNC(DBMS_RANDOM.value(low=>1, high => 1000));
		cached_lookup_api.get_cached_info(p_id => l_id, p_info => l_row);
	END LOOP;
	
	DBMS_OUTPUT.put_line('Cached Lookup ('||l_loops||' rows): '||
							(DBMS_UTILITY.get_time - l_start));
	
	-- Time the db lookup
	l_start := DBMS_UTILITY.get_time;
	
	FOR i in 1 .. l_loops LOOP
		l_id := TRUNC(DBMS_RANDOM.VALUE(low=>1, high=> 1000));
		cached_lookup_api.get_db_info(p_id=>l_id,
										p_info=> l_row);
	END LOOP;
	
	DBMS_OUTPUT.put_line('DB Lookup ('|| l_loops ||' rows) :'||
								(DBMS_UTILITY.get_time - l_start));
	DBMS_RANDOM.terminate;
END;
/
	