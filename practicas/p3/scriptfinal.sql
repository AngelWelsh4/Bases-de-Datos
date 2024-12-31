/* Ejercicio 1 */
# 1.

prompt [\w\O \R:\m] (\d) ~>

# 2.
DROP DATABASE IF EXISTS pr03_eq11;
CREATE DATABASE IF NOT EXISTS pr03_eq11 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

# 3.
USE pr03_eq11;
CREATE TABLE IF NOT EXISTS trabajador(
	id INT UNSIGNED NOT NULL PRIMARY KEY,
	nombre_pila VARCHAR(10),
	puesto VARCHAR(15) NOT NULL
	);
DESC trabajador;

# 4.
CREATE TABLE IF NOT EXISTS ingrediente(
	codigo TINYINT UNSIGNED NOT NULL PRIMARY KEY auto_increment,
	nombre VARCHAR(20),
	precio_kg DECIMAL(3,1),
	disponibilidad ENUM('D', 'ND') DEFAULT 'ND'
);
DESC ingrediente;

# 5.
ALTER TABLE trabajador 
	ADD COLUMN fecha_inicio DATE DEFAULT '2022-09-30' AFTER nombre_pila,
	ALTER COLUMN puesto SET DEFAULT 'pasante',
	ADD COLUMN ing_fav TINYINT UNSIGNED NOT NULL,
	ADD FOREIGN KEY(ing_fav) REFERENCES ingrediente(codigo),
	MODIFY COLUMN id INT UNSIGNED NOT NULL auto_increment;
DESC trabajador;
SHOW CREATE TABLE trabajador;

/* Ejercicio 2 */

-- Creacion de tablas en orden 
-- Son 12 tablas en total
#--------------------------------
-- 1. CREACION DE TABLA estado
#--------------------------------
CREATE TABLE IF NOT EXISTS estado(
	clave_estado TINYINT UNSIGNED NOT NULL PRIMARY KEY auto_increment, 
	nombre VARCHAR(20) NOT NULL UNIQUE KEY
	);
#--------------------------------
-- 2. CREACION DE TABLA municipio
#--------------------------------
CREATE TABLE IF NOT EXISTS municipio(
	clave_municipio TINYINT UNSIGNED NOT NULL PRIMARY KEY auto_increment,
	nombre VARCHAR(25) NOT NULL,
	clave_estado TINYINT UNSIGNED NOT NULL,
	CONSTRAINT 	FK_estado_municipio FOREIGN KEY (clave_estado) REFERENCES estado(clave_estado)
	);
#--------------------------------
-- 3. CREACION DE TABLA colonia
#--------------------------------
CREATE TABLE IF NOT EXISTS colonia(
	id_colonia TINYINT UNSIGNED NOT NULL PRIMARY KEY auto_increment,
	nombre VARCHAR(30) NOT NULL,
	cp CHAR(5),
	clave_municipio TINYINT UNSIGNED NOT NULL,
	CONSTRAINT FK_municipio_colonia FOREIGN KEY (clave_municipio) REFERENCES municipio(clave_municipio)
	);
#--------------------------------
-- 4. CREACION DE TABLA direccion
#--------------------------------
CREATE TABLE IF NOT EXISTS direccion(
	id_direccion TINYINT UNSIGNED NOT NULL PRIMARY KEY auto_increment,
	calle VARCHAR(20) NOT NULL,
	num_ext SMALLINT NOT NULL,
	num_int VARCHAR(5),#algunos numero interiores contienen letras por eso varchar
	id_colonia TINYINT UNSIGNED NOT NULL,
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
	 	id_direccion TINYINT UNSIGNED NOT NULL,	
	 	CONSTRAINT FK_direccion_cliente FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion)
	 	);

#------------------------------------
-- 6. CREACION DE TABLA administrador
#------------------------------------
CREATE TABLE IF NOT EXISTS administrador(
	id_admin TINYINT UNSIGNED NOT NULL PRIMARY KEY auto_increment, 
	rfc CHAR(13) NOT NULL, 
	telefono CHAR(10), 
	nombre VARCHAR(20) NOT NULL, 
	apellido_paterno VARCHAR(20) NOT NULL, 
	apellido_materno VARCHAR(20));
#------------------------------
-- 7. CREACION DE TABLA modelo
#------------------------------
CREATE TABLE IF NOT EXISTS modelo(
	id_modelo SMALLINT UNSIGNED NOT NULL PRIMARY KEY auto_increment, 
	nombre_modelo VARCHAR(30) NOT NULL,
	anio SMALLINT UNSIGNED NOT NULL, 
	color VARCHAR(20) NOT NULL);
#--------------------------------
-- 8. CREACION DE TABLA vehiculo
#--------------------------------
CREATE TABLE IF NOT EXISTS vehiculo(
	placa VARCHAR(7) NOT NULL PRIMARY KEY,
	kilometraje SMALLINT UNSIGNED DEFAULT 0, 
	estado_disponible ENUM('YES','NO') NOT NULL,
	transmision VARCHAR(30) NOT NULL, 
	costo_por_dia float(7,2), 
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
CREATE TABLE IF NOT EXISTS vehiculo_renta(
	placa VARCHAR(7) NOT NULL, 
	id_cliente INT UNSIGNED, 
	fecha_incio_renta DATE NOT NULL,
	fecha_fin_renta DATE NOT NULL,
	descuento_aplicado ENUM('YES', 'NO') NOT NULL DEFAULT 'NO', 
	PRIMARY KEY (placa, id_cliente), 
	CONSTRAINT FK_cliente_vehiculo_renta FOREIGN KEY(id_cliente) REFERENCES cliente(id_cliente), 
	CONSTRAINT FK_vehiculo_vehiculo_renta FOREIGN KEY(placa) REFERENCES vehiculo(placa)
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
	num_poliza SMALLINT UNSIGNED NOT NULL PRIMARY KEY,
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

