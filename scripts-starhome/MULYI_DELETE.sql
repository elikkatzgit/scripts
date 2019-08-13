
If there is no ADMIN_UTIL:

CREATE OR REPLACE PACKAGE ADMIN_UTIL_PKG IS
PROCEDURE MULTI_DELETE      (p_days IN NUMBER, p_size IN NUMBER);
END ADMIN_UTIL_PKG;

--------------------------------------------------------------------------------------------

If there is no WRITE_SGA_W_LOG:

CREATE OR REPLACE PACKAGE BODY ADMIN_UTIL_PKG IS

  PROCEDURE WRITE_SGA_W_LOG(p_procedure_name IN VARCHAR2,
                            p_data           IN VARCHAR2) IS
  -- This function must run within a separate transaction to enable trigger usage.
  PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO SGA_W_LOG
      (procedure_name, data, ts_last_modified)
    VALUES
      (p_procedure_name, p_data, SYSDATE);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
       NULL;

  END WRITE_SGA_W_LOG;

END ADMIN_UTIL_PKG;

-----------------------------------------------------------------------------------------------

If there is no WRITE_SGA_W_LOG, add the below to the procedure above (first):

PROCEDURE MULTI_DELETE (p_days IN NUMBER, p_size IN NUMBER) IS

    v_date DATE;
    v_effected_rows NUMBER;
    v_delete_rows NUMBER;
    v_row_counter NUMBER;
    v_table_name VARCHAR2(30);
    v_sql_str VARCHAR2(1000);
    v_module_name VARCHAR2(30);
    v_msg_text VARCHAR2(1000);

  BEGIN
    v_table_name :='SGA_W_PSMS_SUBSCRIBER';
    v_effected_rows := 1; 
    v_row_counter := 0;
    v_module_name := 'MULTI DELETE';
    
    IF p_days IS NULL THEN
      v_date := SYSDATE - 180;
    ELSE  
      v_date := SYSDATE - p_days;      
    END IF;

    IF p_size IS NULL THEN
      v_delete_rows := 10001;
    ELSE  
      v_delete_rows := p_size;      
    END IF;


    v_sql_str := 'DELETE FROM '||v_table_name||' WHERE ROWNUM < '|| v_delete_rows ||' AND ts_e_last_lu < :1';
    v_msg_text  := 'MANUAL_DELETE FROM '||v_table_name|| '. Running SQL: '||v_sql_str||' - '||v_date;
    WRITE_SGA_W_LOG(v_module_name,v_msg_text);

    WHILE v_effected_rows > 0 LOOP
      EXECUTE IMMEDIATE v_sql_str USING v_date;
      v_effected_rows := SQL%ROWCOUNT;
      v_row_counter := v_row_counter + v_effected_rows;
      v_msg_text := v_row_counter||' rows deleted from table '||v_table_name;
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
      COMMIT;
      --Sleep 10 seconds
      DBMS_LOCK.sleep(10);    
    END LOOP; 
  
    v_msg_text := 'MANUAL_DELETE FROM '||v_table_name||' Finished Successfully';
    WRITE_SGA_W_LOG(v_module_name,v_msg_text);
    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      v_msg_text := 'Error in procedure '||v_module_name||'. Error Details: '|| SUBSTR(SQLERRM, 1, 900); 
      WRITE_SGA_W_LOG(v_module_name,v_msg_text);
      DBMS_OUTPUT.put_line(v_msg_text ); 
  END MULTI_DELETE;


-------------------------------------------------------------------------------------------

creat a JOB: ADMIN_UTIL_PKG.MULTI_DELETE(365,10001)