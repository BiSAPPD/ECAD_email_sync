WITH RECURSIVE list_emails(email) 
AS ( 
select email , brand from 
dblink('dbname=loreal', 
'select 
distinct email, 
current_database() as brand,
from users Where char_length(email) > 5 ' ) AS  (email  text, brand text )

union all

select email , brand from 
dblink('dbname=matrix', 
'select distinct email, current_database() as brand 
from users Where char_length(email) > 5 ') AS  (email  text, brand text )

union all

select email , brand from 
dblink('dbname=luxe', 
'select distinct email, current_database() as brand 
from users Where char_length(email) > 5 ') AS  (email  text, brand text )

union all

select email , brand from 
dblink('dbname=redken', 
'select distinct email, current_database() as brand 
from users Where char_length(email) > 5 ') AS  (email  text, brand text )

union all

select email , brand from 
dblink('dbname=essie', 
'select distinct email, current_database() as brand 
from users Where char_length(email) > 5 ') AS  (email  text, brand text )


) SELECT distinct email
  FROM list_emails
  order by email