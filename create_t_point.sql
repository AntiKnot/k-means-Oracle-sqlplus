
create table point as select * from(select * from data order by dbms_random.random)
/
