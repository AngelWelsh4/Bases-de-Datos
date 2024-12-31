/*
TEE C:\Users\Angel\Desktop\i1f.txt

Práctica 06-Equipo11
*/
# Ejercicio 0
# 0.1
PROMPT \Y E Q U I P O 11 (\d)\S

# Ejercicio 1
# 1.1
USE hostal;
/* SOURCE C:\Users\Angel\Desktop\base_hostal.sql 
DESC empleado;
*/
SELECT CONCAT('Tipo ', id_tipo_empleado) AS 'Tipo empleado', FORMAT(COUNT(id_empleado), 0) AS 'Número de empleados' 
FROM empleado 
GROUP BY 1 
HAVING COUNT(id_empleado)>=5 
ORDER BY 2 DESC;
# 1.2
/* DESC cliente; 
*/
SELECT UCASE(SUBSTRING(apellido, 1, 1)) AS 'Letra', 
	COUNT(id_cliente) AS 'Total de clientes cuyo apellido empieza con esa letra'
FROM cliente 
GROUP BY 1 
ORDER BY 2 DESC;
# 1.3
/* DESC habitacion;

SELECT MAX(Numero) AS 'Número de habitaciones' 
FROM (SELECT id_tipo_habitacion AS Tipo, COUNT(id_habitacion) AS Numero 
		FROM habitacion 
		GROUP BY 1
		) AS R; #el máximo del número de habitaciones
*/
SELECT CONCAT('Tipo ', id_tipo_habitacion) AS 'Tipo de habitación', 
	CONCAT(COUNT(id_habitacion), ' habitaciones') AS 'Número de habitaciones' 
FROM habitacion 
GROUP BY 1 
HAVING COUNT(id_habitacion)=
	(SELECT MAX(Numero) 
	FROM (SELECT id_tipo_habitacion AS Tipo, COUNT(id_habitacion) AS Numero 
		FROM habitacion 
		GROUP BY 1) AS subconsulta);
# 1.4
/* DESC estancia;
*/
SELECT Año, Trimestre, COUNT(*) AS Total 
FROM (SELECT DATE_FORMAT(fecha_salida, '%y') AS Año, 
    CASE 
      WHEN MONTH(fecha_salida) BETWEEN 1 AND 3 THEN 'Primer trimestre'
      WHEN MONTH(fecha_salida) BETWEEN 4 AND 6 THEN 'Segundo trimestre'
      WHEN MONTH(fecha_salida) BETWEEN 7 AND 9 THEN 'Tercer trimestre'
      ELSE 'Cuarto trimestre' END AS Trimestre FROM estancia) AS subconsulta
WHERE Año IN (SELECT (DATE_FORMAT(fecha_salida, '%y')) FROM estancia) 
GROUP BY Año, Trimestre
HAVING COUNT(*) > 3 
ORDER BY Año DESC, CASE Trimestre 
    WHEN 'Primer trimestre' THEN 1 
    WHEN 'Segundo trimestre' THEN 2 
    WHEN 'Tercer trimestre' THEN 3 
    ELSE 4 
    END ASC;
#1.5
SELECT DATE_FORMAT(fecha_salida, '%y') AS 'Año', CASE 
	WHEN MONTH(fecha_salida) IN (1,2,3) THEN 'Primer trimestre'
	WHEN MONTH(fecha_salida) IN (4,5,6) THEN 'Segundo trimestre'
	WHEN MONTH(fecha_salida) IN (7,8,9) THEN 'Tercer trimestre'
	ELSE 'Cuarto trimestre'
	END AS 'Trimestre', COUNT(id_estancia) AS 'Total' 
FROM estancia
GROUP BY 1,2
HAVING COUNT(id_estancia)>3
ORDER BY 1 DESC, MONTH(fecha_salida);

# Ejercicio 2
# 2.1
USE sakila;
/*
SOURCE C:\Users\Angel\Desktop\base_sakila.sql 

SELECT category_id, COUNT(film_id) 
FROM film_category 
GROUP BY 1
HAVING COUNT(film_id) BETWEEN 65 AND 75;#category_id, num de pelis de las categorias entre 65 y 75 pelis

SELECT category_id, name 
FROM category
WHERE category_id IN
	(SELECT category_id 
	FROM film_category 
	GROUP BY 1
	HAVING COUNT(film_id) BETWEEN 65 AND 75);#de lo anterior seleccionamos las categorías que entran 
	#en la anterior consulta
*/
SELECT category_id, name 
FROM category
WHERE category_id IN
	(SELECT category_id 
	FROM film_category 
	GROUP BY 1
	HAVING COUNT(film_id) BETWEEN 65 AND 75)
	AND name!='Sports';#quitando el de deportes
# 2.2
/*
SELECT YEAR(payment_date), MONTHNAME(payment_date), AVG(amount)
FROM payment
GROUP BY 1, 2; #pago promedio por mes

SELECT MIN(amount), payment_date 
FROM payment; #minimo pago registrado

SELECT AVG(amount)
FROM payment; #pago promedio global

SELECT YEAR(payment_date), MONTHNAME(payment_date), AVG(amount)
FROM payment
GROUP BY 1, 2
HAVING AVG(amount)>
	(SELECT MIN(amount) 
	FROM payment
	)
	AND AVG(amount)<
	(SELECT AVG(amount)
	FROM payment
	)
ORDER BY 1 DESC, MONTH(payment_date) DESC;
*/
SELECT Año, Mes
FROM
	(SELECT YEAR(payment_date) AS 'Año', MONTHNAME(payment_date) AS 'Mes', 
		AVG(amount) AS 'Pago promedio por renta de una película'
	FROM payment
	GROUP BY 1, 2
	HAVING AVG(amount)>
		(SELECT MIN(amount) 
		FROM payment)
	AND AVG(amount)<
		(SELECT AVG(amount)
		FROM payment)
	ORDER BY 1 DESC, MONTH(payment_date) DESC) AS base;
# 2.3
/*
SELECT postal_code 
FROM address 
WHERE postal_code 
LIKE '22%' AND LENGTH(postal_code)=5; #cp que empiezan con 22, con 5 dígitos

SELECT postal_code
FROM address
GROUP BY 1
HAVING COUNT(postal_code)=1; #cp con una sola direccion registrada
*/
SELECT postal_code, district 
FROM address 
WHERE postal_code 
LIKE '22%' AND LENGTH(postal_code)=5
GROUP BY 1
HAVING COUNT(postal_code)=1
ORDER BY 1; #sin subconsulta

SELECT postal_code, district 
FROM 
	(SELECT postal_code, district
	FROM address
	GROUP BY 1
	HAVING COUNT(postal_code)=1) AS subconsulta
WHERE postal_code 
LIKE '22%' AND LENGTH(postal_code)=5
ORDER BY 1; #con subconsulta
# 2.4
/*
SELECT CONCAT(first_name, ' ', last_name) AS 'nombre', email 
FROM customer
WHERE SUBSTRING(first_name, 1, 1) IN ('A','E','I','O','U'); #primera letra del nombre de pila con vocal (83r)

SELECT address_id
FROM address
WHERE district NOT LIKE '% %' AND district NOT LIKE ''; #address_id de los distritos de una única palabra (444r)

SELECT CONCAT(first_name, ' ', last_name) AS 'nombre', email 
FROM customer
WHERE SUBSTRING(first_name, 1, 1) IN ('A','E','I','O','U') AND address_id IN 
	(SELECT address_id
	FROM address
	WHERE district NOT LIKE '% %' AND district NOT LIKE '' #unimos lo anterior
	); (59r)

SELECT customer_id
FROM rental
WHERE return_date IS NULL; #No hay return_date tipo '' (183r)

SELECT CONCAT(first_name, ' ', last_name) AS 'nombre', email 
FROM customer
WHERE SUBSTRING(first_name, 1, 1) IN ('A','E','I','O','U') AND address_id IN 
	(SELECT address_id
	FROM address
	WHERE district NOT LIKE '% %' AND district NOT LIKE '' #unimos lo anterior
	)
	AND customer_id IN
	(SELECT customer_id
	FROM rental
	WHERE return_date IS NULL
	); #uniendo lo anterior
*/
SELECT CONCAT(SUBSTRING(first_name, 1, 1), LCASE(SUBSTRING(first_name, 2)), ' ', SUBSTRING(last_name, 1, 1),
	LCASE(SUBSTRING(last_name, 2))) AS 'nombre', LCASE(email) AS 'email' 
FROM customer
WHERE SUBSTRING(first_name, 1, 1) IN ('A','E','I','O','U') AND address_id IN 
	(SELECT address_id
	FROM address
	WHERE district NOT LIKE '% %' AND district NOT LIKE '')#unimos lo anterior
	AND customer_id IN
	(SELECT customer_id
	FROM rental
	WHERE return_date IS NULL)
ORDER BY 1;
# 2.5
/*
SELECT customer_id #, SUM(amount)
FROM payment
GROUP BY 1
HAVING SUM(amount)>170; #customer_id de clientes que han gastado más de 170$ en pelis (11r)

SELECT address_id
FROM customer
WHERE customer_id IN
	(SELECT customer_id
	FROM payment
	GROUP BY 1
	HAVING SUM(amount)>170
	); #address_id de clientes que han gastado más de 170$ en pelis (11r)
	
SELECT city_id
FROM address
WHERE address_id IN
	(SELECT address_id
	FROM customer
	WHERE customer_id IN
		(SELECT customer_id
		FROM payment
		GROUP BY 1
		HAVING SUM(amount)>170
		)
	); #city_id de clientes que han gastado más de 170$ en pelis (11r)

SELECT country_id
FROM city
WHERE city_id IN
	(SELECT city_id
	FROM address
	WHERE address_id IN
		(SELECT address_id
		FROM customer
		WHERE customer_id IN
			(SELECT customer_id
			FROM payment
			GROUP BY 1
			HAVING SUM(amount)>170
			)
		)
	); #country_id de clientes que han gastado más de 170$ en pelis (11r)

SELECT country
FROM country
WHERE country_id IN
	(SELECT country_id
	FROM city
	WHERE city_id IN
		(SELECT city_id
		FROM address
		WHERE address_id IN
			(SELECT address_id
			FROM customer
			WHERE customer_id IN
				(SELECT customer_id
				FROM payment
				GROUP BY 1
				HAVING SUM(amount)>170
				)
			)
		)
	); #pais en el que viven los clientes que han gastado más de 170$ en pelis (10r)
*/
SELECT country AS 'Países de residencia de clientes cuyo gasto total es > 170 dólares'
FROM country
WHERE country_id IN
	(SELECT country_id
	FROM city
	WHERE city_id IN
		(SELECT city_id
		FROM address
		WHERE address_id IN
			(SELECT address_id
			FROM customer
			WHERE customer_id IN
				(SELECT customer_id
				FROM payment
				GROUP BY 1
				HAVING SUM(amount)>170))));

# Ejercicios extras
# 1
USE pixup;
/*
SELECT ROUND((RAND(11) * (LENGTH(nombre) - 1)) + 1) AS 'aleatorio'
FROM disquera 
LIMIT 5; #num aleatorio entero con semilla 11

SELECT nombre, SUBSTRING(nombre, 1, ROUND((RAND(11) * (LENGTH(nombre) - 1)) + 1)) AS 'primera parte',
	ROUND((RAND(11) * (LENGTH(nombre) - 1)) + 1) AS 'aleatorio' 
FROM disquera 
LIMIT 5; #primera parte del nombre

SELECT nombre, SUBSTRING(nombre, ROUND((RAND(11) * (LENGTH(nombre) - 1)) + 1)+1, LENGTH(nombre)) AS 'segunda parte',
	ROUND((RAND(11) * (LENGTH(nombre) - 1)) + 1) AS 'aleatorio' 
FROM disquera 
LIMIT 5; #segunda parte del nombre

SELECT nombre AS 'disquera', LENGTH(nombre) AS 'num_caracteres', 
	ROUND((RAND(11) * (LENGTH(nombre) - 1)) + 1) AS 'num_random' 
FROM disquera
WHERE LENGTH(nombre)>
	(
	(SELECT AVG(LENGTH(nombre)) 
	FROM disquera)+
	(SELECT STDDEV(LENGTH(nombre)) 
	FROM disquera)
	); #primeras 3 columnas
*/	
SELECT nombre AS 'disquera', LENGTH(nombre) AS 'num_caracteres', 
	ROUND((RAND(11) * (LENGTH(nombre) - 1)) + 1) AS 'num_random',
	CONCAT(SUBSTRING(nombre, 1, ROUND((RAND(11) * (LENGTH(nombre) - 1)) + 1)), '!', 
		SUBSTRING(nombre, ROUND((RAND(11) * (LENGTH(nombre) - 1)) + 1)+1, LENGTH(nombre))) AS 'resultado' 
FROM disquera
WHERE LENGTH(nombre)>
	((SELECT AVG(LENGTH(nombre)) FROM disquera)+(SELECT STDDEV(LENGTH(nombre)) FROM disquera));
# 2
/*
SOURCE C:\Users\Angel\Desktop\base_world_x.sql
USE world_x;

SELECT Name, Code, Capital 
FROM country
WHERE Code LIKE '_J%' OR (Capital IS NULL)=1; #1er cond (11r)

SELECT Capital IS NULL AS 'bandera' FROM country; #las banderas

SELECT CountryCode, COUNT(Language) 
FROM countrylanguage 
GROUP BY 1; #cuantos lenguajes se hablan en cada país

SELECT CountryCode, COUNT(Language) 
FROM countrylanguage
WHERE CountryCode IN 
	(SELECT Code
	FROM country
	WHERE Code LIKE '_J%' OR (Capital IS NULL)=1
	)
GROUP BY 1;

NOTEE
*/