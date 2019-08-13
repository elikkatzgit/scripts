CREATE OR REPLACE PROCEDURE Purge_Subscriber(pNumOfDaysBack in NUMBER) IS

  V_Sum_Updated_Rows  NUMBER(10) := 0;
  vLoopNum            NUMBER := 0;
  vNumOfRowsToProcess NUMBER := 25000;

  TYPE rowidTyp is table of rowid index by binary_integer;

  rowidS         rowidTyp;

  CURSOR subs_cursor(pNumOfDays IN NUMBER) IS
    SELECT ROWID
      FROM SGA_W_PSMS_SUBSCRIBER
     WHERE TS_LAST_MODIFIED < SYSDATE-pNumOfDays;

  BEGIN

      SGA_PKG.WRITE_SGA_W_LOG('Purge_Subscriber', 'Procedure Started, pNumOfDaysBack= ' || pNumOfDaysBack);

      vLoopNum := vLoopNum + 1;

      OPEN subs_cursor(pNumOfDaysBack);
      LOOP

        FETCH subs_cursor BULK COLLECT
        INTO rowidS LIMIT vNumOfRowsToProcess;

        IF rowidS.COUNT = 0 THEN
           SGA_PKG.WRITE_SGA_W_LOG('Purge_Subscriber',
                              'Cursor finished');
           EXIT;
        ELSE

          SGA_PKG.WRITE_SGA_W_LOG('Purge_Subscriber',
                                'Cursor opened: ' || rowidS.COUNT || ' rows');

          FORALL i IN 1 .. rowidS.COUNT
             DELETE SGA_W_PSMS_SUBSCRIBER
             WHERE ROWID = rowidS(i);

          V_Sum_Updated_Rows := V_Sum_Updated_Rows + sql%rowcount;

          COMMIT;

          SGA_PKG.WRITE_SGA_W_LOG('Purge_Subscriber',
                                    '#' || vLoopNum || ' - ' ||
                                     V_Sum_Updated_Rows);

          vLoopNum := vLoopNum + 1;

          EXIT WHEN subs_cursor%NOTFOUND;
          
          DBMS_LOCK.SLEEP(5);
        END IF;
      END LOOP;

      /* Free cursor used by the query. */
      CLOSE subs_cursor;

  SGA_PKG.WRITE_SGA_W_LOG('Purge_Subscriber',
                          'Procedure Ended, update rows:' ||
                           V_Sum_Updated_Rows);

EXCEPTION
  WHEN OTHERS THEN
    SGA_PKG.WRITE_SGA_W_LOG('Purge_Subscriber','Error: ' || SQLERRM);
END Purge_Subscriber;
/
