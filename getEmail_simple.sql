CREATE OR REPLACE FUNCTION f_IsValidEmail(text) returns BOOLEAN AS 
'select $1 ~ ''^[^@\s]+@[^@\s]+(\.[^@\s]+)+$'' as result
' LANGUAGE sql;

WITH  list_emails (email)
AS ( 
select email , brand_LP , brand_MX, brand_KR, brand_RD, brand_ES, role, com_mreg
from dblink('dbname=loreal', 
'select 
distinct usr.email,
current_database() as brand_LP, 
Null as brand_MX, 
Null as brand_KR, 
Null as brand_RD, 
Null as brand_ES,
usr.role,
sln.com_mreg

from users as usr
left join salons as sln ON sln.id = usr.salon_id or usr.id = sln.salon_manager_id
Where char_length(usr.email) > 5')
AS  (email text, brand_LP text, brand_MX text, brand_KR text, brand_RD text, brand_ES text, role text, com_mreg text)

UNION ALL

select email , brand_LP , brand_MX, brand_KR, brand_RD, brand_ES, role, com_mreg
from dblink('dbname=loreal', 
'select 
distinct sln.email,
current_database() as brand_LP, 
Null as brand_MX, 
Null as brand_KR, 
Null as brand_RD, 
Null as brand_ES,
''salon'' as role,
sln.com_mreg

from salons as sln
Where char_length(sln.email) > 5')
AS  (email text, brand_LP text, brand_MX text, brand_KR text, brand_RD text, brand_ES text, role text, com_mreg text)
) 
SELECT distinct lml.email, 
Concat( (Case when lml_lp.brand_lp is not Null then 'LP; ' end), 
	(Case when lml_mx.brand_mx is not Null then 'MX; ' end),
	(Case when lml_kr.brand_kr is not Null then 'KR; ' end),
	(Case when lml_rd.brand_rd is not Null then 'RD; ' end),
	(Case when lml_es.brand_es is not Null then 'ES; ' end)) as brand,

(case 	when lml.role like 'salon_manager' then 'salon_manager' else
	(Case when lml.role like '%technolog%' then 'educater' else
	(case when lml.role in ('%partimer%', 'partner', 'studio_manager' , 'studio_administrator') then 'educater' else
	(case when lml.role in('%representative%', 'cs', 'dr', 'supervisor') then 'commercial' else 
	(case when lml.role in ('salon') then 'salon' else 'master'
	end)end)end)end)end) as role_nm,

(case 	
when lml.role like 'salon_manager' then '3' 
when lml.role like '%technolog%' then '1' 
when lml.role in ('%partimer%', 'partner', 'studio_manager' , 'studio_administrator') then '1' 
when lml.role in('%representative%', 'cs', 'dr', 'supervisor') then '2' 
when lml.role in ('salon') then '4' 
else '5'
	end)  as prioritet,


lml_lp.com_mreg,
row_number() over (partition by lml.email order by 4) as num

  FROM list_emails as lml
  left join list_emails as lml_lp on lml.email = lml_lp.email and lml_lp.brand_lp = 'loreal'
  left join list_emails as lml_mx on lml.email = lml_mx.email and lml_mx.brand_mx = 'matrix'
  left join list_emails as lml_kr on lml.email = lml_kr.email and lml_kr.brand_kr = 'luxe'
  left join list_emails as lml_rd on lml.email = lml_rd.email and lml_rd.brand_rd = 'redken'
  left join list_emails as lml_es on lml.email = lml_es.email and lml_es.brand_es = 'essie'

 
  
  Where f_IsValidEmail(lml.email)
group by lml.email, lml_lp.brand_lp, lml_mx.brand_mx, lml_kr.brand_kr, lml_rd.brand_rd, lml_es.brand_es, lml.role, 
lml_lp.com_mreg, lml_mx.com_mreg, lml_kr.com_mreg, lml_rd.com_mreg, lml_es.com_mreg 

 order by  lml.email, 4



