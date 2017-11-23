CREATE OR REPLACE FUNCTION f_IsValidEmail(text) returns BOOLEAN AS 
'select $1 ~ ''^[^@\s]+@[^@\s]+(\.[^@\s]+)+$'' as result
' LANGUAGE sql;
with 
users_dataset as (
	select 
		usrp.user_id, 
		(case when char_length(trim(rol."name")) > 2 then rol."name" else 'Сотрудник салона' end) as user_function, 
		(case when pst."name" = 'Стилист' then 'Мастер' else 
			(case when char_length(trim(pst."name")) > 2 then pst."name" else 'Мастер' end) end) as user_role, 
		brn.code as brand
	from user_posts as usrp
		left join posts as pst on usrp.post_id = pst.id
		left join roles as rol on pst.role_id = rol.id
		left join user_post_brands as usrpb on usrp.user_id =  usrpb.user_post_id
		left join brands as brn on usrpb.brand_id = brn.id
	order by usrp.user_id),
clients_dataset as (
	select
		usr_sln.user_id,
		rgn."name" as megaregion,
		usr_sln.salon_id as client_id,
		sln.city as client_city,
		sln."name" || '. ' || sln.address as client_address,
		concat(spc."name", (case when sln_spc.special_program_id is not null then
									(case when sln_spc.accepted_at is not null then ':accepted' else ':invited' end) end) ) as client_program,
		sln_t."name" as client_type,
		sln.email as client_email,
		sln.phone as client_phone,
		sln.url as client_website,
		brn.code as brand
	from users_salons as usr_sln
		left join salons as sln on usr_sln.salon_id = sln.id
		left join regions_salons as rgn_sln on usr_sln.salon_id = rgn_sln.salon_id
		left join region_hierarchies as rgn_h on rgn_sln.region_id = rgn_h.descendant_id and rgn_h.generations = 2
		left join regions as rgn on rgn_h.ancestor_id = rgn.id
		left join salons_special_programs as sln_spc on usr_sln.id = sln_spc.salon_id
		left join special_programs as spc on sln_spc.special_program_id = spc.id
		left join salon_types as sln_t on sln.salon_type_id = sln_t.id
		left join brands as brn on rgn.brand_id = brn.id)
---
---
select
	usr.id as "User_ID",
	lower(usr.email) as "Email Address",
	usr.mobile_number,
	usr.first_name, 
	usr.last_name, 
	'B2B' as Base,
	array_to_string(array_agg(distinct usr_d.user_function), '; ') as "Function",
	array_to_string(array_agg(distinct usr_d.user_role), '; ') as "Role",
	array_to_string(array_agg(distinct usr_d.brand), '; ') as "Brand",
	array_to_string(array_agg(distinct cln_d.megaregion), '; ') as "Megaregion",
	array_to_string(array_agg(distinct cln_d.client_id), '; ') as "Client_ID",
	array_to_string(array_agg(distinct cln_d.client_city), '; ') as "Client_City",
	array_to_string(array_agg(distinct cln_d.client_address), '; ') as "Client_Address",
	array_to_string(array_agg(distinct cln_d.client_program), '; ') as "Client_Program",
	array_to_string(array_agg(distinct cln_d.client_type), '; ') as "Client_Type",
	array_to_string(array_agg(distinct cln_d.client_email), '; ') as "client_email",
	array_to_string(array_agg(distinct cln_d.client_phone), '; ') as "client_phone",
	array_to_string(array_agg(distinct cln_d.client_website), '; ') as "client_website"
from users as usr
	left join users_dataset as usr_d on usr.id = usr_d.user_id
	left join clients_dataset as cln_d on usr.id = cln_d.user_id
where f_IsValidEmail(usr.email) and usr.deleted_at is null
group by usr.id
union all
select distinct
	sln.id,
	lower(sln.email),
	sln.phone,
	'', 
	'', 
	'',
	'client'  as "Function",
	array_to_string(array_agg(distinct cln_d.client_type), '; ') as "Role",
	array_to_string(array_agg(distinct cln_d.brand), '; ') as "Brand",
	array_to_string(array_agg(distinct cln_d.megaregion), '; ') as "Megaregion",
	array_to_string(array_agg(distinct cln_d.client_id), '; ') as "Client_ID",
	array_to_string(array_agg(distinct cln_d.client_city), '; ') as "Client_City",
	array_to_string(array_agg(distinct cln_d.client_address), '; ') as "Client_Address",
	array_to_string(array_agg(distinct cln_d.client_program), '; ') as "Client_Program",
	array_to_string(array_agg(distinct cln_d.client_type), '; ') as "Client_Type",
	array_to_string(array_agg(distinct cln_d.client_email), '; ') as "client_email",
	array_to_string(array_agg(distinct cln_d.client_phone), '; ') as "client_phone",
	array_to_string(array_agg(distinct cln_d.client_website), '; ') as "client_website"
from salons as sln
	left join clients_dataset as cln_d on sln.id = cln_d.client_id
where f_IsValidEmail(sln.email)	and sln.deleted_at is null
group by sln.id


