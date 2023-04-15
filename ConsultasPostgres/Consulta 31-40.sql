drop view listado;

create temporary view listado as
	select cod_e, nom_e, cod_a, nom_a, id_p, nom_p, cod_carr, nom_carr,
		coalesce(n1,0)*0.35+coalesce(n2,0)*0.35+coalesce(n3,0)*0.3 def
		from estudiantes natural join inscribe natural join asignaturas natural join carrera natural join profesores;
		
select * from listado

create temporary view t_listado as
	select cod_e, nom_e, cod_a, nom_a, id_p, nom_p, cod_carr, nom_carr,
		coalesce(n1,0)*0.35+coalesce(n2,0)*0.35+coalesce(n3,0)*0.3 def
		from estudiantes natural join inscribe natural join asignaturas natural join carrera natural join profesores;

select * from t_listado

select * from estudiantes
update estudiantes set nom_e='Estudiante 1' where nom_e = 'Alumno 1'
---

---
select distinct(nom_e) from listado --Presenta el nombre de estudiantes sin repetir el nombre

select count (*) from listado --Cuenta el número de filas de la lista

select * from estudiantes limit 3-- Limitar el número de filas en la consulta

select * from estudiantes where nom_e = 'Estudiante 1' --Añadir una condición de filas de una tabla

select * from listado order by def -- Ordenado por defecto forma ascendente

select * from listado order by def desc -- Ordenado de forma descendente

ALTER TABLE autores RENAME COLUMN nom_a TO nom_autor -- Cambio de nombre de columna autor

select cod_e, sum(n1) from inscribe group by cod_e having sum(n1)>3-- Incluir condiciones en operadores de agrupación

select nom_e, max(def) from listado group by nom_e; -- Toma el maximo valor en un grupo


---
select nom_e, date_part('year',age(f_nac)) from estudiantes;--Calculo de años del estudiante
---
select -- Calculo de percentiles
  percentile_cont(0.25) within group (order by def desc) as percentile_25,
  percentile_cont(0.50) within group (order by def desc) as percentile_50,
  percentile_cont(0.75) within group (order by def desc) as percentile_75,
  percentile_cont(0.95) within group (order by def desc) as percentile_95
from listado
---


--DESARROLLO DE CONSULTAS

--31. Cuál es el libro que más se presta, y que no es referenciado por asignaturas (Debe ser corregida)

select * from presta ;
select * from libros;

drop view l_libros_1;

create temporary view l_libros_1 as

select distinct isbn, count(isbn) list from presta group by isbn
except
select distinct isbn, count(isbn) list from referencia natural join asignaturas group by isbn;
select * from l_libros_1;

select * from l_libros_1 order by list desc limit 1;
select * from l_libros_1 natural join libros order by list desc limit 1;
select * from l_libros_1 natural join libros where list=(select max(list) from l_libros_1);


--

select isbn, count(isbn) list from presta 
where isbn not in (select distinct isbn from referencia) group by isbn;


--32. Nombre de los estudiantes que tienen el promedio de notas mayor a 4.0

drop view est_prom;
create temporary view est_prom as
select nom_e, avg(def) promedio from listado group by nom_e;
select * from est_prom;

select nom_e from est_prom where promedio >= 4; -- Primera forma


select nom_e, avg(def) from listado group by nom_e having avg(def) >= 4; -- Segunda forma (simplificado)

--33. Cuál es el estudiante que tiene el mejor promedio

select nom_e from est_prom order by promedio desc limit 1; -- Primera forma

select nom_e, avg(def) from listado group by nom_e order by avg(def) desc limit 1; -- Segunda forma (simplificado)


--34. Cuál es el libro que más veces se ha prestando

drop view listado_libros_3;
create temporary view listado_libros_3 as
select titulo, count(isbn) cantidad from presta natural join libros group by titulo;
select * from listado_libros_3;

select * from listado_libros_3 order by cantidad desc limit 1; -- Primera forma

select titulo, count(isbn) cantidad from presta natural join libros group by titulo order by count(isbn) desc limit 1; -- Segunda forma (simplificada)

--35. Nombre del estudiante que perdió más materias

drop view est_perd_asi;
create temporary view est_perd_asi as
select nom_e, def, count(nom_a) mat_perd from listado where def <= 3 group by nom_e,def;
select * from est_perd_asi;

select nom_e, count(mat_perd) from est_perd_asi group by nom_e order by count(mat_perd) desc limit 1;

--36. Título del libro con mayor cantidad de ejemplares

select * from libros;
select * from ejemplares;

select * from libros natural join ejemplares;

drop view titulo_ejemplares;
create temporary view titulo_ejemplares as
select titulo, count(isbn) ejem from libros natural join ejemplares group by titulo;
select * from titulo_ejemplares;

select * from titulo_ejemplares order by ejem desc limit 1;


--37. Cuáles son las asignaturas que referencian libros y no se ha prestado ninguno de ellos (Debe ser corregida)

drop view lib_ref_asig ;
create temporary view lib_ref_asig as
(select isbn, titulo from asignaturas natural join referencia natural join libros -- Libros referenciados por asignaturas y no prestados
except
(select distinct isbn, titulo from libros -- Libros que no han sido prestados
except
select distinct isbn, titulo from presta natural join libros));
select * from lib_ref_asig;

select nom_a, cod_a from referencia natural join lib_ref_asig natural join asignaturas;


--38. Cuál es el profesor que imparte más asignaturas diferentes

select * from listado;

drop view prof_mas_asi;
create temporary view prof_mas_asi as
select id_p, nom_p, count(distinct nom_a) mat_dic from listado group by id_p, nom_p;
select * from prof_mas_asi;

select * from prof_mas_asi order by mat_dic desc limit 1;

--39. Nombre de la asignatura con mayor diferencia de edad por parte de los estudiantes

drop view listado_est;

create temporary view listado_est as
	select cod_e, nom_e, f_nac, cod_a, nom_a, id_p, nom_p, cod_carr, nom_carr,
		coalesce(n1,0)*0.35+coalesce(n2,0)*0.35+coalesce(n3,0)*0.3 def
		from estudiantes natural join inscribe natural join asignaturas natural join carrera natural join profesores order by f_nac desc;
		
select * from listado_est;

select nom_a,(
	max(date_part('year',age(f_nac)))-min(date_part('year',age(f_nac)))) dif_ed
	from listado_est
	group by nom_a
	order by dif_ed desc
	limit 1

--40. Liste los estudiantes que pertenecen al grupo que tiene el mejor promedio de todos

drop view prueba;
create temporary view prueba as
select cod_e, nom_e, promedio, cod_a, nom_a from est_prom natural join estudiantes natural join inscribe natural join asignaturas order by promedio;
select * from prueba;

select cod_e, nom_e, promedio, cod_a, nom_a from est_prom natural join estudiantes natural join inscribe natural join asignaturas
where promedio > (select
  percentile_cont(0.25) within group (order by promedio desc) as percentile_25
  from est_prom);
