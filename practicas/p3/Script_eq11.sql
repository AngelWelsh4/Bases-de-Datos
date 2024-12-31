/* Ejercicio 1 - DDL */
# 1. Cambiamos el prompt al formato indicado

prompt [\w\O \R:\m] (\d) ~>
#______________________________________
#

# 2. Creamos la base de datos con la codificacion indicada

DROP DATABASE IF EXISTS pr03_eq11;
CREATE DATABASE IF NOT EXISTS pr03_eq11 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
#______________________________________
#

# 3. Creamos la tabla tranjador

USE pr03_eq11;
CREATE TABLE IF NOT EXISTS trabajador(
	id INT UNSIGNED PRIMARY KEY,
	nombre_pila VARCHAR(10),
	puesto VARCHAR(15) NOT NULL
	);
DESC trabajador;
#______________________________________
#

# 4. Creamos la tabla ingrediente

CREATE TABLE IF NOT EXISTS ingrediente(
	codigo TINYINT UNSIGNED PRIMARY KEY auto_increment,
	nombre VARCHAR(20),
	precio_kg DECIMAL(3,1),
	disponibilidad ENUM('D', 'ND') DEFAULT 'ND'
);
DESC ingrediente;
#______________________________________
#

# 5. Modificamos la tabla trabajador para poder conocer cual es su ingrediente fav
ALTER TABLE trabajador 
	ADD COLUMN fecha_inicio DATE DEFAULT '2022-09-30' AFTER nombre_pila,
	ALTER COLUMN puesto SET DEFAULT 'pasante',
	ADD COLUMN ing_fav TINYINT UNSIGNED NOT NULL,
	ADD FOREIGN KEY(ing_fav) REFERENCES ingrediente(codigo),
	MODIFY COLUMN id INT UNSIGNED NOT NULL auto_increment;
DESC trabajador;
SHOW CREATE TABLE trabajador;

#______________________________________
#




/* Ejercicio 2  - Mapeo examen práctico*/

#--------------------------------
-- Creacion de la base
#--------------------------------
DROP DATABASE IF EXISTS mod_eq11;
CREATE DATABASE IF NOT EXISTS mod_eq11 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
USE mod_eq11;
#--------------------------------
-- Creacion de tablas en orden 
-- Son 12 tablas en total
#--------------------------------
-- 1. CREACION DE TABLA estado
#--------------------------------
CREATE TABLE IF NOT EXISTS estado(
	clave_estado TINYINT UNSIGNED PRIMARY KEY auto_increment, 
	nombre VARCHAR(20) NOT NULL UNIQUE KEY
	);
#--------------------------------
-- 2. CREACION DE TABLA municipio
#--------------------------------
CREATE TABLE IF NOT EXISTS municipio(
	clave_municipio SMALLINT UNSIGNED PRIMARY KEY auto_increment,#en Mexico existen 2445 municipios
	nombre VARCHAR(25) NOT NULL,
	clave_estado TINYINT UNSIGNED NOT NULL,
	CONSTRAINT 	FK_estado_municipio FOREIGN KEY (clave_estado) REFERENCES estado(clave_estado)
	);
#--------------------------------
-- 3. CREACION DE TABLA colonia
#--------------------------------
CREATE TABLE IF NOT EXISTS colonia(
	id_colonia MEDIUMINT UNSIGNED PRIMARY KEY auto_increment,
	nombre VARCHAR(30) NOT NULL,
	cp CHAR(5),
	clave_municipio SMALLINT UNSIGNED NOT NULL,
	CONSTRAINT FK_municipio_colonia FOREIGN KEY (clave_municipio) REFERENCES municipio(clave_municipio)
	);
#--------------------------------
-- 4. CREACION DE TABLA direccion
#--------------------------------
CREATE TABLE IF NOT EXISTS direccion(
	id_direccion INT UNSIGNED PRIMARY KEY auto_increment,#por el número de permutaciones INT
	calle VARCHAR(20) NOT NULL,
	num_ext SMALLINT NOT NULL,
	num_int VARCHAR(5),#algunos numero interiores contienen letras por eso varchar
	id_colonia MEDIUMINT UNSIGNED NOT NULL,
	CONSTRAINT FK_colonia_direccion FOREIGN KEY (id_colonia) REFERENCES colonia(id_colonia)
	);

#--------------------------------
-- 5. CREACION DE TABLA cliente 
#--------------------------------

CREATE TABLE IF NOT EXISTS cliente(
	id_cliente INT UNSIGNED PRIMARY KEY auto_increment,
	 	num_tarjeta VARCHAR(19) NOT NULL, 	
	 	rfc CHAR(13) NOT NULL UNIQUE KEY, 
	 	telefono CHAR(10), 	
	 	num_rentas_realizadas TINYINT UNSIGNED NOT NULL DEFAULT 1, 	
	 	nombre VARCHAR(40) NOT NULL, 
	 	id_direccion INT UNSIGNED NOT NULL,	
	 	CONSTRAINT FK_direccion_cliente FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion)
	 	);

#------------------------------------
-- 6. CREACION DE TABLA administrador
#------------------------------------
CREATE TABLE IF NOT EXISTS administrador(
	id_admin TINYINT UNSIGNED PRIMARY KEY auto_increment, 
	rfc CHAR(13) NOT NULL, 
	telefono CHAR(10), 
	nombre VARCHAR(20) NOT NULL, 
	apellido_paterno VARCHAR(20) NOT NULL, 
	apellido_materno VARCHAR(20));
#------------------------------
-- 7. CREACION DE TABLA modelo
#------------------------------
CREATE TABLE IF NOT EXISTS modelo(
	id_modelo SMALLINT UNSIGNED PRIMARY KEY auto_increment, 
	nombre_modelo VARCHAR(30) NOT NULL,
	anio SMALLINT UNSIGNED NOT NULL, 
	color VARCHAR(20) NOT NULL);
#--------------------------------
-- 8. CREACION DE TABLA vehiculo
#--------------------------------
CREATE TABLE IF NOT EXISTS vehiculo(
	placa VARCHAR(7) PRIMARY KEY,
	kilometraje SMALLINT UNSIGNED DEFAULT 0, 
	estado_disponible ENUM('YES','NO') NOT NULL,
	transmision VARCHAR(30) NOT NULL, 
	costo_por_dia decimal(7,2), 
	id_modelo SMALLINT UNSIGNED NOT NULL, 
	CONSTRAINT FK_modelo_vehiculo FOREIGN KEY (id_modelo) REFERENCES modelo(id_modelo));
#--------------------------------
-- 9. CREACION DE TABLA incidente
#--------------------------------
CREATE TABLE IF NOT EXISTS incidente(
	id_incidente TINYINT UNSIGNED PRIMARY KEY, 
	tipo_incidente VARCHAR(30) NOT NULL);
#--------------------------------
-- 10. CREACION DE TABLA vehiculo_renta
#--------------------------------
CREATE TABLE IF NOT EXISTS vehiculoRenta(
	placa VARCHAR(7) NOT NULL, 
	id_cliente INT UNSIGNED NOT NULL, 
	fecha_incio_renta DATE NOT NULL,
	fecha_fin_renta DATE NOT NULL,
	descuento_aplicado ENUM('YES', 'NO') NOT NULL DEFAULT 'NO', 
	PRIMARY KEY (placa, id_cliente), 
	CONSTRAINT FK_cliente_vehiculoRenta FOREIGN KEY(id_cliente) REFERENCES cliente(id_cliente), 
	CONSTRAINT FK_vehiculo_vehiculoRenta FOREIGN KEY(placa) REFERENCES vehiculo(placa)
	);
#--------------------------------
-- 11. CREACION DE TABLA incidente_vehiculo
#--------------------------------
CREATE TABLE incidenteVehiculo(
	id_incidente TINYINT UNSIGNED NOT NULL,
	placa VARCHAR(7) NOT NULL,
	fecha_incidente DATE, 
	monto_incidente decimal(10,1),
	PRIMARY KEY (id_incidente, placa),
	CONSTRAINT FK_incidente_incidenteVehiculo FOREIGN KEY (id_incidente) REFERENCES incidente(id_incidente),
	CONSTRAINT FK_vehiculo_incidenteVehiculo FOREIGN KEY (placa) REFERENCES vehiculo(placa)
	);
#------------------------------
-- 12. CREACION DE TABLA seguro
#------------------------------
CREATE TABLE seguro(
	num_poliza SMALLINT UNSIGNED PRIMARY KEY,
	fecha_inicio_vigencia DATE NOT NULL,
	fecha_fin_vigencia DATE NOT NULL,
	tipo_cobertura VARCHAR(20) NOT NULL,
	suma_asegurada decimal(9,2),
	costo_seguro decimal(7,2),
	placa VARCHAR(7) NOT NULL,
	nombre_aseguradora VARCHAR(25),
	telefono_aseguradora VARCHAR(10) NOT NULL,
	CONSTRAINT FK_vehiculo_seguro FOREIGN KEY (placa) REFERENCES vehiculo(placa)
	);
prompt 






/* Ejercicios extra */
# 1.
 /* ¿Qué es MUL en la columna Key de la tabla resultante de una instrucción DESCRIBE?
	Respuesta:
	Una KEY MUL significa que ese atributo puede tener multiples repeticiones de un dato,
	por ejemplo en el caso de trabajador e ingrediente favorito, significa que
	varios trabajadores (distintos) pueden tener un mismo ingrediente favorito, a eso hace 
	referencia el mul

	¿En qué casos puede hallarse?
	Respuesta:
	Puede hallarse en las los atributos que son llaves foraneas

 */

 # CODIGO CON ARGUMENTOS
# PRIMERO Cambiamos a la BASE DE DATOS DE LA PRACTICA
USE pr03_eq11;
# CREAMOS UNA TABLA PARA ALMACENAR GATOS
CREATE TABLE IF NOT EXISTS gato(
	id INT UNSIGNED PRIMARY KEY,
	nombre_gato VARCHAR(10)
	);
# CREAMOS UNA TABLA PARA ALMACENAR COMIDA DE GATOS
CREATE TABLE IF NOT EXISTS comida(
	codigo TINYINT UNSIGNED PRIMARY KEY auto_increment,
	nombre VARCHAR(20)
	);



# CADA GATO TIENE UNA COMIDA FAVORITA ASI QUE AGREGAMOS EL ATRIBUTO comida_fav
ALTER TABLE gato 
	ADD COLUMN comida_fav TINYINT UNSIGNED NOT NULL;

DESC gato;

# NOTEMOS QUE EL ATRIBUTO comida_fav no es KEY MUL pues no esta REFERENCIADO COMO LLAVE FORANEA TODAVIA

# REFERENCIAMOS comida_fav con el codigo de la comida de gato
ALTER TABLE gato 
	ADD FOREIGN KEY(comida_fav) REFERENCES comida(codigo);
DESC gato;

# AHORA SI APARECE EL MUL, Y TIENE SENTIDO PORQUE A MULTPLES GATOS LES PUEDE GUSTAR LA MISMA COMIDA por ejemplo 'POLLITO'
# Asi que el codigo de 'POLLITO' va a salir multiples veces




 # 2.
/*
TABLA CON ERRORES

 create table if exists (
	atributo1 smallint unsigned auto_increment,
	atributo4 not null primary_key,
	atributo2 year default ‘1997-01-02’,
	atributo6 char(50) unsigned not null
	foreign key (atributo2, atributo6);
*/

 # LISTA DE ERRORES
/*
1 no tiene nombre la tabla
2 atributo2 debe ser declarado como tipo DATE
3 falta un not despues de if 
4 atributo4 no se sabe que tipo de dato es
5.1 atributo1 tiene auto_increment pero no es llave primaria 
5.2 atributo4 esta mal escrito primary key
6 Estan mal declaradas las llaves foraneas
7 La fecha por default debe de ir entre '' 
8 No hay una coma (,) despues de declarar not null 
9 Hace falta un parentesis al final, antes del (;)
10 El atributo6 es un char por lo que no puede ser unsigned
*/ 
# tabla correcta
create table if NOT exists tabla(
	atributo1 smallint unsigned ,
	atributo4 int not null primary key auto_increment,
	atributo2 DATE default '1997-01-02',
	atributo6 char(50) not null
	);

prompt [\w\O \R:\m] (\d) ~>

