--List amount of connection per user and “program”
select username,program,count(*) from v$session group by username,program order by 3 desc

--top disk space consumers
select OWNER,SEGMENT_NAME,bytes/1024/1024 from dba_segments where bytes/1024/1024>300 order by 3 desc



alter system set processes=600 scope=spfile;
alter system set sessions=600 scope=spfile;

DB resources:

select resource_name, current_utilization,max_utilization,INITIAL_ALLOCATION Allocated from v$resource_limit where resource_name in ('processes','sessions')

select name, description, display_value from v$parameter
where name like 'mem%'

select * from 
(select resource_name, current_utilization,max_utilization,INITIAL_ALLOCATION Allocated from v$resource_limit where resource_name in ('processes','sessions')),
(select name , description, display_value from v$parameter
where name like 'memory_target%');


Some scripts for you:
Top current  cpu consumers on OS level:
ps -eo pid,pmem,cmd,pcpu -ww --sort=pcpu

Top  100 session CPU consumers over time
Select * from  (select a.sid,c.username,b.name,a.value
from V$sesstat a, v$statname b, V$session c
where a.STATISTIC# in (12)
and a.STATISTIC#=b.STATISTIC#
and a.sid=c.sid
order by a.value  desc)
where rownum<100;

Current sessions running SQL command. 
select v$session.username  "ORACLE USERNAME",
v$process.spid "OS PID",
V$SQLTEXT.SQL_TEXT,
v$session.sid
from v$session,v$process, V$SQLTEXT
where v$session.paddr=v$process.addr
and v$session.status='ACTIVE' 
and v$session.sql_hash_value= V$SQLTEXT.HASH_VALUE
and v$session.sql_address=V$SQLTEXT.address
order by sid,piece;
