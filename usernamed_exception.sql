set serveroutput on
DECLARE
    myex EXCEPTION;
    PRAGMA EXCEPTION_INIT(myex,-20015); 
    n NUMBER := 10;
BEGIN
    FOR i IN 1..n LOOP
        dbms_output.put_line(i);
        IF i=n THEN
            RAISE myex;
        END IF;
    END LOOP;
EXCEPTION
    WHEN myex THEN
        dbms_output.put_line('loop finish');
END;
/
