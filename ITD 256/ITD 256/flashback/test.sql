drop table t;
create table t as select * from all_users where 1=0;

declare
	type array is table of t%rowtype;
	l_data array;
	cursor c is select * from all_users;
begin
	open c;
	loop
		fetch c bulk collect into l_data limit 10;
		forall i in 1 .. l_data.count
			insert into t values l_data(i);
		exit when c%notfound;
	end loop;
	close c;
end;
/
	
