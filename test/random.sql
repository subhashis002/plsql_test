SET SERVEROUTPUT ON
BEGIN
  FOR cur_rec IN 1 ..5 LOOP
    DBMS_OUTPUT.put_line('value(1,100)= ' || DBMS_RANDOM.value(1,100));
  END LOOP;
END;
/
