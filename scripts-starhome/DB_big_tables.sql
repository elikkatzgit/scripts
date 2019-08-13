select owner, table_name, TO_CHAR(num_rows,'999,999,999') num_row , ROUND((AVG_ROW_LEN * NUM_ROWS / 1024 / 1024/1024), 2) table_size_GB from dba_tables 
--where owner = 'AUS_VODAF_SPARX'
where num_rows is not null
--order by   ROUND((AVG_ROW_LEN * NUM_ROWS / 1024 / 1024/1024), 2)  desc
order by num_row desc




SELECT owner, tablespace_name, segment_name, ROUND(SUM(bytes)/1024/1024)  AS MBs 
 FROM DBA_SEGMENTS 
 WHERE tablespace_name = 'IGT_TABLE'
--AND owner like '%SMSQQ'
--AND segment_name like 'CDR%'
GROUP BY  owner, tablespace_name, segment_name
ORDER BY ROUND(SUM(bytes)/1024/1024) DESC




SELECT username FROM dba_users


ALTER DATABASE DATAFILE '/oracle_db/db1/db_igt/ora_igt_table_01.dbf' AUTOEXTEND ON MAXSIZE 20000M;