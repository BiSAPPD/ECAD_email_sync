select  
	lower(usr.email), 
	usr.id,
	usr.first_name, 
	usr.last_name, 
	'B2B' as Base,
	array(
		select distinct
			rol."name" 
		from user_posts as usrp
			left join posts as pst on usrp.post_id = pst.id
			left join roles as rol on pst.role_id = rol.id
		where usr.id = usrp.user_id) as function,
	array(
		select distinct 
			(case when pst."name" = 'Стилист' then 'Мастер' else pst."name" end)
		from user_posts as usrp
			left join posts as pst on usrp.post_id = pst.id
		where usr.id = usrp.user_id) as Role,
	array(
		select distinct 
			brn.code
		from user_posts as usrp
			left join posts as pst on usrp.post_id = pst.id
			left join roles as rol on pst.role_id = rol.id
			left join user_post_brands as usrpb on usrp.user_id =  usrpb.user_post_id
			left join brands as brn on usrpb.brand_id = brn.id
		where usr.id = usrp.user_id) as brand,
	array(
		select distinct
			usr_sln.salon_id
		from users_salons as usr_sln
		where usr.id = usr_sln.user_id
		) as client_id,
	array(
		select distinct 
			sln.city
		from users_salons as usr_sln
			left join salons as sln on usr_sln.salon_id = sln.id
		where usr.id = usr_sln.user_id
		) as client_city,
	array(
		select distinct 
			sln."name" || '. ' || sln.address
		from users_salons as usr_sln
			left join salons as sln on usr_sln.salon_id = sln.id
		where usr.id = usr_sln.user_id
		) as client_name,
	array(
		select distinct
			rgn."name"
		from users_salons as usr_sln
			left join regions_salons as rgn_sln on usr_sln.salon_id = rgn_sln.salon_id
			left join region_hierarchies as rgn_h on rgn_sln.region_id = rgn_h.descendant_id and rgn_h.generations = 2
			left join regions as rgn on rgn_h.ancestor_id = rgn.id 	
		where usr.id = usr_sln.user_id
		) as megaregion,
	array(
		select distinct
			concat(spc."name", (case when sln_spc.special_program_id is not null then
									(case when sln_spc.accepted_at is not null then ':accepted' else ':invited' end) end) )
		from users_salons as usr_sln
			left join salons_special_programs as sln_spc on usr_sln.id = sln_spc.salon_id
			left join special_programs as spc on sln_spc.special_program_id = spc.id
		where usr.id = usr_sln.user_id
		) as salon_type_club,
	array(
		select distinct 
			sln_t."name"
		from users_salons as usr_sln
			left join salons as sln on usr_sln.salon_id = sln.id
			left join salon_types as sln_t on sln.salon_type_id = sln_t.id
		where usr.id = usr_sln.user_id
		) as client_type
from users as usr
order by usr.id


