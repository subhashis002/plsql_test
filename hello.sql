set serveroutput on
declare
	text varchar2(24);
BEGIN
	text:= 'Hellow world';
	dbms_output.put_line(text);
END;
/
