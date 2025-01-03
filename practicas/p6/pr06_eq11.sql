
/*
=================================
BASES DE DATOS: Practica 6
Equipo 11
=================================
*/

# Ejercicio 0
#0.1
PROMPT \Y E Q U I P O 11 (\d)\S

# Ejercicio 1
USE hostal
#1.1

SELECT CONCAT('Tipo ', id_tipo_empleado) AS 'Tipo empleado', FORMAT(COUNT(id_empleado), 0) AS 'Número de empleados' 
     FROM empleado 
     GROUP BY 1 
     HAVING COUNT(id_empleado)>=5 
     ORDER BY 2 DESC;

#1.2
SELECT UCASE(SUBSTRING(apellido, 1, 1)) AS 'Letra', COUNT(id_cliente) AS 'Total de clientes cuyo apellido empieza con esa letra'
     FROM cliente 
     GROUP BY 1 
     ORDER BY 2 DESC;

#1.3
SELECT CONCAT('Tipo ', id_tipo_habitacion) AS 'Tipo de habitación', CONCAT(COUNT(id_habitacion), ' habitaciones') AS 'Número de habitaciones' 
     FROM habitacion 
     GROUP BY 1 
     HAVING COUNT(id_habitacion)=
     	(SELECT MAX(Numero) 
     		FROM (SELECT id_tipo_habitacion AS Tipo, COUNT(id_habitacion) AS Numero 
     				FROM habitacion GROUP BY 1
     				) AS subconsulta
     	);
#1.4
SELECT Año,Trimestre,COUNT(*) AS Total FROM (SELECT DATE_FORMAT(fecha_salida, '%y') AS Año, 
         CASE 
           WHEN MONTH(fecha_salida) BETWEEN 1 AND 3 THEN 'Primer trimestre'
           WHEN MONTH(fecha_salida) BETWEEN 4 AND 6 THEN 'Segundo trimestre'
           WHEN MONTH(fecha_salida) BETWEEN 7 AND 9 THEN 'Tercer trimestre'
           ELSE 'Cuarto trimestre' END AS Trimestre FROM estancia) AS subconsulta
     WHERE Año IN (SELECT (DATE_FORMAT(fecha_salida, '%y')) FROM estancia) GROUP BY Año, Trimestre
     HAVING COUNT(*) > 3 ORDER BY Año DESC, CASE Trimestre 
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

#Ejercicio 2
USE sakila
#2.1
SELECT category_id, name 
     FROM category
     WHERE category_id IN
     	(SELECT category_id 
     	FROM film_category 
     	GROUP BY 1
     	HAVING COUNT(film_id) BETWEEN 65 AND 75)
    	AND name!='Sports';
#2.2
SELECT YEAR(payment_date) AS 'Año', MONTHNAME(payment_date) AS 'Mes', AVG(amount) AS 'Pago promedio por renta de una película'
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
#2.3
SELECT postal_code, district
     FROM address 
     WHERE postal_code 
     LIKE '22%' AND LENGTH(postal_code)=5 AND (address2 IS NULL OR address2 LIKE '')
     ORDER BY 1;# address es no nula, por lo que basta con fijarse en address2
#2.4
SELECT CONCAT(SUBSTRING(first_name, 1, 1),
      LCASE(SUBSTRING(first_name, 2)),
      ' ', SUBSTRING(last_name, 1, 1),
      LCASE(SUBSTRING(last_name, 2))) AS 'nombre', 
      LCASE(email) AS 'email' 
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
     	)
 ORDER BY 1;
 #2.5
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
     				HAVING SUM(amount)>170
     				)
     			)
     		)
     	);
# Ejercicios Extra
USE pixup
#1
SELECT nombre AS 'disquera', LENGTH(nombre) AS 'num_caracteres', 
     	ROUND((RAND(11) * (LENGTH(nombre) - 1)) + 1) AS 'num_random',
     	CONCAT(SUBSTRING(nombre, 1, ROUND((RAND(11) * (LENGTH(nombre) - 1)) + 1)), '!', 
     		SUBSTRING(nombre, ROUND((RAND(11) * (LENGTH(nombre) - 1)) + 1)+1, LENGTH(nombre))) AS 'resultado' 
     FROM disquera
     WHERE LENGTH(nombre)>
     	(
     	(SELECT AVG(LENGTH(nombre)) 
     	FROM disquera)+
     	(SELECT STDDEV(LENGTH(nombre)) 
     	FROM disquera)
     	);
USE world_x
#2
