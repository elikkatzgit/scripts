SELECT DISTINCT owner FROM all_objects order by owner;

select * from dba_profiles
where profile = 'SHDEFAULT'