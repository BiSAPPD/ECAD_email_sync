CREATE OR REPLACE FUNCTION f_IsValidEmail(text) returns BOOLEAN AS 
'select $1 ~ ''^[^@\s]+@[^@\s]+(\.[^@\s]+)+$'' as result
' LANGUAGE sql;
with 
users_dataset as (
	select 
		usp.user_id,
		rol."name"  as user_function, 
		(case when pst."name" = 'Стилист' then 'Мастер' else pst."name" end) as user_role, 
		brn.code as brand,
		rgn2."name" as megaregion
	from user_posts as usp
		left join posts as pst on usp.post_id = pst.id 
		left join roles as rol on pst.role_id = rol.id
		left join user_post_brands as upb on usp.id = upb.user_post_id 
		left join regions as rgn on rgn.id = upb.region_id
		left join region_hierarchies as rgn_h on upb.region_id = rgn_h.descendant_id and rgn_h.generations = (rgn.region_level - 4)
		left join regions as rgn2 on rgn_h.ancestor_id = rgn2.id
		left join brands as brn on upb.brand_id = brn.id or rgn.brand_id = brn.id
	order by usp.user_id),
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
	from salons as sln 
		left join users_salons as usr_sln on usr_sln.salon_id = sln.id
		left join regions_salons as rgn_sln on sln.id = rgn_sln.salon_id
		left join region_hierarchies as rgn_h on rgn_sln.region_id = rgn_h.descendant_id and rgn_h.generations = 2
		left join regions as rgn on rgn_h.ancestor_id = rgn.id
		left join salons_special_programs as sln_spc on usr_sln.id = sln_spc.salon_id
		left join special_programs as spc on sln_spc.special_program_id = spc.id
		left join salon_types as sln_t on sln.salon_type_id = sln_t.id
		left join brands as brn on rgn.brand_id = brn.id),
seminars_count as (
	select
		prt.user_id, 
		smrkt.name,
		count(prt.user_id) as cnt,
		array_to_string(array_agg(distinct smr.name ), '; ') as seminars
	from participations as prt 
		left join seminar_events as sme on prt.seminar_event_id = sme.id
		left join seminars as smr on sme.seminar_id = smr.id
		left join seminar_kpis_types as smrkt on smr.seminar_kpis_type_id = smrkt.id
		left join seminar_event_types as smret on sme.seminar_event_type_id = smret.id 
	group by prt.user_id, smrkt.name)
---
---
select
	lower(usr.email) as "Email Address",
	array_to_string(array_agg(distinct usr.id ), '; ') as "User_ID",
	array_to_string(array_agg(distinct usr.mobile_number), '; ') as mobile_number,
	array_to_string(array_agg(distinct usr.first_name), '; ') as first_name, 
	array_to_string(array_agg(distinct usr.last_name ), '; ') as last_name, 
	array_to_string(array_agg(distinct to_char(usr.last_request_at, 'DD.MM.YY') ), '; ')  as last_reauest_ecad,
	SUM(usr.login_count)::text as login_count_ecad,
	array_to_string(array_agg(distinct
		(case when usr_d.user_function = 'Сотрудник салона' then 'B2B' else 'internal' end)), '; ') as Base,
	array_to_string(array_agg(distinct 
		(case when usr_d.user_function = 'Сотрудник салона' and cln_d.client_id is null then 'Частный Мастер' else 
			(case when usr_d.user_function is null then 'Частный Мастер' else usr_d.user_function end)end)), '; ') as "Function",
	array_to_string(array_agg(distinct 
		(case when usr_d.user_role is null then 'Частный Мастер' else usr_d.user_role end)), '; ') as "Role",
	array_to_string(array_agg(distinct usr_d.brand), '; ') as "Brand",
	array_to_string(array_agg(distinct 
		(case when cln_d.megaregion is null then usr_d.megaregion else cln_d.megaregion end)), '; ') as "Megaregion",
	array_to_string(array_agg(distinct cln_d.client_id), '; ') as "Client_ID",
	array_to_string(array_agg(distinct cln_d.client_city), '; ') as "Client_City",
	array_to_string(array_agg(distinct cln_d.client_address), '; ') as "Client_Address",
	array_to_string(array_agg(distinct cln_d.client_program), '; ') as "Client_Program",
	array_to_string(array_agg(distinct cln_d.client_type), '; ') as "Client_Type",
	array_to_string(array_agg(distinct cln_d.client_email), '; ') as "client_email",
	array_to_string(array_agg(distinct cln_d.client_phone), '; ') as "client_phone",
	array_to_string(array_agg(distinct cln_d.client_website), '; ') as "client_website",
	(case when SUM(s1.cnt) > 0 then SUM(s1.cnt) else 0 end)::text as "Paid Seminars in Studio",
	(case when SUM(s2.cnt) > 0 then SUM(s2.cnt) else 0 end)::text as "Free Seminars in Studio",
	(case when SUM(s3.cnt) > 0 then SUM(s3.cnt) else 0 end)::text as "Consultations",
	(case when SUM(s4.cnt) > 0 then SUM(s4.cnt) else 0 end)::text as "Brand Day",
	(case when SUM(s5.cnt) > 0 then SUM(s5.cnt) else 0 end)::text as "Seminars in Salon",
	(case when SUM(s6.cnt) > 0 then SUM(s6.cnt) else 0 end)::text as "LSA",
	s1.seminars
from users as usr
	left join users_dataset as usr_d on usr.id = usr_d.user_id
	left join clients_dataset as cln_d on usr.id = cln_d.user_id
	left join seminars_count as s1 on usr.id = s1.user_id and s1.name = 'Paid Seminars in Studio'
	left join seminars_count as s2 on usr.id = s2.user_id and s2.name = 'Free Seminars in Studio'
	left join seminars_count as s3 on usr.id = s3.user_id and s3.name = 'Consultations'
	left join seminars_count as s4 on usr.id = s4.user_id and s4.name = 'Brand Day'
	left join seminars_count as s5 on usr.id = s5.user_id and s5.name = 'Seminars in Salon'
	left join seminars_count as s6 on usr.id = s6.user_id and s6.name = 'LSA'
where f_IsValidEmail(usr.email) and usr.deleted_at is null
group by usr.id, s1.seminars
--
union all
--
select distinct
	lower(sln.email)::text,
	array_to_string(array_agg(distinct sln.id), '; ')::text, 
	array_to_string(array_agg(distinct sln.phone) , '; ')::text,
	''::text, 
	''::text,
	''::text,
	''::text,
	'B2B'::text,
	'Клиент'::text  as "Function",
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
	array_to_string(array_agg(distinct cln_d.client_website), '; ') as "client_website",
	''::text,
	''::text,
	''::text,
	''::text,
	''::text,
	''::text,
	''::text
from salons as sln
	left join clients_dataset as cln_d on sln.id = cln_d.client_id
	left join users as usr1 on sln.email = usr1.email
where f_IsValidEmail(sln.email) and sln.deleted_at is null and usr1.email is null
group by sln.email