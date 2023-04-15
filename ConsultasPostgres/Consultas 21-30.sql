drop view listado;

create temporary view listado as
	select cod_e, nom_e, cod_a, nom_a, id_p, nom_p, cod_carr, nom_carr,
		coalesce(n1,0)*0.35+coalesce(n2,0)*0.35+coalesce(n3,0)*0.3 def
		from estudiantes natural join inscribe natural join asignaturas natural join carrera natural join profesores
		
select * from listado

create temporary view t_listado as
	select cod_e, nom_e, cod_a, nom_a, id_p, nom_p, cod_carr, nom_carr,
		coalesce(n1,0)*0.35+coalesce(n2,0)*0.35+coalesce(n3,0)*0.3 def
		from estudiantes natural join inscribe natural join asignaturas natural join carrera natural join profesores

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
---




--21. Liste los estudiantes que inscribieron menos de 3 asignaturas

drop view listado_2;

create temporary view listado_2 as	
	select nom_e, count (nom_a) no_asi_ins from listado group by nom_e

select nom_e, no_asi_ins from listado_2 where (no_asi_ins) >= 3 

--22. Quiénes tienen la nota más alta en Bases de Datos


select nom_e,def,nom_a from listado where nom_a ilike '%base%dato' order by def desc limit 1

--23. Cuáles asignaturas tienen la nota definitiva más baja

select nom_a,def from listado order by def

--24. Quienes tienen la nota más baja de todas, en qué asignatura y con cuál profesor

select nom_e, def, nom_a, nom_p from listado order by def limit 1

--25. Cuál es el libro que es referenciado por más asignaturas


drop view l_libros;

create temporary view l_libros as
	select titulo, count (nom_a) cuenta
		
		from libros natural join referencia natural join asignaturas group by titulo;

select * from l_libros

select titulo, cuenta from l_libros order by cuenta desc limit 1

--26. Quién es el estudiante que más libros diferentes ha sacado en préstamo

drop view l_estudiante;

create temporary view l_estudiante as
	select nom_e, count (cod_e) cuenta
		
		from estudiantes natural join presta group by nom_e;

select * from l_estudiante;

select nom_e, cuenta from l_estudiante order by cuenta desc limit 1


-- Corregida
with p_26 as
	(SELECT cod_e, count(distinct isbn) c from presta
		group by cod_e)
select cod_e, nom_e from p_26 natural join estudiantes
	where c = (select c from p_26 order by c desc limit 1);
	


--27. Cuál es el estudiante que perdió más asignaturas

drop view l_estudiante_2;

create temporary view l_estudiante_2 as	
	select nom_e, def, count (nom_a)no_asi_ins from listado where def <= 3 group by nom_e, def;
select * from l_estudiante_2;

drop view l_estudiante_3;

create temporary view l_estudiante_3 as	
select nom_e, count(nom_e) asig_perd from l_estudiante_2 group by nom_e;
select * from l_estudiante_3;

select * from l_estudiante_3 order by asig_perd desc limit 1

--28. Cuál es el profesor con el mayor porcentaje de pérdida por parte de sus estudiantes

select * from listado

drop view l_profesores_2;

create temporary view l_profesores_2 as	
select nom_p, def, count(nom_e) asig_perd from listado where def <= 3 group by nom_p,def;
select * from l_profesores_2;

drop view l_profesores_3;

create temporary view l_profesores_3 as	
select nom_p, count(asig_perd) asig_perd from l_profesores_2 group by nom_p;
select * from l_profesores_3;

select nom_p, avg(asig_perd),sum(asig_perd) from l_profesores_3 group by nom_p;

-- Corregido



--29. Cuál es la asignatura con mayor cantidad de estudiantes inscritos

drop view l_asignaturas;
create temporary view l_asignaturas as
select nom_a, count(nom_e) estu from listado group by nom_a;
select * from l_asignaturas;

select * from l_asignaturas order by estu desc limit 1;

--30. Nombre del autor referenciado por más asignaturas diferentes

select * from autores natural join escribe natural join libros natural join referencia natural join asignaturas;

drop view l_autores_1;
create temporary view l_autores_1 as
select distinct nom_autor,count(distinct nom_a)asi from autores natural join escribe natural join libros natural join referencia natural join asignaturas group by nom_autor;
select * from l_autores_1;

select * from l_autores_1 order by asi desc limit 1;