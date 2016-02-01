
declare 
v_cnt_k number; 
v_cnt_kk number; 
v_count number:=0; 
v_cnt_data number; 
v_cnt_point number;
change number:=1; 
distance number; 
temp number; 

TYPE t_data is table of data%ROWTYPE INDEX BY BINARY_INTEGER; 
v_arry_data t_data; 
TYPE t_point IS TABLE OF point%ROWTYPE INDEX BY BINARY_INTEGER; 
v_arry_point t_point;
v_sum number:=0; 
v_cnt number:=0; 
v_average number; 
BEGIN
v_cnt_k:=&1; 
v_cnt_kk:=v_cnt_k + 1; 
SELECT * BULK COLLECT INTO v_arry_data FROM  data;
v_cnt_data:=v_arry_data.count; 
if v_cnt_k<1 then
change:=0;
dbms_output.put_line('error: The number of point should more than 1');
end if;
if v_cnt_k>v_cnt_data then 
change:=0;
dbms_output.put_line('error: The number of point shoule less than data'); 
end if;
if v_cnt_k>0 and v_cnt_k<v_cnt_data then 


SELECT * BULK COLLECT INTO v_arry_point FROM point where rownum<v_cnt_kk; 
v_cnt_point:=v_arry_point.count;
end if;

WHILE change=1 loop 
	dbms_output.put_line('begin handle');
for i in 1..v_cnt_point loop 
	dbms_output.put_line(v_arry_point(i).numerical||':'||v_arry_point(i).k_class); 
end loop; 
for i in 1..v_cnt_data loop 
	dbms_output.put_line(v_arry_data(i).numerical||':'||v_arry_data(i).k_class); 
end loop; 
change:=0; 

for i in 1..v_cnt_point loop 
	v_arry_point(i).k_class:=i; 
end loop; 

for j in 1..v_cnt_data loop
	v_arry_data(j).k_class:=1;
	temp:=v_arry_data(j).numerical - v_arry_point(1).numerical; 
	select abs(temp) into temp from dual; 
	for i in 1..v_cnt_point loop
		distance:=v_arry_data(j).numerical - v_arry_point(i).numerical;
		select abs(distance) into distance from dual; 
		if distance<temp then  
			temp:=distance; 
			v_arry_data(j).k_class:=v_arry_point(i).k_class; 
			end if; 
		end loop; 
end loop; 

for i in 1..v_cnt_point loop 
	for j in 1..v_cnt_data loop 
		if v_arry_data(j).k_class=i then 
			v_sum:=v_sum + v_arry_data(j).numerical; 
			v_cnt:=v_cnt+1; 
		end if; 
	end loop; 
	v_average:=v_sum/v_cnt; 
	begin 
	select ceil(v_average) into v_average from dual;
	end;
	if 	v_arry_point(i).numerical<>v_average then 
		v_arry_point(i).numerical:=v_average; 
		change:=1;
	end if; 
	v_sum:=0; 
	v_cnt:=0; 
end loop; 
end loop;
for i in 1..v_cnt_data loop
	insert into t_result(numerical,k_class) values(v_arry_data(i).numerical,v_arry_data(i).k_class);
end loop;
end;
/