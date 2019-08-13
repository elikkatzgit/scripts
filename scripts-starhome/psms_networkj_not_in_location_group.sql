select c.country_name ,n.network_name 
from gsm_networks n, gsm_countries c
where n.country_id=c.country_id
minus
select c.country_name , nn.network_name
from gsm_networks nn , osms_location_group_networks o , gsm_countries c
where nn.network_id=o.network_id
and nn.country_id=c.country_id
