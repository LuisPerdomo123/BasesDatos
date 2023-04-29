drop view listado;

create temporary view listado as
	select cod_e, nom_e, cod_a, nom_a, id_p, nom_p, cod_carr, nom_carr,
		coalesce(n1,0)*0.35+coalesce(n2,0)*0.35+coalesce(n3,0)*0.3 def
		from estudiantes natural join inscribe natural join asignaturas natural join carrera natural join profesores;
		
select * from listado;

--

--41. Cuál es la asignatura cuyo porcentaje de pérdida de estudiantes es mayor
-- * Para esta consuta se requiere ejecutar la lista temporal listado

drop view l_asig_per; -- * Solo utilizar despues de creada la tabla
drop view l_asig_per_2; -- * Solo utilizar despues de creada la tabla

create temporary view l_asig_per as	
select nom_a, count(nom_e) asig_perd from listado where def < 3 group by nom_a;
select * from l_asig_per;


create temporary view l_asig_per_2 as	
select nom_a, asig_perd/(select sum(asig_perd) from l_asig_per )* 100 as porcentaje from l_asig_per ;
select * from l_asig_per_2 where porcentaje = (select max(porcentaje) from l_asig_per_2);


--42. Cuál es la carrera con el mayor porcentaje de estudiantes que pierden alguna asignatura
-- * Para esta consuta se requiere ejecutar la lista temporal listado

drop view l_carrera_per; -- * Solo utilizar despues de creada la tabla
drop view l_carrera_per_2; -- * Solo utilizar despues de creada la tabla

create temporary view l_carrera_per as	
select nom_carr, count(nom_e) carrerra_perd from listado where def < 3 group by nom_carr;
select * from l_carrera_per;

create temporary view l_carrera_per_2 as	
select nom_carr, carrerra_perd/(select sum(carrerra_perd) from l_carrera_per )* 100 as porcentaje from l_carrera_per ;
select * from l_carrera_per_2 where porcentaje = (select max(porcentaje) from l_carrera_per_2);


--43. Nombre de los estudiantes que perdieron asignaturas y no prestaron libros de esa asignatura
-- * Para esta consuta se requiere ejecutar la lista temporal listado

drop view l_est_per; -- * Solo utilizar despues de creada la tabla

create temporary view l_est_per as	
select nom_e, count(nom_e) est_perd from listado where def < 3 group by nom_e;
select * from l_est_per;

select nom_e from l_est_per
except
select distinct nom_e from presta natural join estudiantes;

--45. Cuantas asignaturas toma en promedio un estudiante que pierde alguna asignatura, y cuantas los que no perdieron alguna asignatura
-- * Para esta consuta se requiere ejecutar la lista temporal listado

drop view l_asig_prom; -- * Solo utilizar despues de creada la tabla
drop view l_asig_prom_a; -- * Solo utilizar despues de creada la tabla

create temporary view l_asig_prom as	
select nom_e, count(nom_a) asig_perd from listado where def < 3 group by nom_e;
select distinct nom_e, asig_perd from l_asig_prom;

select avg(asig_perd) as prom_asig_perd from l_asig_prom; 

create temporary view l_asig_prom_a as
select nom_e, asig_perd, count(nom_a) total_asig from l_asig_prom natural join listado group by nom_e, asig_perd;

select avg(total_asig) as prom_asig_perd from l_asig_prom_a; -- * Esta presenta la respuesta: Cuantas asignaturas toma en promedio un estudiante que pierde alguna asignatura 


drop view l_asig_prom_2; -- * Solo utilizar despues de creada la tabla
drop view l_asig_prom_2_a; -- * Solo utilizar despues de creada la tabla
drop view l_asig_prom_2_b; -- * Solo utilizar despues de creada la tabla

create temporary view l_asig_prom_2 as	
select nom_e, count(nom_a) asig_perd from listado where def >= 3 group by nom_e;
select distinct nom_e, asig_perd from l_asig_prom_2;

select avg(asig_perd) as prom_asig_perd from l_asig_prom_2; 

create temporary view l_asig_prom_2_a as
select nom_e, asig_perd, count(nom_a) total_asig from l_asig_prom_2 natural join listado group by nom_e, asig_perd;

create temporary view l_asig_prom_2_b as
select nom_e, total_asig from l_asig_prom_2_a except select nom_e, total_asig from l_asig_prom_a;

select avg(total_asig) as prom_asig_pasan from l_asig_prom_2_b; -- * Esta presenta la respuesta: Cuantas asignaturas toma en promedio un estudiante que no perdieron alguna asignatura

--47. Cuál es la carrera con mayor porcentaje de éxito (asignaturas que pasa respecto a las asignaturas que pierde), por parte de todos sus estudiantes
-- * Para esta consuta se requiere ejecutar la lista temporal listado

drop view l_carrera_exito; -- * Solo utilizar despues de creada la tabla
drop view l_total_asig_carrera; -- * Solo utilizar despues de creada la tabla
drop view l_total_asig_carrera_2; -- * Solo utilizar despues de creada la tabla

create temporary view l_carrera_exito as	
select nom_carr, count(nom_a) carrerra_ext from listado where def >= 3 group by nom_carr;
select * from l_carrera_exito;

create temporary view l_total_asig_carrera as
select nom_carr, count(nom_a) total_asig from l_carrera_exito natural join listado group by nom_carr;

create temporary view l_total_asig_carrera_2 as
select nom_carr, total_asig, carrerra_ext from l_total_asig_carrera natural join l_carrera_exito order by carrerra_ext;

with l_total_asig_carrera_3 as (select nom_carr,avg(carrerra_ext) promedio_fracaso from l_total_asig_carrera_2 group by nom_carr) -- Presenta la solucion al problema
select * from l_total_asig_carrera_3 where promedio_fracaso = (select max (promedio_fracaso) from l_total_asig_carrera_3);


