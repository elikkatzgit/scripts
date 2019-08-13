SET NEWPAGE 0
SET SPACE 0
SET LINESIZE 100
SET PAGESIZE 0
SET ECHO OFF
SET FEEDBACK OFF
SET HEADING OFF
SET DEFINE OFF

-- KPI report --
spool /starhome/ftm/statistics/kpi-report.tmp
select         
to_char(ts_last_modified,'dd-mm-yyyy hh24:mi:ss')|| ',' ||
case node_id
when '11' then 'sx1'
when '12' then 'sx2'
when '13' then 'sx3'
when '14' then 'sx4'
when '999' then 'smm'
end || ',' ||
counter_name || ',' ||
counter_delta
from GA_COUNTERS_VW
where static_id in ( 
1011500104010006,102050101000000,1014330100000000,1014330500000000,1014330700000000,1011500104010004,1011500104010008,1011500104010041,1011500104010007,1011500104010005,1011500104010003,1011500104010001,1011500104010000)
group by to_char(ts_last_modified,'dd-mm-yyyy hh24:mi:ss'),node_id,counter_name,counter_delta
order by to_char(ts_last_modified,'dd-mm-yyyy hh24:mi:ss'),node_id,counter_name,counter_delta;

select distinct(to_char(t.ts_last_modified,'dd-mm-yyyy hh24:mi:ss')) || ',' || 'smm' || ',' || 'Services_SMM_total_success_rate' ||','||round(a/b,4)*100 as success_rate from 
(select counter_delta a from  GA_COUNTERS_VW where STATIC_ID = '1014330500000000'),
(select counter_delta b  from GA_COUNTERS_VW where STATIC_ID = '1014330100000000'), GA_COUNTERS_VW t;

spool off
host mv /starhome/ftm/statistics/kpi-report.tmp /starhome/ftm/statistics/kpi-report

-- sx1 report --
spool /starhome/ftm/statistics/sx1-report.tmp

select to_char(ts_last_modified,'dd-mm-yyyy hh24:mi:ss')|| ',' || node_id || ',' ||
static_id || ',' || DYN1 || ',' || DYN2 || ',' ||
counter_sum || ',' || counter_delta || ',' || counter_name
from  GA_COUNTERS_VW where node_id='11';

spool off
host mv /starhome/ftm/statistics/sx1-report.tmp /starhome/ftm/statistics/sx1-report

-- sx2 report --
spool /starhome/ftm/statistics/sx2-report.tmp

select to_char(ts_last_modified,'dd-mm-yyyy hh24:mi:ss')|| ',' || node_id || ',' ||
static_id || ',' || DYN1 || ',' || DYN2 || ',' ||
counter_sum || ',' || counter_delta || ',' || counter_name
from  GA_COUNTERS_VW where node_id='12';

spool off
host mv /starhome/ftm/statistics/sx2-report.tmp /starhome/ftm/statistics/sx2-report

-- sx3 report --
spool /starhome/ftm/statistics/sx3-report.tmp

select to_char(ts_last_modified,'dd-mm-yyyy hh24:mi:ss')|| ',' || node_id || ',' ||
static_id || ',' || DYN1 || ',' || DYN2 || ',' ||
counter_sum || ',' || counter_delta || ',' || counter_name
from  GA_COUNTERS_VW where node_id='13';

spool off
host mv /starhome/ftm/statistics/sx3-report.tmp /starhome/ftm/statistics/sx3-report
-- sx4 report --
spool /starhome/ftm/statistics/sx4-report.tmp

select to_char(ts_last_modified,'dd-mm-yyyy hh24:mi:ss')|| ',' || node_id || ',' ||
static_id || ',' || DYN1 || ',' || DYN2 || ',' ||
counter_sum || ',' || counter_delta || ',' || counter_name
from  GA_COUNTERS_VW where node_id='14';

spool off
host mv /starhome/ftm/statistics/sx4-report.tmp /starhome/ftm/statistics/sx4-report
-- smm report --
spool /starhome/ftm/statistics/smm-report.tmp

select to_char(ts_last_modified,'dd-mm-yyyy hh24:mi:ss')|| ',' || node_id || ',' ||
static_id || ',' || DYN1 || ',' || DYN2 || ',' ||
counter_sum || ',' || counter_delta || ',' || counter_name
from  GA_COUNTERS_VW where node_id='999';

spool off
host mv /starhome/ftm/statistics/smm-report.tmp /starhome/ftm/statistics/smm-report
exit