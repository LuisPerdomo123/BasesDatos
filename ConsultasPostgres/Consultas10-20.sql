select * from estudiantes where nom_e in ('Estudiante 2','Estudiante 1') -- Cumple con la lista de valores
select * from estudiantes where nom_e not in ('Estudiante 2','Estudiante 1'); -- No cumple con la lista de valores

create temporary view listado as
select * from estudiantes natural join inscribe

--11. Cuáles estudiantes de ingeniería de sistemas no inscribieron Bases de Datos (funciona)

select * from estudiantes

select * from carrera

select * from inscribe

select * from asignaturas

select distinct cod_e, nom_e from estudiantes natural join inscribe natural join asignaturas natural join carrera -- Primera solucion
	where nom_carr ilike '%ingenieria%sistemas'
except
(select distinct cod_e, nom_e from estudiantes natural join carrera natural join inscribe natural join asignaturas
	where nom_a ilike ('%base%dato'));

select cod_e, nom_e from estudiantes natural join carrera natural join inscribe -- Segunda solucion
	where nom_carr ilike '%ingenieria%sistemas'
except
select cod_e, nom_e from estudiantes natural join inscribe natural join asignaturas
	where nom_a ilike '%base%dato';

--12. Liste los estudiantes que no han devuelto libros prestados (funciona)

select distinct cod_e,nom_e from estudiantes
except
select distinct cod_e, nom_e from presta natural join estudiantes

--13. Que estudiantes inscribieron Bases de Datos e Ingeniería de Software (funciona), por revisar

select cod_e from estudiantes natural join inscribe natural join asignaturas
where nom_a ilike '%Base%Dato%'
intersect
select cod_e from estudiantes natural join inscribe natural join asignaturas
where nom_a ilike '%Ingeniería%Softwar%'

--14. Liste los libros que no han sido prestados y que son referenciados por asignaturas (parcial)


select distinct("isbn") from libros
except
select distinct("isbn") from libros natural join presta 
intersect
select distinct("isbn") from referencia


--15. Liste los profesores y sus asignaturas asignadas donde no tienen estudiantes inscritos

select distinct("id_p") from profesores natural join imparte natural join asignaturas
except
select distinct("id_p") from profesores natural join imparte natural join asignaturas natural join estudiantes

--16. Nombre de los estudiantes y asignatura de aquellos que pasaron el examen, pero que perdieron la asignatura



--17. Liste los estudiantes y las asignaturas que toman con su nota definitiva y el concepto de Aprobado o Reprobado según el caso de su definitiva
--18. Determine cuáles son los estudiantes que aprobaron todas las asignaturas que inscribieron
--19. Liste el nombre de los libros que no son referenciados por alguna asignatura y que han sido prestados

Select * from libros 
select * from referencia
select * from presta
select * from asignaturas
select * from inscribe

select * from libros natural join referencia where cod_a not in (select cod_a from asignaturas);

(select distinct titulo from libros natural join referencia -- Libros referenciados 
except
(select distinct titulo from asignaturas natural join inscribe natural join presta natural join referencia natural join libros)) order by titulo;


--20. Liste los libros y su respectiva asignatura que los referencia, de aquellos libros que no se han prestado