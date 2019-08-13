-- Check how many cursors are configured
SELECT  max(a.value) as highest_open_cur, p.value as max_open_cur FROM v$sesstat a, v$statname b, v$parameter p WHERE  a.statistic# = b.statistic#  and b.name = 'opened cursors current' and p.name= 'open_cursors' group by p.value;

-- Check the amount per query
select  sid ,sql_text, count(*) as "OPEN_CURSORS", USER_NAME from v$open_cursor --where sid in ('292','291') 
group by sid ,sql_text, user_name order by OPEN_CURSORS desc

-- Check the sessions per SID
select * from v$session
where sid in ('237','292','293') 

-- Check the PID to kill in OS level
select * from v$process where ADDR in ('000000009F52D238','000000009F52C238','000000009F556238')
