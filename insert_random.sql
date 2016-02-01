declare var_random number; 
begin
for i in 1 .. 50 loop 
select trunc(dbms_random.value(0,100)) into var_random from dual; 
insert into data(numerical) values(var_random); 
end loop; 
end;
/