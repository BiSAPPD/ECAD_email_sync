CREATE OR REPLACE FUNCTION f_IsValidEmail(text) returns BOOLEAN AS 
'select $1 ~ ''^[^@\s]+@[^@\s]+(\.[^@\s]+)+$'' as result
' LANGUAGE sql;

WITH  list_emails
AS ( 
select email , brand, fname, lname, role_type, role_type_num, role, salon_name, mobile_number, com_mreg, geo_city, sln_id 
from 
dblink('dbname=loreal', 
'select 
distinct usr.email,
current_database() as brand, 
usr.fname,
usr.lname,

(case  when usr.role like  ''salon_manager'' then ''salon_manager'' 
	 when usr.role in (''technolog'', ''studio_manager'' , ''studio_administrator'', ''admin'') then ''educater'' 
	 when usr.role in(''representative'', ''cs'', ''dr'', ''supervisor'') then ''commercial''	
	 else ''master''
	end) as role_type,

(case  when usr.role like  ''salon_manager'' then ''3'' 
	 when usr.role in (''technolog'', ''studio_manager'' , ''studio_administrator'', ''admin'') then ''2'' 
	 when usr.role in(''representative'', ''cs'', ''dr'', ''supervisor'') then ''1''	
	 else ''4''
	end) as role_type_num,

usr.role,
	

trim (sln.name || ''. '' || SLN.address || ''. ''|| sln.city_name_geographic) as "salon_name",
trim(usr.mobile_number),
sln.com_mreg,
(Case when sln.city_name_geographic is not Null Then sln.city_name_geographic else usr.city_name end) as geo_city, 
sln.id

from users as usr
left join salons as sln ON sln.id = usr.salon_id or usr.id = sln.salon_manager_id

Where char_length(usr.email) > 5 

union all

select sln.email,

current_database() as brand, 
'''' As fname,
'''' as lname,
''salon'' as role_type,
''4'' as role_type_num,
''salon'' as role,
trim (sln.name || ''. '' || SLN.address || ''. ''|| sln.city_name_geographic) as "salon_name",
'''' as mobile_number,
sln.com_mreg,
sln.city_name_geographic as geo_city, 
sln.id
 
from salons as sln

')
AS  (email text, brand text, fname text, lname text, role_type text, role_type_num int, role text, salon_name text, mobile_number text, com_mreg text, geo_city text, sln_id int)

union all


--'--------------------------------------------------------------------------------------------------------- 

select email , brand, fname, lname, role_type, role_type_num, role, salon_name, mobile_number, com_mreg, geo_city, sln_id 
from 
dblink('dbname=matrix', 
'select 
distinct usr.email,
current_database() as brand, 
usr.fname,
usr.lname,

(case  when usr.role like  ''salon_manager'' then ''salon_manager'' 
	 when usr.role in (''technolog'', ''studio_manager'' , ''studio_administrator'', ''admin'') then ''educater'' 
	 when usr.role in(''representative'', ''cs'', ''dr'', ''supervisor'') then ''commercial''	
	 else ''master''
	end) as role_type,

(case  when usr.role like  ''salon_manager'' then ''3'' 
	 when usr.role in (''technolog'', ''studio_manager'' , ''studio_administrator'', ''admin'') then ''2'' 
	 when usr.role in(''representative'', ''cs'', ''dr'', ''supervisor'') then ''1''	
	 else ''4''
	end) as role_type_num,

usr.role,
	

trim (sln.name || ''. '' || SLN.address || ''. ''|| sln.city_name_geographic) as "salon_name",
trim(usr.mobile_number),
sln.com_mreg,
(Case when sln.city_name_geographic is not Null Then sln.city_name_geographic else usr.city_name end) as geo_city, 
sln.id

from users as usr
left join salons as sln ON sln.id = usr.salon_id or usr.id = sln.salon_manager_id

Where char_length(usr.email) > 5

union all

select sln.email,

current_database() as brand, 
'''' As fname,
'''' as lname,
''salon'' as role_type,
''4'' as role_type_num,
''salon'' as role,
trim (sln.name || ''. '' || SLN.address || ''. ''|| sln.city_name_geographic) as "salon_name",
'''' as mobile_number,
sln.com_mreg,
sln.city_name_geographic as geo_city, 
sln.id
 
from salons as sln

')


AS  (email text, brand text, fname text, lname text, role_type text, role_type_num int, role text, salon_name text, mobile_number text, com_mreg text, geo_city text, sln_id int)

union all

select email , brand, fname, lname, role_type, role_type_num, role, salon_name, mobile_number, com_mreg, geo_city, sln_id 
from 
dblink('dbname=luxe', 
'select 
distinct usr.email,
current_database() as brand, 
usr.fname,
usr.lname,

(case  when usr.role like  ''salon_manager'' then ''salon_manager'' 
	 when usr.role in (''technolog'', ''studio_manager'' , ''studio_administrator'', ''admin'') then ''educater'' 
	 when usr.role in(''representative'', ''cs'', ''dr'', ''supervisor'') then ''commercial''	
	 else ''master''
	end) as role_type,

(case  when usr.role like  ''salon_manager'' then ''3'' 
	 when usr.role in (''technolog'', ''studio_manager'' , ''studio_administrator'', ''admin'') then ''2'' 
	 when usr.role in(''representative'', ''cs'', ''dr'', ''supervisor'') then ''1''	
	 else ''4''
	end) as role_type_num,

usr.role,
	

trim (sln.name || ''. '' || SLN.address || ''. ''|| sln.city_name_geographic) as "salon_name",
trim(usr.mobile_number),
sln.com_mreg,
(Case when sln.city_name_geographic is not Null Then sln.city_name_geographic else usr.city_name end) as geo_city, 
sln.id

from users as usr
left join salons as sln ON sln.id = usr.salon_id or usr.id = sln.salon_manager_id

Where char_length(usr.email) > 5

union all

select sln.email,

current_database() as brand, 
'''' As fname,
'''' as lname,
''salon'' as role_type,
''4'' as role_type_num,
''salon'' as role,
trim (sln.name || ''. '' || SLN.address || ''. ''|| sln.city_name_geographic) as "salon_name",
'''' as mobile_number,
sln.com_mreg,
sln.city_name_geographic as geo_city, 
sln.id
 
from salons as sln

')

AS  (email text, brand text, fname text, lname text, role_type text, role_type_num int, role text, salon_name text, mobile_number text, com_mreg text, geo_city text, sln_id int)

union all

select email , brand, fname, lname, role_type, role_type_num, role, salon_name, mobile_number, com_mreg, geo_city, sln_id 
from 
dblink('dbname=redken', 
'select 
distinct usr.email,
current_database() as brand, 
usr.fname,
usr.lname,

(case  when usr.role like  ''salon_manager'' then ''salon_manager'' 
	 when usr.role in (''technolog'', ''studio_manager'' , ''studio_administrator'', ''admin'') then ''educater'' 
	 when usr.role in(''representative'', ''cs'', ''dr'', ''supervisor'') then ''commercial''	
	 else ''master''
	end) as role_type,

(case  when usr.role like  ''salon_manager'' then ''3'' 
	 when usr.role in (''technolog'', ''studio_manager'' , ''studio_administrator'', ''admin'') then ''2'' 
	 when usr.role in(''representative'', ''cs'', ''dr'', ''supervisor'') then ''1''	
	 else ''4''
	end) as role_type_num,

usr.role,
	

trim (sln.name || ''. '' || SLN.address || ''. ''|| sln.city_name_geographic) as "salon_name",
trim(usr.mobile_number),
sln.com_mreg,
(Case when sln.city_name_geographic is not Null Then sln.city_name_geographic else usr.city_name end) as geo_city, 
sln.id

from users as usr
left join salons as sln ON sln.id = usr.salon_id or usr.id = sln.salon_manager_id

Where char_length(usr.email) > 5

union all

select sln.email,

current_database() as brand, 
'''' As fname,
'''' as lname,
''salon'' as role_type,
''4'' as role_type_num,
''salon'' as role,
trim (sln.name || ''. '' || SLN.address || ''. ''|| sln.city_name_geographic) as "salon_name",
'''' as mobile_number,
sln.com_mreg,
sln.city_name_geographic as geo_city, 
sln.id
 
from salons as sln

')

AS  (email text, brand text, fname text, lname text, role_type text, role_type_num int, role text, salon_name text, mobile_number text, com_mreg text, geo_city text, sln_id int)

union all

select email , brand, fname, lname, role_type, role_type_num, role, salon_name, mobile_number, com_mreg, geo_city, sln_id 
from 
dblink('dbname=essie', 
'select 
distinct usr.email,
current_database() as brand, 
usr.fname,
usr.lname,

(case  when usr.role like  ''salon_manager'' then ''salon_manager'' 
	 when usr.role in (''technolog'', ''studio_manager'' , ''studio_administrator'', ''admin'') then ''educater'' 
	 when usr.role in(''representative'', ''cs'', ''dr'', ''supervisor'') then ''commercial''	
	 else ''master''
	end) as role_type,

(case  when usr.role like  ''salon_manager'' then ''3'' 
	 when usr.role in (''technolog'', ''studio_manager'' , ''studio_administrator'', ''admin'') then ''2'' 
	 when usr.role in(''representative'', ''cs'', ''dr'', ''supervisor'') then ''1''	
	 else ''4''
	end) as role_type_num,

usr.role,
	

trim (sln.name || ''. '' || SLN.address || ''. ''|| sln.city_name_geographic) as "salon_name",
trim(usr.mobile_number),
sln.com_mreg,
(Case when sln.city_name_geographic is not Null Then sln.city_name_geographic else usr.city_name end) as geo_city, 
sln.id

from users as usr
left join salons as sln ON sln.id = usr.salon_id or usr.id = sln.salon_manager_id

Where char_length(usr.email) > 5

union all

select sln.email,

current_database() as brand, 
'''' As fname,
'''' as lname,
''salon'' as role_type,
''4'' as role_type_num,
''salon'' as role,
trim (sln.name || ''. '' || SLN.address || ''. ''|| sln.city_name_geographic) as "salon_name",
'''' as mobile_number,
sln.com_mreg,
sln.city_name_geographic as geo_city, 
sln.id
 
from salons as sln

')

AS  (email text, brand text, fname text, lname text, role_type text, role_type_num int, role text, salon_name text, mobile_number text, com_mreg text, geo_city text, sln_id int)


) , uniq_email_list (email) as (select distinct lml.email from list_emails as lml order by lml.email)
 
SELECT 
ulml.email,

Concat( 	
	(Case when Sum((Case when lml.brand = 'loreal' then 1 else 0 end)) over (partition by ulml.email) <> 0 Then 'LP;' end) ,
	(Case when Sum((Case when lml.brand = 'matrix' then 1 else 0 end)) over (partition by ulml.email) <> 0 Then 'MX;' end),
	(Case when Sum((Case when lml.brand = 'luxe' then 1 else 0 end)) over (partition by ulml.email) <> 0 Then 'KR;' end), 
	(Case when Sum((Case when lml.brand = 'redken' then 1 else 0 end)) over (partition by ulml.email) <> 0 Then 'RD;' end), 
	(Case when Sum((Case when lml.brand = 'essie' then 1 else 0 end)) over (partition by ulml.email) <> 0 Then 'ES;' end)),

lml.role_type, lml.role, lml.fname, lml.lname, lml.salon_name,lml.com_mreg, lml.geo_city, lml.sln_id, 

row_number() over (partition by ulml.email order by lml.role_type_num, lml.email) 

FROM uniq_email_list as ulml 
left join list_emails as lml ON ulml.email = lml.email

-- left join 
-- 	dblink('dbname=academie', 
-- 	'select spcr.status as status, spc.id as id, spc.name as name, spc.brand_id as brand_id, spcr.salon_id as salon_id
-- 
-- 	from special_program_club_records as spcr
-- 	left join special_program_clubs as spc ON spcr.club_id = spc.id') AS spse (status  text, id integer, name text, brand_id  integer, salon_id  integer )
-- 	ON
-- 	lml.sln_id = spse.salon_id and spse.brand_id =  
-- 
-- (Case lml.brand
--                 When 'loreal' then 1
--                 When 'matrix' then 5
--                 When 'luxe' then 6
--                 When 'redken' then 7
--                 When 'essie' then 3
--                 End)
-- 	and 
-- 		(Case  when  spse.name like '%Emotion%' then 1 Else 
-- 			(Case when spse.name like '%Expert%' then 1 else
-- 				(Case when spse.name like '%МБК%' then 1 else 0 end)end)end) = 1

  
Where f_IsValidEmail(ulml.email)  


order by ulml.email, lml.role_type_num