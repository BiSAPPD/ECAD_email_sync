CREATE OR REPLACE FUNCTION f_IsValidEmail(text) returns BOOLEAN AS 
'select $1 ~ ''^[^@\s]+@[^@\s]+(\.[^@\s]+)+$'' as result
' LANGUAGE sql;

WITH RECURSIVE list_emails (email)
AS ( 
select email , brand_LP , brand_MX, brand_KR, brand_RD, brand_ES, fname, lname, role, salon_name, mobile_number, com_mreg, sln_id_lp, sln_id_mx, sln_id_kr, sln_id_rd, sln_id_es 
from 
dblink('dbname=loreal', 
'select 
distinct usr.email,
 
current_database() as brand_LP, 
Null as brand_MX, 
Null as brand_KR, 
Null as brand_RD, 
Null as brand_ES,

usr.fname,
usr.lname,
usr.role,
trim (sln.name || ''. '' || SLN.address || ''. ''|| sln.city_name_geographic) as "salon_name",
trim(usr.mobile_number),
sln.com_mreg,

sln.id as sln_id_lp,
Null as sln_id_mx,
Null as sln_id_kr,
Null as sln_id_rd,
Null as sln_id_es

from users as usr
left join salons as sln ON sln.id = usr.salon_id or usr.id = sln.salon_manager_id

Where char_length(usr.email) > 5' )

AS  (email text, brand_LP text, brand_MX text, brand_KR text, brand_RD text, brand_ES text, fname text, lname text, role text, salon_name text, mobile_number text, com_mreg text, sln_id_lp int,
sln_id_mx int, sln_id_kr int , sln_id_rd int , sln_id_es int)

union all

select email , brand_LP , brand_MX, brand_KR, brand_RD, brand_ES, fname, lname, role, salon_name, mobile_number, com_mreg, sln_id_lp, sln_id_mx, sln_id_kr, sln_id_rd, sln_id_es 
from 
dblink('dbname=matrix', 
'select 
distinct usr.email,
 
Null as brand_LP, 
current_database() as brand_MX, 
Null as brand_KR, 
Null as brand_RD, 
Null as brand_ES,

usr.fname,
usr.lname,
usr.role,
trim (sln.name || ''. '' || SLN.address || ''. ''|| sln.city_name_geographic) as "salon_name",
trim(usr.mobile_number),
sln.com_mreg,

Null as sln_id_lp,
sln.id as sln_id_mx,
Null as sln_id_kr,
Null as sln_id_rd,
Null as sln_id_es

from users as usr
left join salons as sln ON sln.id = usr.salon_id or usr.id = sln.salon_manager_id

Where char_length(usr.email) > 5' )

AS  (email text, brand_LP text, brand_MX text, brand_KR text, brand_RD text, brand_ES text, fname text, lname text, role text, salon_name text, mobile_number text, com_mreg text, sln_id_lp int,
sln_id_mx int, sln_id_kr int , sln_id_rd int , sln_id_es int)

union all

select email , brand_LP , brand_MX, brand_KR, brand_RD, brand_ES, fname, lname, role, salon_name, mobile_number, com_mreg, sln_id_lp, sln_id_mx, sln_id_kr, sln_id_rd, sln_id_es 
from 
dblink('dbname=luxe', 
'select 
distinct usr.email,
 
Null as brand_LP, 
Null as brand_MX, 
current_database() as brand_KR, 
Null as brand_RD, 
Null as brand_ES,

usr.fname,
usr.lname,
usr.role,
trim (sln.name || ''. '' || SLN.address || ''. ''|| sln.city_name_geographic) as "salon_name",
Trim(usr.mobile_number),
sln.com_mreg,

Null as sln_id_lp,
Null as sln_id_mx,
sln.id as sln_id_kr,
Null as sln_id_rd,
Null as sln_id_es

from users as usr
left join salons as sln ON sln.id = usr.salon_id or usr.id = sln.salon_manager_id

Where char_length(usr.email) > 5' )

AS  (email text, brand_LP text, brand_MX text, brand_KR text, brand_RD text, brand_ES text, fname text, lname text, role text, salon_name text, mobile_number text, com_mreg text, sln_id_lp int,
sln_id_mx int, sln_id_kr int , sln_id_rd int , sln_id_es int)

union all

select email , brand_LP , brand_MX, brand_KR, brand_RD, brand_ES, fname, lname, role, salon_name, mobile_number, com_mreg, sln_id_lp, sln_id_mx, sln_id_kr, sln_id_rd, sln_id_es 
from 
dblink('dbname=redken', 
'select 
distinct usr.email,
 
Null as brand_LP, 
Null as brand_MX, 
Null as brand_KR, 
current_database() as brand_RD, 
Null as brand_ES,

usr.fname,
usr.lname,
usr.role,
trim (sln.name || ''. '' || SLN.address || ''. ''|| sln.city_name_geographic) as "salon_name",
trim(usr.mobile_number),
sln.com_mreg,

Null as sln_id_lp,
Null as sln_id_mx,
Null as sln_id_kr,
sln.id as sln_id_rd,
Null as sln_id_es

from users as usr
left join salons as sln ON sln.id = usr.salon_id or usr.id = sln.salon_manager_id

Where char_length(usr.email) > 5' )

AS  (email text, brand_LP text, brand_MX text, brand_KR text, brand_RD text, brand_ES text, fname text, lname text, role text, salon_name text, mobile_number text, com_mreg text, sln_id_lp int,
sln_id_mx int, sln_id_kr int , sln_id_rd int , sln_id_es int)

union all

select email , brand_LP , brand_MX, brand_KR, brand_RD, brand_ES, fname, lname, role, salon_name, mobile_number, com_mreg, sln_id_lp, sln_id_mx, sln_id_kr, sln_id_rd, sln_id_es 
from 
dblink('dbname=essie', 
'select 
distinct usr.email,
 
Null as brand_LP, 
Null as brand_MX, 
Null as brand_KR, 
Null as brand_RD, 
current_database() as brand_ES,

usr.fname,
usr.lname,
usr.role,
trim (sln.name || ''. '' || SLN.address || ''. ''|| sln.city_name_geographic) as "salon_name",
trim(usr.mobile_number),
sln.com_mreg,

Null as sln_id_lp,
Null as sln_id_mx,
Null as sln_id_kr,
Null as sln_id_rd,
sln.id as sln_id_es

from users as usr
left join salons as sln ON sln.id = usr.salon_id or usr.id = sln.salon_manager_id

Where char_length(usr.email) > 5' )

AS  (email text, brand_LP text, brand_MX text, brand_KR text, brand_RD text, brand_ES text, fname text, lname text, role text, salon_name text, mobile_number text, com_mreg text, sln_id_lp int,
sln_id_mx int, sln_id_kr int , sln_id_rd int , sln_id_es int)


) SELECT distinct lml.email, 
Concat( (Case when lml_lp.brand_lp is not Null then 'LP; ' end), 
	(Case when lml_mx.brand_mx is not Null then 'MX; ' end),
	(Case when lml_kr.brand_kr is not Null then 'KR; ' end),
	(Case when lml_rd.brand_rd is not Null then 'RD; ' end),
	(Case when lml_es.brand_es is not Null then 'ES; ' end)) as brand,

(case 	when lml.role like 'salon_manager' then 'salon_manager' else
	(Case when lml.role like '%technolog%' then 'educater' else
	(case when lml.role in ('%partimer%', 'partner', 'studio_manager' , 'studio_administrator') then 'educater' else
	(case when lml.role in('%representative%', 'cs', 'dr', 'supervisor') then 'commercial'	else 'master'
	end)end)end)end) as role

--(Case 
--	when lml_lp.lname is not Null then lml_lp.lname 
--	when lml_mx.lname is not Null then lml_mx.lname
--	when lml_kr.lname is not Null then lml_kr.lname
--	when lml_rd.lname is not Null then lml_rd.lname
--	when lml_es.lname is not Null then lml_es.lname
--	end) as "Last Name",
--
-- (Case 
--	when lml_lp.fname is not Null then lml_lp.fname 
--	when lml_mx.fname is not Null then lml_mx.fname
--	when lml_kr.fname is not Null then lml_kr.fname
--	when lml_rd.fname is not Null then lml_rd.fname
--	when lml_es.fname is not Null then lml_es.fname
--	end) as "First Name",
--
 --(Case 
--	when lml_lp.salon_name is not Null then lml_lp.salon_name 
--	when lml_mx.salon_name is not Null then lml_mx.salon_name
--	when lml_kr.salon_name is not Null then lml_kr.salon_name
--	when lml_rd.salon_name is not Null then lml_rd.salon_name
--	when lml_es.salon_name is not Null then lml_es.salon_name
--	end) as "salon_name",
--
--  (Case 
--	when lml_lp.mobile_number is not Null then lml_lp.mobile_number 
--	when lml_mx.mobile_number is not Null then lml_mx.mobile_number
--	when lml_kr.mobile_number is not Null then lml_kr.mobile_number
--	when lml_rd.mobile_number is not Null then lml_rd.mobile_number
--	when lml_es.mobile_number is not Null then lml_es.mobile_number
--	end) as "mobile_number",
--
--  (Case 
--	when lml_lp.com_mreg is not Null then lml_lp.com_mreg 
--	when lml_mx.com_mreg is not Null then lml_mx.com_mreg
--	when lml_kr.com_mreg is not Null then lml_kr.com_mreg
--	when lml_rd.com_mreg is not Null then lml_rd.com_mreg
--	when lml_es.com_mreg is not Null then lml_es.com_mreg
--	end) as "com_mreg"

  FROM list_emails as lml
  left join list_emails as lml_lp on lml.email = lml_lp.email and lml_lp.brand_lp = 'loreal'
  left join list_emails as lml_mx on lml.email = lml_mx.email and lml_mx.brand_mx = 'matrix'
  left join list_emails as lml_kr on lml.email = lml_kr.email and lml_kr.brand_kr = 'luxe'
  left join list_emails as lml_rd on lml.email = lml_rd.email and lml_rd.brand_rd = 'redken'
  left join list_emails as lml_es on lml.email = lml_es.email and lml_es.brand_es = 'essie'

  

  
  Where f_IsValidEmail(lml.email) 
group by lml.email, lml_lp.brand_lp, lml_mx.brand_mx, lml_kr.brand_kr, lml_rd.brand_rd, lml_es.brand_es, lml.role, lml_lp.lname, lml_mx.lname, lml_kr.lname, lml_rd.lname, lml_es.lname, lml_lp.fname, 
lml_mx.fname, lml_kr.fname, lml_rd.fname, lml_es.fname,  lml_lp.salon_name, lml_mx.salon_name, lml_kr.salon_name, lml_rd.salon_name, lml_es.salon_name, lml_lp.mobile_number, lml_mx.mobile_number, lml_kr.mobile_number, lml_rd.mobile_number, lml_es.mobile_number,  
lml_lp.com_mreg, lml_mx.com_mreg, lml_kr.com_mreg, lml_rd.com_mreg, lml_es.com_mreg 

 order by lml.email
