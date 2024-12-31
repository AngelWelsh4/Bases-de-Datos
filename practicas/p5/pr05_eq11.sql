#----------------------------------------------------
--  CORRECCIONES DE LA PARTE PRACTICA DEL EXAMEN 1
#----------------------------------------------------


#--------------------------------
-- Creacion de la base del EXAMEN PRACTICO 1
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
('HGFJ489625', '9631478529', 'Javier', 'Mendez', 'Nuez', md5('co124ntrasecña')),
('POUG347865', '6314978563', 'Lola', 'Perez', 'Ramirez', md5('cosntras31eaña')),
('LKDN364125', '3654782256', 'Pablo', 'Reyes', 'Gonzalez', md5('contrd12aseña')),
('KISF968616', '9996554788', 'Gloria', 'Julian', 'Rose', md5('c12kmdl12')),
('LKKJ534684', '3336698421', 'Adolfo', 'Juarez', 'Puente', md5('co12m12102'));
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





#----------------------------------------------------
--                 PRACTICA 5
#----------------------------------------------------

/*Ejercicio 0*/
PROMPT m/ (>.<) \\m - [\d] ->

/*Ejercicio 1*/
USE mundo;
#--------------------------------
-- Ejercicio 1.1
#--------------------------------
SELECT pais AS paises_con_a FROM paises WHERE pais LIKE '%a%' AND pais NOT LIKE '% %';

SELECT pais AS paises_con_e FROM paises WHERE pais LIKE '%e%' AND pais NOT LIKE '% %';

SELECT pais AS paises_con_i FROM paises WHERE pais LIKE '%i%' AND pais NOT LIKE '% %';

SELECT pais AS paises_con_o FROM paises WHERE pais LIKE '%o%' AND pais NOT LIKE '% %';

SELECT pais AS paises_con_u FROM paises WHERE pais LIKE '%u%' AND pais NOT LIKE '% %';


#--------------------------------
-- Ejercicio 1.2
#--------------------------------

SELECT capital, pais FROM paises WHERE capital LIKE 'B%' AND LENGTH(TRIM(capital))=6 ORDER BY poblacion DESC;

#--------------------------------
-- Ejercicio 1.3
#--------------------------------
SELECT pais, capital, LENGTH(pais) AS Caracteres_pais, 
LENGTH(capital) AS Caracteres_capital
 FROM paises
 WHERE LENGTH(pais) = LENGTH(capital)
 AND LEFT(pais,1)=LEFT(capital,1)
 ORDER BY Caracteres_pais ASC;


#--------------------------------
-- Ejercicio 1.4
#--------------------------------

SELECT CONCAT(pais, " con capital ", capital, " tiene ",  TRUNCATE(poblacion/1000000,2),"M de habitantes" ) AS 'Pais,Capital,Poblacion' FROM paises ORDER BY poblacion DESC limit 3;


#--------------------------------
-- Ejercicio 1.5
#--------------------------------

SELECT pais, FORMAT(gdp, 0) AS 'PIB', FORMAT(gdp/poblacion,0) AS 'PIB per capita' FROM paises WHERE pais ='México' OR ((continente LIKE '%America'OR continente = 'Caribbean') AND gdp/poblacion>10000) ORDER BY gdp/poblacion;

/* Respuestas a preguntas:
1. El atributo gdp es el único en unidad monetaria, y comparando los valores registrados en México con nuestra fuente [1] llegamos a que es a current US$ (dólares a precios actuales).

2. Comparando el gdp y la población con las fuentes citadas ([1] y [2]), llegamos a que la mejor aproximación para ambos valores corresponde al año 2015. Y en la pagina del inegi podemos corroborar esa cifra [3]. Respuesta: Año 2015

Fuentes:
[1] GDP (current US$) | Data. (s. f.). https://data.worldbank.org/indicator/NY.GDP.MKTP.CD?end=2021&locations=MX&start=1960
[2] Population, total - Mexico | Data. (s. f.). https://data.worldbank.org/indicator/SP.POP.TOTL?locations=MX
[3] https://www.inegi.org.mx/temas/estructura/
*/

/*Ejercicio 2*/
USE bank;
#--------------------------------
-- Ejercicio 2.1
#--------------------------------
SELECT * FROM customer WHERE CITY IN('Newton', 'Salem') AND CUST_TYPE_CD != 'B';

#--------------------------------
-- Ejercicio 2.2
#--------------------------------

SELECT DISTINCT STATE FROM customer WHERE FED_ID LIKE '04%';

#--------------------------------
-- Ejercicio 2.3
#--------------------------------

SELECT NAME FROM business WHERE CUST_ID%2 = 1 AND YEAR(INCORP_DATE) <= 2000;


#--------------------------------
-- Ejercicio 2.4
#--------------------------------

SELECT SUM(AMOUNT) AS Suma_montos
FROM acc_transaction
WHERE TXN_DATE BETWEEN '2002-10-01' AND '2004-09-30';


#--------------------------------
-- Ejercicio 2.5
#--------------------------------

SELECT FIRST_NAME  from employee 
WHERE TITLE IN ('Teller', 'Head Teller') 
AND START_DATE < 20030301;


/*Ejercicio 3*/
use mod_eq11;
#--------------------------------
-- Ejercicio 3.1
#--------------------------------

#¿Cuales son los clientes cuyo nombre termina en “l” y cuyo RFC termina en “0”? Muestra el nombre y el RFC
SELECT nombre,rfc FROM cliente WHERE nombre like '%l' AND RFC like '%0';

#–¿Cuales son los autos de color blanco o del año 2020? Muestra todos los datos del modelo
SELECT * FROM modelo WHERE color = "blanco" OR anio = "2020";


#--------------------------------
-- Ejercicio 3.2
#--------------------------------

#Determina cual seria la ganancia al  dia, por la rentan de todos los coches que se encuentran disponibles, crea una tabla que lo diga

SELECT CONCAT("Ganancia por dia: ", SUM(costo_por_dia)) AS Ganancias_de_coches_disponibles FROM vehiculo WHERE estado_disponible = 'YES';


#¿Cuanto se gasto en asegurar los autos en el año 2022?, crea una tabla que lo diga
SELECT CONCAT("En en este año se aseguraron los autos por un precio de: ", SUM(costo_seguro)) AS gastos_totales_en_asegurar_autos_2022 FROM seguro WHERE YEAR(fecha_inicio_vigencia) = 2022;
