SET SERVEROUTPUT ON
DECLARE
  TYPE t_object_id_tab IS TABLE OF bulk_collect_test.object_id%TYPE;

  l_tab  t_object_id_tab;
BEGIN
  DELETE FROM bulk_collect_test
  RETURNING object_id BULK COLLECT INTO l_tab;

  DBMS_OUTPUT.put_line('Deleted IDs : ' || l_tab.count || ' rows');

  ROLLBACK;
END;
/
