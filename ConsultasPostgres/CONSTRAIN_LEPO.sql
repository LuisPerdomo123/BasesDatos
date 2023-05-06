create domain nat as
	int check(value >= 0) not null;

create table a (

	id_a nat primary key,
	aa nat);
	
create table b (

	id_b nat primary key,
	bb nat);

drop table c;
create table c (

	id_c nat primary key,
	cc nat,
	id_d int null check (id_d >=0) references d(id_d),
	rr2 nat);

create table d (

	id_d nat primary key,
	dd nat);

create table e (

	id_e nat primary key,
	ee nat);
	
--Solo las relaciones muchos a muchos

create table r1(

	id_a nat references a(id_a),
	id_b nat references b(id_b),
	rr1 nat,
	primary key (id_a,id_b,rR1));
	

create table r3(

	id_a nat,
	id_b nat,
	rr1 nat,
	id_c nat references c(id_c),
	
	primary key (id_a, id_b, rr1, id_c),
	foreign key (id_a, id_b, rr1) references r1(id_a, id_b, rr1)
);

create table r5(

	id_e nat references e(id_e),
	id_a nat,
	id_b nat,
	rr1 nat,
	id_c nat
	
	primary key (id_e, id_a, id_b, rr1, id_c),
	foreign key (id_a, id_b, rr1, id_c) references r3(id_a, id_b, rr1, id_c)
);

