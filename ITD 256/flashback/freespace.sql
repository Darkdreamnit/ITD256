set echo &1

select allocated_k, free_k, recycle_able_k
  from 
( select nvl(sum(bytes)/1024,0) free_k from dba_free_space 
   where tablespace_name = 'TEST_DROP'),
( select sum(bytes)/1024 allocated_k from dba_data_files 
   where tablespace_name = 'TEST_DROP'),
( select nvl(sum(space) * 8,0) recycle_able_k from dba_recyclebin
   where ts_name = 'TEST_DROP')
/
set echo on
