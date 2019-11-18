@connect scott/tiger


set echo off
whenever sqlerror exit

declare
    l_text varchar2(255);
begin
    select banner into l_text 
      from v$version 
     where banner = 
     'Oracle10i Enterprise Edition Release 10.1.0.1.0 - Beta';
exception
    when no_data_found then
        raise_application_error(-20001,'You should be in the 10gR1 instance!');
end;
/
whenever sqlerror continue

/*
drop table wide;
create table wide ( x varchar2(4000), y varchar2(4000) );
insert into wide values ( rpad( 'a', 4000, 'a' ), rpad( 'b', 4000, 'b') );
commit;
*/
update wide set x = lower(x), y = lower(y);
commit;

column scn new_val start_scn;
select dbms_flashback.get_system_change_number scn from dual;
update wide set x = upper(x), y = upper(y);
commit;
column scn new_val stop_scn;
select dbms_flashback.get_system_change_number scn from dual;

column versions_xid new_val XID
select substr(x,1,1), substr(y,1,1),
       versions_operation,
       versions_xid
  from wide versions between scn &start_scn and &stop_scn
/
pause

select * 
  from flashback_transaction_query
 where xid = hextoraw( '&XID' )
/
