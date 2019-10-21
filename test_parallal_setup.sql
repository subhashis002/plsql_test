CREATE table parallel_test(
id	NUMBER(10),
description VARCHAR2(50)
);

TRUNCATE TABLE parallel_test;

BEGIN
	FOR i IN 1 .. 100000 LOOP
		insert into parallel_test values(i,'Description of ' ||i);
	END LOOP;
	COMMIT;
END;
/

CREATE OR REPLACE PACKAGE parallel_pft_api AS 

	TYPE t_parallal_test_row is RECORD (
		id	NUMBER(10),
		description	VARCHAR2(50),
		sid		NUMBER
		);
		
	TYPE t_parallal_test_tab IS TABLE OF t_parallal_test_row;
	
	TYPE t_parallal_test_ref_cursor IS REF CURSOR RETURN parallel_test%ROWTYPE;
	
	FUNCTION test_ptf(p_cursor IN t_parallal_test_ref_cursor)
		RETURN t_parallal_test_tab PIPELINED
		PARALLEL_ENABLE(PARTITION p_cursor BY HASH(id));
END parallel_pft_api;
/
SHOW ERRORS

CREATE OR REPLACE PACKAGE BODY parallel_pft_api AS

	FUNCTION test_ptf(p_cursor IN t_parallal_test_ref_cursor)
	RETURN t_parallal_test_tab PIPELINED
	PARALLEL_ENABLE(PARTITION p_cursor BY HASH(id))
	IS
		l_row t_parallal_test_row;
	BEGIN
		LOOP
			FETCH p_cursor
			INTO l_row.id,
					l_row.description;
			EXIT WHEN p_cursor%NOTFOUND;
			
			SELECT sid
			INTO l_row.sid
			FROM v$mystat
			WHERE rownum = 1;
			
			PIPE ROW (l_row);
		END LOOP;
		RETURN;	
	END test_ptf;
END parallel_pft_api;
/
SHOW ERRORS
