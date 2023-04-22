--1. Liste los estudiantes que son menores de edad

select *, date_part('year', age(f_nac)) edad from estudiantes where date_part('year', age(f_nac)) < 23
select 'Los días que ha vivido Cristian son: '||((current_date - '1997-10-22')/365.25)::numeric(10,1)

--2. Si cada crédito se asocia a 16 horas en las 16 semanas de clase, liste las asignaturas que guardan esa proporción

select * from asignaturas where ih=cred;

--3. Liste las asignaturas que tienen más de 4 horas de intensidad horaria

select * from asignaturas where ih >4;

--4. Listado de estudiantes que no inscribieron materias

select cod_e,nom_e from estudiantes 
except
select cod_e,nom_e from inscribe natural join estudiantes

--

create table t_4 as 
with p_4 as
(select cod_e from estudiantes 
except
select cod_e from inscribe)
select cod_e, nom_e from p_4 natural join estudiantes

select * from t_4

--
select cod_e from inscribe group by cod_e
--
select distinct cod_e from inscribe
--

--5. Nombre de las asignaturas que imparte Alvaro Ortiz

select * from profesores natural join imparte 
where upper(nom_p) = 'PROFESOR 1'
--
select * from profesores natural join imparte 
where lower(nom_p) = 'profesor 1'

--6. Liste los libros que ha sacado en préstamo Pepito Pérez

select * from estudiantes natural join presta natural join libros
where nom_e ilike '%Estudiante 1%'

--7. Liste los profesores que imparten Bases de Datos

select * from profesores natural join imparte natural join asignaturas
where nom_a ilike '%Base%Dato%'

--8. Liste las asignaturas que toma el estudiante Pepito Pérez
select nom_a,cod_a,nom_e from asignaturas natural join estudiantes
where upper ("nom_e") = 'ESTUDIANTE 1'

--9. Liste los estudiantes que hayan perdido alguna asignatura en Ing. de Sistemas

select *, n1*0.35+n2*0.35+n3*0.3 from inscribe

--10. Liste las asignaturas donde no haya estudiantes que perdieron la materia

select * from estudiantes

select nom_a,cod_a,nom_e from asignaturas natural join estudiantes
where upper ("nom_e") = 'ESTUDIANTE 1'
