drop database if exists biblioteca;
create database biblioteca;
use biblioteca;

create table if not exists libro(
id_libro int unsigned not null,
editorial varchar(20) not null,
idioma varchar(30) not null,
titulo varchar(100) not null,
isbn varchar(15) not null,
numero_de_paginas smallint);

create table if not exists prestamo(
id_prestamo int unsigned not null,
id_libro int unsigned not null,
id_lector int unsigned not null,
fecha_prestamo date not null,
fecha_devolucion date,
estado_del_prestamo varchar(40) not null,
id_bibliotecario int unsigned not null);

create table lector(
id_lector int unsigned not null,
nombre varchar(100) not null,
correo_electronico varchar(50),
telefono bigint unsigned not null);

create table if not exists libro_x_autor(
id_libro int unsigned not null,
id_autor int unsigned not null);

create table if not exists autor(
id_autor int unsigned not null,
pais_nac varchar(50) not null,
nombre varchar(100) not null unique);

alter table autor add constraint pk_id_autor primary key (id_autor);

alter table libro_x_autor add constraint fk_id_autor foreign key (id_autor) references autor(id_autor) on delete cascade;

alter table lector add constraint pk_id_lector primary key (id_lector);

alter table prestamo add constraint pk_id_prestamo primary key (id_prestamo);

alter table prestamo add constraint fk_id_lector foreign key (id_lector) references lector(id_lector) on delete cascade;

alter table libro add constraint pk_id_libro primary key (id_libro);

alter table prestamo add constraint fk_id_libro foreign key (id_libro) references libro(id_libro) on delete cascade;

alter table libro_x_autor add constraint fk_id_libro2 foreign key (id_libro) references libro(id_libro) on delete cascade;

alter table libro_x_autor add constraint primary key (id_libro, id_autor);

insert into autor values(1, 'Colombia','Gabriel García Márquez'),(2,'Gran Bretaña','Aldous Huxley'),
(3,'Irlanda','James Joyce'),(4,'India','George Orwell'),(5,'Suecia','Åsa Larsson');

insert into libro values(1,'Islas','Español','Cien años de soledad', 
'j5s4ex69qbx', 512),(2,'Montoya','Español', 'Un mundo feliz','s5aqe249ql9', 255),
(3,'Panini','Inglés', 'Ulises', 'asd445qq812', 1000),
(4,'Penguin ','Inglés', '1984', 'nam445qq812', 352),
(5,'Seix Barral','Sueco', 'Sacrificio a Mólek', 'but445qq812', 414),
(6,'Reverté','?', 'CÁLCULO INFINITESIMAL', 'ñam445qq812', 927);

insert into libro_x_autor values(1,1),(2,2),(3,3);
insert into lector values(1, 'Ricardo Silva', null, 5531310066),(2, 'Silvia González', 'Silvia@gmail.com',5678143366),(3, 'Gonzalo Sánchez', 'gonza@outlook.com', 5511364788);
insert into prestamo values(1,3,2, '2022-01-19', null, 'Retrasado',1),(2,2,1,'2022-10-20', '2022-10-24', 'Entregado',1),(3,1,3,'2022-10-20', '2022-10-22', 'Entregado con Daños',1);

insert into libro_x_autor values(1,2),(1,3), (2,1), (3,1);