select c.country_name, n.network_name, n.PLMN_CODE  from gsm_networks n ,gsm_countries c
where n.PLMN_CODE like 'DEU%'
and c.country_id=n.country_id