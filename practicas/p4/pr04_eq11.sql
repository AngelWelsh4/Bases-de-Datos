/*Ejercicio 1*/
# 1.
PROMPT \c [\R:\m]-[\d] ->

# 2.
DROP DATABASE IF EXISTS pr04_eq11;
CREATE DATABASE IF NOT EXISTS pr04_eq11 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

# 3.
USE pr04_eq11;
CREATE TABLE IF NOT EXISTS Producto(
	cod_prod INT UNSIGNED PRIMARY KEY auto_increment,
	precio DECIMAL(6,2) NOT NULL DEFAULT 9999.99,
	tipo VARCHAR(30) NOT NULL,
	marca VARCHAR(20) NOT NULL
);
CREATE TABLE IF NOT EXISTS Tienda(
	num_tienda INT UNSIGNED PRIMARY KEY auto_increment,
	nombre VARCHAR(50) NOT NULL,
	direccion VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS Vendedor(
	num_vendedor SMALLINT UNSIGNED PRIMARY KEY auto_increment,
	nombre VARCHAR(30) NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS Ventas(
	num_venta INT UNSIGNED PRIMARY KEY auto_increment,
	id_cliente INT NOT NULL,
	id_vendedor SMALLINT UNSIGNED NOT NULL,
	id_tienda INT UNSIGNED NOT NULL,
	fecha_compra TIMESTAMP NOT NULL,
	total DECIMAL(8,2) NOT NULL,
	CONSTRAINT FK_Tienda_Ventas FOREIGN KEY (id_tienda) REFERENCES Tienda(num_tienda),
	CONSTRAINT FK_Vendedor_Ventas FOREIGN KEY (id_vendedor) REFERENCES Vendedor(num_vendedor)
);
CREATE TABLE IF NOT EXISTS Detalle_Ventas(
	cod_prod INT UNSIGNED NOT NULL,
	id_venta INT UNSIGNED NOT NULL,
	cantidad SMALLINT UNSIGNED NOT NULL,
	PRIMARY KEY(cod_prod, id_venta),
	CONSTRAINT FK_Producto_DetalleVentas FOREIGN KEY (cod_prod) REFERENCES Producto(cod_prod),
	CONSTRAINT FK_Ventas_DetalleVentas FOREIGN KEY (id_venta) REFERENCES Ventas(num_venta)
);

# 4.
/* - Se puede partir creando la tabla Producto o bien la tabla Vendedor o Tienda ya que todas son tablas padres 
y no contienen llaves foraneas.


- Si nos referimos a que tabla crear al final, la respuesta es no porque la tabla Detalle_Ventas es hija de Producto
y Ventas y a su vez Ventas es hija de Vendedor y Tienda, con lo que forsozamente se deberían crear todas estas tablas
antes. Por otro lado, si se hace referencia a que tabla meterle registros al final, sería tabla Detalle_Ventas
porque necesita de la existencia de una venta y el producto, implicando a su vez que exista el regsitro de la persona 
que lo vendio y en que sucursal. */

# 5.
INSERT INTO Producto (precio, tipo, marca) VALUES 
	(26.00, 'leche','ALPURA'),
	(35.00, 'crema', 'LALA'),
	(54.50, 'papas', 'PAKETAXO') ;
INSERT INTO Tienda (nombre, direccion) VALUES
	('OXXO Avena', 'Cto Interior Avenida Rio Churubusco 495, Granjas Mexico, Izatacalco'),
	('WALMART Aeropuerto', 'Calz. Ignacio Zaragoza 58, Industrial Puerto Aereo, Venustiano Carranza'),
	('BODEGA AURRERA Churubusco', 'Picos VI B and 1, Los Picos VI B, Iztapalapa') ;
INSERT INTO Vendedor (nombre) VALUES
	('Alexander Rodriguez Garcia'),
	('Paola Isabel Montes Cruz'),
	('Melissa Ariadna Herrera Salas') ;
INSERT INTO Ventas (id_cliente, id_vendedor, id_tienda, fecha_compra, total) VALUES
	(7245, 1, 3, '20080722093805', 35.00),
	(158784, 3, 2, '19980227145831', 109.00),
	(37641, 2, 1, '20230319030349', 327.00) ;
	/*Los valores introducidos previamente y posteriormente tienen que hacer referencia a registros existentes
	para no marcar error*/
INSERT INTO Detalle_Ventas VALUES
	(2, 1, 1),
	(3, 3, 6),
	(3, 2, 2) ;

# 6.
SELECT * FROM Producto ORDER BY cod_prod DESC;
SELECT * FROM Tienda ORDER BY num_tienda DESC;
SELECT * FROM Vendedor ORDER BY num_vendedor DESC;
SELECT * FROM Ventas ORDER BY num_venta DESC;
SELECT * FROM Detalle_Ventas ORDER BY cod_prod, id_venta DESC;

/* Ejercicio 2 
Parte de la pr03_eq11 corregida
*/
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
	nombre VARCHAR(50) NOT NULL,
	clave_estado TINYINT UNSIGNED NOT NULL,
	CONSTRAINT 	FK_estado_municipio FOREIGN KEY (clave_estado) REFERENCES estado(clave_estado)
	);
#--------------------------------
-- 3. CREACION DE TABLA colonia
#--------------------------------
CREATE TABLE IF NOT EXISTS colonia(
	id_colonia MEDIUMINT UNSIGNED PRIMARY KEY auto_increment,
	nombre VARCHAR(50) NOT NULL,
	cp CHAR(5),
	clave_municipio SMALLINT UNSIGNED NOT NULL,
	CONSTRAINT FK_municipio_colonia FOREIGN KEY (clave_municipio) REFERENCES municipio(clave_municipio)
	);
#--------------------------------
-- 4. CREACION DE TABLA direccion
#--------------------------------
CREATE TABLE IF NOT EXISTS direccion(
	id_direccion INT UNSIGNED PRIMARY KEY auto_increment,#por el número de permutaciones INT
	calle VARCHAR(50) NOT NULL,
	num_ext VARCHAR(5) NOT NULL,
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
	apellido_materno VARCHAR(20),
	contrasenia_codificada CHAR(32) NOT NULL);
	/* La contraseña se contempla que sea un cifrado tipo md5, bajo el comando "md5('contraseña')" al insertar valores */
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
	id_incidente TINYINT UNSIGNED PRIMARY KEY auto_increment, 
	tipo_incidente VARCHAR(30) NOT NULL);
#--------------------------------
-- 10. CREACION DE TABLA vehiculo_renta
#--------------------------------
CREATE TABLE IF NOT EXISTS vehiculoRenta(
	id_cliente INT UNSIGNED NOT NULL, 
	placa VARCHAR(7) NOT NULL, 
	fecha_incio_renta DATE NOT NULL,
	fecha_fin_renta DATE NOT NULL, 
	descuento_aplicado ENUM('YES', 'NO') DEFAULT 'NO', 
	PRIMARY KEY (id_cliente, placa), 
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
	nombre_aseguradora VARCHAR(25) DEFAULT 'GNP',
	telefono_aseguradora VARCHAR(10) NOT NULL DEFAULT 5524609125,
	CONSTRAINT FK_vehiculo_seguro FOREIGN KEY (placa) REFERENCES vehiculo(placa)
	);

# 1.
DESC estado;
DESC municipio;
DESC colonia;
DESC direccion;
DESC cliente;
DESC administrador;
DESC modelo;
DESC vehiculo;
DESC incidente;
DESC vehiculoRenta;
DESC incidenteVehiculo;
DESC seguro;

# 2.
# VAMOS A INCERTAR 5 VALORES A LAS 12 TABLAS QUE TIENE NUESTRA BASE DE DATOS

#------------------------------------------
-- 1. INCERTAMOS VALORES A LA TABLA estado
#------------------------------------------
INSERT INTO estado (nombre) VALUES
	('Ciudad de Mexico'),
	('Oaxaca'),
	('Tamaulipas'),
	('Sonora'),
	('Estado de Mexico') ;
#---------------------------------------------
-- 2. INCERTAMOS VALORES A LA TABLA municipio
#---------------------------------------------
INSERT INTO municipio (nombre, clave_estado) VALUES
	('Iztacalco', 1),
	('Tenancingo', 5),
	('Xicotencatl', 3),
	('San Bartolo Coyotepec', 2),
	('Hermosillo', 4) ;
#---------------------------------------------
-- 3. INCERTAMOS VALORES A LA TABLA colonia
#---------------------------------------------
INSERT INTO colonia (nombre, cp, clave_municipio) VALUES
	('Granjas Mexico', '08400', 1),
	('Ramos Millan', '08730', 1),
	('Pueblo San Miguel Tecomatlan', '52425', 2),
	('Ferrocarrilera', '83013', 4),
	('Inpi Picos', '08760', 1) ;
#---------------------------------------------
-- 4. INCERTAMOS VALORES A LA TABLA direccion
#---------------------------------------------
INSERT INTO direccion (calle, num_ext, num_int, id_colonia) VALUES
	('Cda. 3ra de Avena', '9BIS', NULL, 1),
	('Carlos Juan Finlay', '8', '714', 5),
	('Sur 133', '2020', NULL, 2),
	('Cto. Interior Avenida Rio Churubusco', '216', '104', 1),
	('Morelos', '17', NULL, 3) ;
#---------------------------------------------
-- 5. INCERTAMOS VALORES A LA TABLA cliente
#---------------------------------------------
INSERT INTO cliente(num_tarjeta, rfc, telefono, nombre, id_direccion) VALUES 
('6478523987416852348', 'KSHD890412', '6642793812', 'Kasu Holy Dante', 2),
('5746839214875632194', 'PIOR000329', '8462571394', 'Pime Ortiz Ramiro', 1),
('5746839252368528194', 'RIUJ000329', '8468798394', 'Reyes Ortega Santiago', 3),
('5968425872054100394', 'HEMS961230', '8963145874', 'Hernandez Mendez Sol', 5),
('5364789215589625094', 'BARU661230', '3658498774', 'Badillo Reyes Uriel', 4);
#------------------------------------------------
-- 6. INCERTAMOS VALORES A LA TABLA administrador
#------------------------------------------------
INSERT INTO administrador(rfc, telefono, nombre, apellido_paterno, apellido_materno, contrasenia_codificada) VALUES 
('HGFJ489625', '9631478529', 'Javier', 'Mendez', 'Nuez', md5('hola')),
('POUG347865', '6314978563', 'Lola', 'Perez', 'Ramirez', md5('contrasenia')),
('LKDN364125', '3654782256', 'Pablo', 'Reyes', 'Gonzalez', md5('123456')),
('KISF968616', '9996554788', 'Gloria', 'Julian', 'Rose', md5('GloriJR')),
('LKKJ534684', '3336698421', 'Adolfo', 'Juarez', 'Puente', md5('MichiEspacial19'));
#------------------------------------------------
-- 7. INCERTAMOS VALORES A LA TABLA modelo
#------------------------------------------------
INSERT INTO modelo (id_modelo,nombre_modelo,anio,color) VALUES 
(0,'Honda Civic',2010,'blanco'),(0,'Honda CRV',2020,'negro'),
(0,'Toyota Yaris',2019,'azul'),
(0,'Toyota Corolla',2018,'rojo'),
(0,'Volkswagen Jetta',2005,'gris');
#------------------------------------------------
-- 8. INCERTAMOS VALORES A LA TABLA vehiculo
#------------------------------------------------
INSERT INTO vehiculo(placa, kilometraje, estado_disponible, transmision, costo_por_dia, id_modelo) VALUES
('NBJ2011', '0', 'YES', 'Manual', 50000, 4),
('FDJ4523', '1000', 'YES', 'Automatico', 35000, 2),
('QHF2614', '500', 'NO', 'Continuamente variable', 25000, 5),
('NEC2023', '20000', 'NO', 'Doble embrague', 50000, 1),
('VAC1577', '3500', 'YES', 'Manual', 50000, 3);
#------------------------------------------------
-- 9. INCERTAMOS VALORES A LA TABLA incidente
#------------------------------------------------
INSERT INTO incidente (tipo_incidente) VALUES
 ('Colision'),
 ('Colision multiple'),
 ('Salidas de la vía'),
 ('Arrollamiento'),
 ('Accidente de vuelco') ;
 #------------------------------------------------
-- 10. INCERTAMOS VALORES A LA TABLA seguro
#------------------------------------------------
INSERT INTO seguro (num_poliza, fecha_inicio_vigencia, fecha_fin_vigencia, tipo_cobertura, suma_asegurada, costo_seguro, placa) VALUES
 (648, '20220722', '20230722', 'Basica', 200000, 12400, 'FDJ4523'),
 (238, '20220723', '20230723', 'Plus', 260000, 13000, 'NBJ2011'),
 (292, '20220724', '20230724', 'Master', 340000, 14000, 'NEC2023'),
 (295, '20220725', '20230725', 'Prime', 370000, 15000, 'VAC1577'),
 (248, '20220726', '20230726', 'Basica', 210000, 12300, 'QHF2614');
#-----------------------------------------------------
-- 11. INCERTAMOS VALORES A LA TABLA incidenteVehiculo
#-----------------------------------------------------
INSERT INTO incidenteVehiculo (id_incidente, placa, fecha_incidente, monto_incidente) VALUES
	(1, 'NBJ2011', '20220922',53012.1),
	(4, 'NBJ2011', '20230101',33012.7),
	(1, 'NEC2023', '20221029',43012.3),
	(3, 'NBJ2011', '20220912',13012.8),
	(2, 'NEC2023', '20220903',73012.2) ;
#-----------------------------------------------------
-- 12. INCERTAMOS VALORES A LA TABLA vehiculoRenta
#-----------------------------------------------------
#INCETANDO CLIENTES CON DESCUENTO 

INSERT INTO vehiculoRenta (id_cliente, placa, fecha_incio_renta, fecha_fin_renta, descuento_aplicado) VALUES
	(3, 'NBJ2011', '20221029', '20221122', 'YES'),
	(4, 'NBJ2011', '20220912', '20220922', 'YES');

INSERT INTO vehiculoRenta (id_cliente, placa, fecha_incio_renta, fecha_fin_renta) VALUES
	(1, 'FDJ4523', '20220901', '20220903'),	
	(2, 'NEC2023', '20220101', '20220124'),
	(1, 'VAC1577', '20220903', '20220925') ;






# 3.
SELECT * FROM estado ORDER BY clave_estado;
SELECT * FROM municipio ORDER BY clave_municipio;
SELECT * FROM colonia ORDER BY id_colonia;
SELECT * FROM direccion ORDER BY id_direccion;
SELECT * FROM cliente ORDER BY id_cliente;
SELECT * FROM administrador ORDER BY id_admin;
SELECT * FROM modelo ORDER BY id_modelo;
SELECT * FROM vehiculo ORDER BY placa;
SELECT * FROM incidente ORDER BY id_incidente;
SELECT * FROM seguro ORDER BY num_poliza;
SELECT * FROM incidenteVehiculo ORDER BY id_incidente AND placa;
SELECT * FROM vehiculoRenta ORDER BY id_cliente AND placa;
	
	

 
 
