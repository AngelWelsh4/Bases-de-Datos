drop database if exists hostal;
create database if not exists hostal;
use hostal

create table modo_pago
(
id_modo_pago int primary key,
modo_pago varchar(50)
);


create table tipo_habitacion
(
id_tipo_habitacion int primary key,
tipo varchar(50)
);

create table marca
(
id_marca int primary key,
nombre varchar(50)
);

create table tipo_bebidas
(
id_tipo_bebidas int primary key,
nombre varchar(50)
);

create table tipo_marca
(
id_tipo_marca int primary key,
nombre varchar(50),
precio int,
id_marca int,
id_tipo_bebidas int,
constraint fk_id_marca foreign key (id_marca) references marca (id_marca),
constraint fk_id_tipo_bebidas1 foreign key (id_tipo_bebidas) references tipo_bebidas (id_tipo_bebidas)
);

create table minibar
(
id_minibar int primary key,
nombre varchar(50),
telefono varchar(50)
);

create table mini_restaurante 
(
id_mini_restaurante int primary key,
nombre varchar(50),
telefono varchar(50)
);

create table bebidas
(
id_bebidas int primary key,
id_marca int,
id_minibar int,
constraint fk_id_marca1 foreign key (id_marca) references marca(id_marca),
constraint fk_id_minibar foreign key (id_minibar) references minibar (id_minibar)
);

create table hotel
(
id_hotel int primary key,
nombre varchar(50),
direccion varchar(50),
telefono varchar(50),
id_minibar int,
id_mini_restaurante int,
constraint fk_id_minibar2 foreign key (id_minibar) references minibar (id_minibar),
constraint fk_id_mini_restaurante foreign key (id_mini_restaurante) references mini_restaurante (id_mini_restaurante)
);

create table tipo_empleado
(
id_tipo_empleado int primary key,
cargo varchar(50),
salario int
);

create table empleado
(
id_empleado int primary key,
nombre varchar(50),
apellido varchar(50),
edad varchar(50),
sexo char(50),
telefono varchar(50),
direccion varchar(50),
tarjeta_identidad varchar(50),
turno varchar(50),
id_hotel int,
id_tipo_empleado int,
constraint fk_id_hotel foreign key (id_hotel) references hotel(id_hotel),
constraint fk_id_tipo_empleado foreign key (id_tipo_empleado) references tipo_empleado (id_tipo_empleado)
);

create table cliente
(
id_cliente int primary key,
nombre varchar(50),
apellido varchar(50),
telefono varchar(50),
tarjeta_identidad varchar(50),
direccion varchar (50),
id_modo_pago int,
id_empleado int,
constraint fk_id_empleado foreign key (id_empleado) references empleado (id_empleado),
constraint fk_id_modo_pago2 foreign key (id_modo_pago) references modo_pago (id_modo_pago)
);

create table estancia
(
id_estancia int primary key,
fecha_entrada date,
fecha_salida date,
id_modo_pago int,
id_cliente int,
constraint fk_id_modo_pago foreign key(id_modo_pago) references  modo_pago (id_modo_pago), 
constraint fk_id_cliente foreign key(id_cliente) references  cliente (id_cliente)
);

create table habitacion
(
id_habitacion int primary key,
numero_habitacion varchar(50),
id_hotel int,
id_tipo_habitacion int,
constraint fk_id_hotel1 foreign key (id_hotel) references hotel (id_hotel),
constraint fk_id_tipo_habitacion foreign key (id_tipo_habitacion) references tipo_habitacion (id_tipo_habitacion)
);

create table cliente_habitacion
(
id_cliente_habitacion int primary key,
id_cliente int,
id_habitacion int,
constraint fk_id_cliente2  foreign key (id_cliente ) references cliente (id_cliente),
constraint fk_id_habitacion  foreign key (id_habitacion) references habitacion (id_habitacion)
);

create table mapa_ubicacion
(
id_mapa_ubicacion int primary key,
nombre_cliente varchar(50),
capital varchar (50),
departamento varchar(50),
pais varchar(50),
longitud real not null,
latitud real not null,
visitas int
);

use hostal

-- llenado de la tabla modo_pago
insert into modo_pago values(101,'tarjeta');
insert into modo_pago values(202,'efectivo');
insert into modo_pago values(303,'cheques');


-- llenado de la tabla tipo habitacion
insert into tipo_habitacion values (1,'habitacion individual');
insert into tipo_habitacion values (2,'habitacion doble');
insert into tipo_habitacion values (3,'habitacion triple');
insert into tipo_habitacion values (4,'junior suites');
insert into tipo_habitacion values (5,'suites presidencial');


-- llenado de la tabla marca
insert into marca values (1,'coca cola');
insert into marca values (2,'pepsi');
insert into marca values (3,'sula');
insert into marca values (4,'miller');
insert into marca values (5,'coors ligth');
insert into marca values (6,'red bull');
insert into marca values (7,'dasani');
insert into marca values (8,'monster');
insert into marca values (9,'big cola');
insert into marca values (10,'herneiker');
insert into marca values (11,'four loko');
insert into marca values (12,'dr pepper');
insert into marca values (13,'absolut vodka');
insert into marca values (14,'bacardi');
insert into marca values (15,'agua azul');
insert into marca values (16,'marinero');
insert into marca values (17,'royal');
insert into marca values (18,'pop coca');
insert into marca values (19,'izze');
insert into marca values (20,'coke');
insert into marca values (21,'malta goya');
insert into marca values (22,'raptor');
insert into marca values (23,'inka cola');
insert into marca values (24,'jone');
insert into marca values (25,'blue sky');
insert into marca values (26,'koles');
insert into marca values (27,'angry birds');
insert into marca values (28,'bargs');
insert into marca values (29,'link');
insert into marca values (30,'enjoy');
insert into marca values (31,'jolly bancher');
insert into marca values (32,'crush');
insert into marca values (33,'tampico');
insert into marca values (34,'del valle');
insert into marca values (35,'power');
insert into marca values (36,'gatorade');
insert into marca values (37,'citric');
insert into marca values (38,'quanty');
insert into marca values (39,'pulp');
insert into marca values (40,'twuist');
insert into marca values (41,'lipton');
insert into marca values (42,'aquafina');
insert into marca values (43,'fruta fresca');
insert into marca values (44,'volt');
insert into marca values (45,'link');
insert into marca values (46,'maltin');
insert into marca values (47,'naturas');
insert into marca values (48,'montan dew');
insert into marca values (49,'california');
insert into marca values (50,'nestea');

-- llenado de la tabla tipo_bebidas
insert into tipo_bebidas values (111,'soda');
insert into tipo_bebidas values (222,'energizante');
insert into tipo_bebidas values (333,'agua');
insert into tipo_bebidas values (444,'te');
insert into tipo_bebidas values (555,'jugo');
insert into tipo_bebidas values (666,'leche');
insert into tipo_bebidas values (777,'cerveza');
insert into tipo_bebidas values (888,'licor');

-- llenado de la tabla tipo_marca
insert into tipo_marca values (1,'sprit 10 onz',15,1,111);
insert into tipo_marca values (2,'7up 10 onz',13,2,111);
insert into tipo_marca values (3,'malteada vainilla',15,3,666);
insert into tipo_marca values (4,'miller full 450 ml',35,4,777);
insert into tipo_marca values (5,'coors big',32,5,777);
insert into tipo_marca values (6,'red bull refresh 150 ml',140,6,222);
insert into tipo_marca values (7,'dasani 300 ml',18,7,333);
insert into tipo_marca values (8,'monster int 350 ml',28,8,222);
insert into tipo_marca values (9,'big green 350 ml',10,9,111);
insert into tipo_marca values (10,'herneiker 150 ml',45,10,777);
insert into tipo_marca values (11,'four orange 20 ml',28,11,222);
insert into tipo_marca values (12,'dr pepper glass 250 ml',22,12,111);
insert into tipo_marca values (13,'vodka blue 350 ml',350,13,888);
insert into tipo_marca values (14,'bacardi coffe 350 ml',340,14,888);
insert into tipo_marca values (15,'agua azul 500 ml',17,15,333);
insert into tipo_marca values (16,'marinero tomate 125 ml',65,16,555);
insert into tipo_marca values (17,'royal pc 250 ml',36,17,444);
insert into tipo_marca values (18,'pop light 550 ml',22,18,111);
insert into tipo_marca values (19,'izze lemon 350 ml',18,19,444);
insert into tipo_marca values (20,'coke dieta 250 ml',16,20,111);
insert into tipo_marca values (21,'malta 330 ml',10,21,222);
insert into tipo_marca values (22,'raptor 600 ml',35,22,222);
insert into tipo_marca values (23,'inca banana 300 ml',18,23,111);
insert into tipo_marca values (24,'jone 800 ml',480,24,777);
insert into tipo_marca values (25,'blue red 350 ml',45,25,777);
insert into tipo_marca values (26,'koles 18 ml',18,26,555);
insert into tipo_marca values (27,'angry blue 250 ml',10,27,555);
insert into tipo_marca values (28,'bargs 250 ml',15,28,333);
insert into tipo_marca values (29,'link manadrina 300 ml',15,29,111);
insert into tipo_marca values (30,'enjoy ponche 350 ml',18,30,555);
insert into tipo_marca values (31,'bancher 450 ml',350,31,777);
insert into tipo_marca values (32,'activ crush 180 ml',25,32,222);
insert into tipo_marca values (33,'tampico naranja 500 ml',10,33,555);
insert into tipo_marca values (34,'valle mandarina 300 ml',10,34,555);
insert into tipo_marca values (35,'power 350 ml',25,35,222);
insert into tipo_marca values (36,'gatorade 800 ml',25,36,222);
insert into tipo_marca values (37,'citric lemon 300 ml',25,37,555);
insert into tipo_marca values (38,'quanty frutas 350 ml',22,38,555);
insert into tipo_marca values (39,'pulp naranja 350 ml',20,39,555);
insert into tipo_marca values (40,'twuist lemon y fresa 350 ml',18,40,444);
insert into tipo_marca values (41,'lipton lemon 350 ml',19,41,444);
insert into tipo_marca values (42,'aquafina 450 ml', 18,42,333);
insert into tipo_marca values (43,'fresca piña 350 ml',13,43,555);
insert into tipo_marca values (44,'volt 350 ml',10,44,222);
insert into tipo_marca values (45,'link durazno 350 ml',18,45,555);
insert into tipo_marca values (46,'maltin vainilla 250 ml',15,46,666);
insert into tipo_marca values (47,'naturas manzana 180 ml',10,47,555);
insert into tipo_marca values (48,'montan dew 45 ml',11,48,222);
insert into tipo_marca values (49,'california kiwi 800 ml',19,49,555);
insert into tipo_marca values (50,'nestea lemon 450 ml',18,50,444);

-- llenado de la tabla minibar
insert into minibar values (1,'miniginz','22382035');


-- llenado de la tabla mini_restaurante
insert into mini_restaurante values (255,'resta_ginz','22382036');

-- llenado de la tabla bebidas
insert into bebidas values (1,1,1);
insert into bebidas values (2,2,1);
insert into bebidas values (3,3,1);
insert into bebidas values (4,4,1);
insert into bebidas values (5,5,1);
insert into bebidas values (6,6,1);
insert into bebidas values (7,7,1);
insert into bebidas values (8,8,1);
insert into bebidas values (9,9,1);
insert into bebidas values (10,10,1);
insert into bebidas values (11,11,1);
insert into bebidas values (12,12,1);
insert into bebidas values (13,13,1);
insert into bebidas values (14,14,1);
insert into bebidas values (15,15,1);
insert into bebidas values (16,16,1);
insert into bebidas values (17,17,1);
insert into bebidas values (18,18,1);
insert into bebidas values (19,19,1);
insert into bebidas values (20,20,1);
insert into bebidas values (21,21,1);
insert into bebidas values (22,22,1);
insert into bebidas values (23,23,1);
insert into bebidas values (24,24,1);
insert into bebidas values (25,25,1);
insert into bebidas values (26,26,1);
insert into bebidas values (27,27,1);
insert into bebidas values (28,28,1);
insert into bebidas values (29,29,1);
insert into bebidas values (30,30,1);
insert into bebidas values (31,31,1);
insert into bebidas values (32,32,1);
insert into bebidas values (33,33,1);
insert into bebidas values (34,34,1);
insert into bebidas values (35,35,1);
insert into bebidas values (36,36,1);
insert into bebidas values (37,37,1);
insert into bebidas values (38,38,1);
insert into bebidas values (39,39,1);
insert into bebidas values (40,40,1);
insert into bebidas values (41,41,1);
insert into bebidas values (42,42,1);
insert into bebidas values (43,43,1);
insert into bebidas values (44,44,1);
insert into bebidas values (45,45,1);
insert into bebidas values (46,46,1);
insert into bebidas values (47,47,1);
insert into bebidas values (48,48,1);
insert into bebidas values (49,49,1);
insert into bebidas values (50,50,1);

-- llenado de la tabla hotel
insert into hotel values (1,'ginzda','calle morelos 7ma y 8va avenida','22382035',1,255); 

-- llenado de la tabla tipo_empleado
insert into tipo_empleado values (1,'recepcionista',12000);
insert into tipo_empleado values (2,'botones',11000);
insert into tipo_empleado values (3,'limpieza',13000);
insert into tipo_empleado values (4,'seguridad',9000);
insert into tipo_empleado values (5,'chef',15000);
insert into tipo_empleado values (6,'meseros',8000);
insert into tipo_empleado values (7,'bartender',10000);

-- llenado de la tabla empleado
insert into empleado values (1,'jose','linares','58','m','98563254','el picacho','0801-1236-96523','matutino',1,1);
insert into empleado values (2,'gustavo','andino','25','m','33659863','trapiche','0801-2365-96533','matutino',1,1);
insert into empleado values (3,'maria','rivera','35','f','96526655','miraflores','0601-1362-98655','vespertino',1,1);
insert into empleado values (4,'jesus','villalta','85','f','33223322','protrerillos','0801-0123-12544','nocturno',1,1);
insert into empleado values (5,'david','medina','45','m','96999985','choluteca','0801-1256-11125','matutino',1,2);
insert into empleado values (6,'martha','salgado','40','f','98578596','choloma','0801-1236-11452','matutino',1,2);
insert into empleado values (7,'fanny','lopez','23','f','33256988','altamira','0801-1236-88955','vespertino',1,2);
insert into empleado values (8,'jimena','maradiaga','53','f','96528899','palmira','0801-1995-12596','vespertino',1,2);
insert into empleado values (9,'ermelindo','padilla','36','m','99885599','comayagua','0801-1562-19566','nocturno',1,2);
insert into empleado values (10,'aleman','pineda','23','m','96200012','tegucigalpa','0601-1356-12563','nocturno',1,2);
insert into empleado values (11,'marco','peralta','15','m','96256310','villa franca','0801-1658-96322','vespertino',1,2);
insert into empleado values (12,'claudia','zoriano','69','f','96525566','quesada','0801-2569-89652','vespertino',1,2);
insert into empleado values (13,'camila','zepeda','63','f','98784414','quesada','0801-1985-96320','matutino',1,2);
insert into empleado values (14,'alejandra','coello','19','f','99632000','bo centro','0801-1972-07482','matutino',1,3);
insert into empleado values (15,'fernando','lanza','65','m','96524488','miraflores','0801-1966-58963','matutino',1,3);
insert into empleado values (16,'oneyda','medina','52','f','33225566','torocagua','0801-2365-96322','vespertino',1,3);
insert into empleado values (17,'patricia','rivera','63','f','96589012','monte redondo','0801-198512365','vespertino',1,3);
insert into empleado values (18,'max','galeano','36','m','96336699','reparto','0801-1956-12541','nocturno',1,3);
insert into empleado values (19,'manuel','navarro','35','m','33559966','villa cristina','0601-1965-85632','nocturno',1,3);
insert into empleado values (20,'emerita','hernandez','45','f','33226655','palmira','0801-1965-12365','vespertino',1,3);
insert into empleado values (21,'astri','lagos','25','f','22563985','olancho','0801-1996-26354','nocturno',1,3);
insert into empleado values (22,'daniel','portillo','56','m','96356985','reparto','0801-1256-11122','matutino',1,4);
insert into empleado values (23,'vannesa','osorto','25','f','98512365','brisas de olancho','0801-1236-14523','matutino',1,4);
insert into empleado values (24,'jimi','rosales','32','m','33225698','pedregal','0601-1632-85693','matutino',1,4);
insert into empleado values (25,'jorge','canizales','21','m','96532145','picachito','0801-1965-89653','vespertino',1,4);
insert into empleado values (26,'rosa','contreras','56','f','98563210','cerro grende','0801-8965-96325','nocturno',1,4);
insert into empleado values (27,'elmer','padilla','23','m','96582365','las flores','0801-1236-98564','nocturno',1,4);
insert into empleado values (28,'vilma','cruz','53','f','96523366','las flores','0601-8523-12548','matutino',1,4);
insert into empleado values (29,'reynieri','berrios','25','m','33665536','las acasias','0801-2365-96356','matutino',1,5);
insert into empleado values (30,'manuel','gutierres','19','m','96356985','las casitas','0601-1658-89652','matutino',1,5);
insert into empleado values (31,'santos','hernandes','36','m','96587458','las flores','0801-8965-89523','vespertino',1,5);
insert into empleado values (32,'olga','menguivar','65','f','96587421','cerro grande','0601-1569-14587','vespertino',1,5);
insert into empleado values (33,'perla','lagos','19','f','96522233','villa cristina','0801-4569-89563','nocturno',1,5);
insert into empleado values (34,'juan','garcia','54','m','96587421','catacamas','0801-1965-45875','nocturno',1,5);
insert into empleado values (35,'cristian','godoy','22','m','96320011','las cruictas','0801-1985-96566','matutino',1,6);
insert into empleado values (36,'raul','avila','63','m','96585555','el chile','0601-1856-89654','vespertino',1,6);
insert into empleado values (37,'stefany','canales','23','f','33225566','quesada','0601-1256-12540','matutino',1,6);
insert into empleado values (38,'yaky','umanzor','22','f','22336699','guamilito','0801-1985-12563','matutino',1,6);
insert into empleado values (39,'melissa','zavala','36','f','33669985','danli','0801-1965-89563','vespertino',1,6);
insert into empleado values (40,'jessi','galdames','33','f','96552200','pedregal','0801-1856-89658','vespertino',1,6);
insert into empleado values (41,'anguie','osorio','18','f','33665896','guamilito','0801-7853-89655','nocturno',1,6);
insert into empleado values (42,'silvia','gonzales','33','f','33665530','calle real','0601-8965-85698','nocturno',1,6);
insert into empleado values (43,'andres','angeles','28','m','32633542','reparto','0801-1205-89654','matutino',1,7);
insert into empleado values (44,'maria','ucles','36','f','96532310','san pedro','0801-8965-88896','matutino',1,7);
insert into empleado values (45,'jessica','velasquez','20','f','98704730','torocagua','0601-1563-89563','matutino',1,7);
insert into empleado values (46,'moises','caballero','19','m','33665522','mercedes','0801-8965-85210','vespertino',1,7);
insert into empleado values (47,'fredy','salgado','25','m','96589632','rio hondo','0801-1698-89652','vespertino',1,7);
insert into empleado values (48,'fabiola','mendoza','21','f','33221025','amarateca','0601-9856-98563','nocturno',1,7);
insert into empleado values (49,'belkis','berrios','56','f','33226655','agalteca','0801-8965-87452','nocturno',1,7);
insert into empleado values (50,'crolina','ponce','30','f','33445269','villa campesina','0801-1256-96589','nocturno',1,7);


-- llenado de la tabla cliente
insert into cliente values (1,'mario','casas','96356985','0801-1998-25639','comayagua',101,1);
insert into cliente values (2,'sindy','lopez','33658962','0801-1845-03625','tegucigalpa',101,2);
insert into cliente values (3,'nanci','ramirez','33269865','0601-1956-25369','valle',202,3);
insert into cliente values (4,'alex','medina','96528697','0801-1991-05021','choloma',202,4);
insert into cliente values (5,'katherine','garcia','33201546','0612-1896-25369','tegucigalpa',202,5);
insert into cliente values (6,'camila','cortes','98969299','0801-1996-01526','valle',303,6);
insert into cliente values (7,'samuel','medina','33447070','0801-1999-15263','choluteca',303,7);
insert into cliente values (8,'rosa','alvares','96959897','0801-2001-15263','choloma',202,8);
insert into cliente values (9,'berta','caceres','96352610','0601-2563-96589','gracias a dios',202,9);
insert into cliente values (10,'adan','medina','97130160','0801-1972-07482','valle de angeles',303,10);
insert into cliente values (11,'brenda','fuentes','96515236','0601-2563-89652','las flores',101,11);
insert into cliente values (12,'ana','lagos','96523130','0801-1999-06050','las flores',101,12);
insert into cliente values (13,'junior','lopez','33447856','0801-1972-07482','talanga',202,13);
insert into cliente values (14,'frank','gomez','96447875','0801-1256-36985','la esperanza',303,14);
insert into cliente values (15,'daniela','gonzalez','33698523','0801-1963-15698','santa cruz',202,15);
insert into cliente values (16,'suyapa','rivera','96523610','0801-1236-12589','san andres',101,16);
insert into cliente values (17,'maria','portillo','98517305','0801-4589-15632','marcala',202,17);
insert into cliente values (18,'viviana','gomez','96215479','0801-1996-15963','lempira',303,18);
insert into cliente values (19,'luis','cruz','33445696','0801-1998-12563','jesus de otoro',101,19);
insert into cliente values (20,'jose','rivera','98563214','0601-1956-15632','germania',303,20);
insert into cliente values (21,'celeste','medina','31706730','0601-1958-15963','intibuca',202,21);
insert into cliente values (22,'alejandro','fuentes','99478563','0801-1999-15987','san pedro',303,22);
insert into cliente values (23,'roger','cruz','31758962','0801-1995-06253','santa rosa de copan',202,23);
insert into cliente values (24,'fernado','alvarez','97301258','0801-1994-05263','tela',303,24);
insert into cliente values (25,'melvin','alvarez','99856623','0601-1975-45632','la ceiba',101,25);
insert into cliente values (26,'marco','sanauria','33259687','0801-1996-25896','danli',202,26);
insert into cliente values (27,'isabel','manzanares','31758695','0801-1596-19625','trujillo',303,27);
insert into cliente values (28,'katy','andrade','98757544','0801-1985-12356','santa ana',101,28);
insert into cliente values (29,'josue','padilla','33698523','0801-2002-12396','siguatepeque',202,29);
insert into cliente values (30,'nicol','figueroa','99586321','0601-1995-15952','azacualpa',101,30);
insert into cliente values (31,'evenor','reyes','95969999','0801-1975-96322','lamani',303,31);
insert into cliente values (32,'danna','lopez','99029998','0801-1999-20156','ajuterique',101,32);
insert into cliente values (33,'alma','garcia','96859656','0801-1989-06050','el progreso',202,33);
insert into cliente values (34,'fredy','rivera','33256985','0801-1596-12587','yoro',101,34);
insert into cliente values (35,'daniela','rivera','96589658','0801-1972-12033','catacamas',303,35);
insert into cliente values (36,'genesis','ferrera','89408962','0801-1999-06053','la union',101,36);
insert into cliente values (37,'andrea','castro','96320122','0801-1975-88999','la lima',202,37);
insert into cliente values (38,'daniela','zuniga','33259687','0801-1596-88555','puerto cortes',303,38);
insert into cliente values (39,'elena','zelaya','96996632','0801-1965-15999','omoa',101,39);
insert into cliente values (40,'mileny','flores','96555566','0801-19998-15844','pespire',202,40);
insert into cliente values (41,'nicol','zelaya','22382035','0801-1963-11125','sabanagrande',101,41);
insert into cliente values (42,'jorge','amaya','22369568','0601-1965-12366','ojona',202,42);
insert into cliente values (43,'maria','gonzales','33695236','0801-1256-12547','san lorenzo',202,43);
insert into cliente values (44,'alex','medina','31452635','0801-1963-15800','monjaras',303,44);
insert into cliente values (45,'dulce','mejia','98034730','0801-2012-06322','el triunfo',303,45);
insert into cliente values (46,'marina','mondragon','96663322','0801-1563-12566','tatumbla',101,46);
insert into cliente values (47,'rebeca','lopez','95999998','0601-1996-15988','pespire',202,47);
insert into cliente values (48,'cindy','flores','22365896','0801-1956-12547','catacamas',202,48);
insert into cliente values (49,'evelyn','morazan','22383832','0801-1923-96533','choluteca',101,49);
insert into cliente values (50,'mario','canizales','22536985','0801-1995-12530','pespire',303,50);


-- llenado de la tabla estancia 
insert into estancia values (1,'2016-03-20','2016-03-21',101,1);
insert into estancia values (2,'2016-01-25','2016-01-29',202,2);
insert into estancia values (3,'2016-01-10','2016-02-11',101,3);
insert into estancia values (4,'2016-03-15','2016-03-17',303,4);
insert into estancia values (5,'2016-10-20','2016-10-29',303,5);
insert into estancia values (6,'2016-11-21','2016-11-22',101,6);
insert into estancia values (7,'2016-09-15','2016-12-15',101,7);
insert into estancia values (8,'2016-10-13','2016-10-15',303,8);
insert into estancia values (9,'2016-04-02','2016-04-05',303,9);
insert into estancia values (10,'2016-07-11','2016-07-15',101,10);
insert into estancia values (11,'2016-04-25','2016-04-27',101,11);
insert into estancia values (12,'2016-10-13','2016-10-15',101,12);
insert into estancia values (13,'2016-03-29','2016-04-03',303,13);
insert into estancia values (14,'2016-07-02','2016-07-05',303,14);
insert into estancia values (15,'2016-01-29','2016-02-02',202,15);
insert into estancia values (16,'2016-02-09','2016-02-12',202,16);
insert into estancia values (17,'2016-12-15','2016-12-24',303,17);
insert into estancia values (18,'2016-12-16','2016-12-24',303,18);
insert into estancia values (19,'2016-06-25','2016-07-01',202,19);
insert into estancia values (20,'2016-08-13','2016-08-15',303,20);
insert into estancia values (21,'2016-03-15','2016-03-22',202,21);
insert into estancia values (22,'2016-08-18','2016-08-20',303,22);
insert into estancia values (23,'2016-12-29','2016-12-30',101,23);
insert into estancia values (24,'2016-03-28','2016-03-29',202,24);
insert into estancia values (25,'2016-03-17','2016-03-21',303,25);
insert into estancia values (26,'2016-07-05','2016-07-10',202,26);
insert into estancia values (27,'2016-07-08','2016-07-10',303,27);
insert into estancia values (28,'2016-04-10','2016-04-12',101,28);
insert into estancia values (29,'2016-03-16','2016-03-17',202,29);
insert into estancia values (30,'2016-05-05','2016-05-06',303,30);
insert into estancia values (31,'2016-05-04','2016-05-07',101,31);
insert into estancia values (32,'2016-09-05','2016-09-10',202,32);
insert into estancia values (33,'2016-07-03','2016-07-05',303,33);
insert into estancia values (34,'2016-01-10','2016-01-11',101,34);
insert into estancia values (35,'2016-03-17','2016-03-25',202,35);
insert into estancia values (36,'2016-05-02','2016-05-25',303,36);
insert into estancia values (37,'2016-01-03','2016-01-05',101,37);
insert into estancia values (38,'2016-03-10','2016-03-15',202,38);
insert into estancia values (39,'2016-04-16','2016-04-20',303,39);
insert into estancia values (40,'2016-05-10','2016-05-15',101,40);
insert into estancia values (41,'2017-09-19','2017-09-25',202,41);
insert into estancia values (42,'2017-07-22','2017-07-29',303,42);
insert into estancia values (43,'2017-10-15','2017-10-18',101,43);
insert into estancia values (44,'2017-11-18','2017-11-20',202,44);
insert into estancia values (45,'2017-11-20','2017-11-25',303,45);
insert into estancia values (46,'2017-01-23','2017-01-29',101,46);
insert into estancia values (47,'2017-07-16','2017-07-18',202,47);
insert into estancia values (48,'2017-08-01','2017-08-15',303,48);
insert into estancia values (49,'2017-03-15','2017-03-23',101,49);
insert into estancia values (50,'2017-04-12','2017-04-15',202,50);


-- llenado de la tabla cliente_habitacion
insert into habitacion values (1,1501,1,5);
insert into habitacion values (2,1052,1,2);
insert into habitacion values (3,1503,1,4);
insert into habitacion values (4,1504,1,3);
insert into habitacion values (5,1505,1,5);
insert into habitacion values (6,1506,1,1);
insert into habitacion values (7,1507,1,2);
insert into habitacion values (8,1508,1,3);
insert into habitacion values (9,1509,1,4);
insert into habitacion values (10,1601,1,5);
insert into habitacion values (11,1602,1,5);
insert into habitacion values (12,1603,1,3);
insert into habitacion values (13,1604,1,4);
insert into habitacion values (14,1605,1,5);
insert into habitacion values (15,1606,1,4);
insert into habitacion values (16,1607,1,5);
insert into habitacion values (17,1608,1,3);
insert into habitacion values (18,1609,1,4);
insert into habitacion values (19,1701,1,5);
insert into habitacion values (20,1702,1,3);
insert into habitacion values (21,1703,1,2);
insert into habitacion values (22,1704,1,4);
insert into habitacion values (23,1705,1,3);
insert into habitacion values (24,1706,1,4);
insert into habitacion values (25,1707,1,5);
insert into habitacion values (26,1708,1,2);
insert into habitacion values (27,1709,1,3);
insert into habitacion values (28,1801,1,3);
insert into habitacion values (29,1802,1,4);
insert into habitacion values (30,1803,1,1);
insert into habitacion values (31,1804,1,5);
insert into habitacion values (32,1805,1,1);
insert into habitacion values (33,1806,1,3);
insert into habitacion values (34,1807,1,4);
insert into habitacion values (35,1808,1,2);
insert into habitacion values (36,1809,1,3);
insert into habitacion values (37,2001,1,4);
insert into habitacion values (38,2002,1,1);
insert into habitacion values (39,2003,1,5);
insert into habitacion values (40,2004,1,4);
insert into habitacion values (41,2005,1,2);
insert into habitacion values (42,2006,1,2);
insert into habitacion values (43,2007,1,3);
insert into habitacion values (44,2008,1,4);
insert into habitacion values (45,2009,1,5);
insert into habitacion values (46,3001,1,3);
insert into habitacion values (47,3002,1,2);
insert into habitacion values (48,3003,1,4);
insert into habitacion values (49,3004,1,5);
insert into habitacion values (50,3005,1,2);

-- llenado de la tabla cliente_habitacion
insert into cliente_habitacion values (1,1,1);
insert into cliente_habitacion values (2,2,2);
insert into cliente_habitacion values (3,3,3);
insert into cliente_habitacion values (4,4,4);
insert into cliente_habitacion values (5,5,5);
insert into cliente_habitacion values (6,6,6);
insert into cliente_habitacion values (7,7,7);
insert into cliente_habitacion values (8,8,8);
insert into cliente_habitacion values (9,9,9);
insert into cliente_habitacion values (10,10,10);
insert into cliente_habitacion values (11,11,11);
insert into cliente_habitacion values (12,12,12);
insert into cliente_habitacion values (13,13,13);
insert into cliente_habitacion values (14,14,14);
insert into cliente_habitacion values (15,15,15);
insert into cliente_habitacion values (16,16,16);
insert into cliente_habitacion values (17,17,17);
insert into cliente_habitacion values (18,18,18);
insert into cliente_habitacion values (19,19,19);
insert into cliente_habitacion values (20,20,20);
insert into cliente_habitacion values (21,21,21);
insert into cliente_habitacion values (22,22,22);
insert into cliente_habitacion values (23,23,23);
insert into cliente_habitacion values (24,24,24);
insert into cliente_habitacion values (25,25,25);
insert into cliente_habitacion values (26,26,26);
insert into cliente_habitacion values (27,27,27);
insert into cliente_habitacion values (28,28,28);
insert into cliente_habitacion values (29,29,29);
insert into cliente_habitacion values (30,30,30);
insert into cliente_habitacion values (31,31,31);
insert into cliente_habitacion values (32,32,32);
insert into cliente_habitacion values (33,33,33);
insert into cliente_habitacion values (34,34,34);
insert into cliente_habitacion values (35,35,35);
insert into cliente_habitacion values (36,36,36);
insert into cliente_habitacion values (37,37,37);
insert into cliente_habitacion values (38,38,38);
insert into cliente_habitacion values (39,39,39);
insert into cliente_habitacion values (40,40,40);
insert into cliente_habitacion values (41,41,41);
insert into cliente_habitacion values (42,42,42);
insert into cliente_habitacion values (43,43,43);
insert into cliente_habitacion values (44,44,44);
insert into cliente_habitacion values (45,45,45);
insert into cliente_habitacion values (46,46,46);
insert into cliente_habitacion values (47,47,47);
insert into cliente_habitacion values (48,48,48);
insert into cliente_habitacion values (49,49,49);
insert into cliente_habitacion values (50,50,50);


-- llenado de la tabla del mapa coropletico                                                                        -- longitud    -- latitud    
insert into mapa_ubicacion values (1,'mario casas','comayagua','comayagua','honduras','-87.61863790000001','14.5534828','2');
insert into mapa_ubicacion values (2,'sindy lopez','tegucigalpa','francisco morazan','honduras','-87.06242609999998','14.45411','1');
insert into mapa_ubicacion values (3,'nanci ramirez','nacaome','valle','honduras','-87.57912870000001','13.5782936','1');
insert into mapa_ubicacion values (4,'alex medina','la ceiba','atlántida','honduras','-87.1422895','15.6696283','2');
insert into mapa_ubicacion values (5,'katherne garcia','trujillo','colón','honduras','-85.35496499999999','15.6391768','1');
insert into mapa_ubicacion values (6,'camila cortes','yuscarán','el paraíso','honduras','-86.41873079999999','14.0736932','2');
insert into mapa_ubicacion values (7,'samuel medina','santa rosa de copán','copán','honduras','-88.86469799999998','14.9360838','3');
insert into mapa_ubicacion values (8,'rosa alvares','yuscarán','el paraíso','honduras','-86.41873079999999','14.0736932','2');
insert into mapa_ubicacion values (9,'berta caceres','puerto lempira','gracias a dios','honduras','-84.60604490000003','15.341806','1');
insert into mapa_ubicacion values (10,'adan medina','la esperanza','intibucá','honduras','-88.16328999999996','14.3197687','2');
insert into mapa_ubicacion values (11,'brenda fuentes','roatán','islas de la bahía','honduras','-86.48954630000003','16.3526078','1');
insert into mapa_ubicacion values (12,'ana lagos','nuevo ocotepeque','ocotepeque','honduras','-89.05615319999998','14.5170347','2');
insert into mapa_ubicacion values (13,'junior lopez','la paz','la paz','honduras','-87.93348029999999','13.9984833','1');
insert into mapa_ubicacion values (14,'frank gomez','gracias','lempira','honduras','-88.556531','14.1887698','2');
insert into mapa_ubicacion values (15,'daniela gonzales','juticalpa','olancho','honduras','-85.76666449999999','14.8067406','2');



show tables;


select table_name as tabla, table_rows as num_registros
from INFORMATION_SCHEMA.TABLES
where TABLE_SCHEMA = 'hostal';

/* 25oct22 de:
https://sites.google.com/site/basedatoshotellaboratorioiii/script-base-de-datos-hotel-ginzda-1*/