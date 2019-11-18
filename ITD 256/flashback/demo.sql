set echo on
drop table t;
clear screen
create table t as select * from all_users where rownum <= 15;
variable x refcursor
variable y refcursor
variable z refcursor
pause
clear screen
exec open :x for select * from t;
delete from t where rownum <= 5;
commit;
exec open :y for select * from t;
delete from t where rownum <= 5;
commit;
exec open :z for select * from t;
pause
clear screen
print x
pause
clear screen
print y
pause 
clear screen
print z
