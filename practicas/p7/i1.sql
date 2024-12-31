/*
borrar
TEE C:\Users\Angel\Desktop\.txt

*/

/*
=================================
Práctica 7: Joins
Nombre: Ocampo García Victor Emmanuel Miguel Ángel
Fecha: 05-05-23
=================================
*/

/* SOURCE C:\Users\Angel\Desktop\base_replicas.sql 
*/
# 2.2
/*
SELECT customernumber 
FROM payments
GROUP BY 1
HAVING sum(amount)>200000; #id de las empresas que han gastado más de 200000

SELECT customernumber
FROM customers
WHERE city LIKE 'P%'; #id de las empresas localizadas en una ciudad que empieza con P

#intentos de obtener el gasto de las empresas del query anterior

SELECT customernumber, CASE 
	WHEN sum(amount) IS NOT NULL THEN sum(amount)
	ELSE 0
	END AS 'sum(amount)' 
FROM customers
	NATURAL JOIN payments
WHERE city LIKE 'P%'
GROUP BY customernumber; #intento1 (fallido, el otro registro no hace coincidencia)

SELECT customernumber, CASE 
	WHEN monto IS NOT NULL THEN monto
	ELSE 0
	END AS 'sum(amount)'
FROM 
	(SELECT customernumber
	FROM customers
	WHERE city LIKE 'P%') AS t1
	LEFT JOIN 
	(SELECT customernumber, sum(amount) AS 'monto'
	FROM payments
	GROUP BY 1
	ORDER BY sum(amount) DESC) AS t2
	USING(customernumber); #intento2 (sale)

(SELECT customernumber, sum(amount) AS 'monto' 
FROM payments
GROUP BY 1
HAVING sum(amount)>200000)
UNION
(SELECT customernumber, CASE 
	WHEN monto2 IS NOT NULL THEN monto2
	ELSE 0
	END AS 'monto'
FROM 
	(SELECT customernumber
	FROM customers
	WHERE city LIKE 'P%') AS t1
	LEFT JOIN 
	(SELECT customernumber, sum(amount) AS 'monto2'
	FROM payments
	GROUP BY 1
	ORDER BY sum(amount) DESC) AS t2
	USING(customernumber))
ORDER BY 2 DESC; #unimos ambas condiciones

SELECT customername AS 'nombre-empresa', c.city AS 'ciudad-empresa', monto AS 'gasto-empresa',
	CONCAT(firstname, ' ', lastname) AS 'representante-venta', o.postalcode AS 'CP-oficina'
FROM ((SELECT customernumber, sum(amount) AS 'monto' 
	FROM payments
	GROUP BY 1
	HAVING sum(amount)>200000)
	UNION
	(SELECT customernumber, CASE 
		WHEN monto2 IS NOT NULL THEN monto2
		ELSE 0
		END AS 'monto'
	FROM 
		(SELECT customernumber
		FROM customers
		WHERE city LIKE 'P%') AS t1
		LEFT JOIN 
		(SELECT customernumber, sum(amount) AS 'monto2'
		FROM payments
		GROUP BY 1
		ORDER BY sum(amount) DESC) AS t2
		USING(customernumber))
	ORDER BY 2 DESC) AS subconsulta
	NATURAL JOIN customers AS c
	LEFT JOIN employees ON salesrepemployeenumber=employeenumber
	LEFT JOIN offices AS o USING (officecode) 
;#Se hacen los respectivos joins (acorde a los datos) conservando el núm. de registros originales

SELECT customername AS 'nombre-empresa', c.city AS 'ciudad-empresa', 
	CONCAT('$', FORMAT(monto, 2)) AS 'gasto-empresa',
	CASE 
		WHEN CONCAT(firstname, ' ', lastname) IS NULL THEN '-'
		ELSE CONCAT(firstname, ' ', lastname)
		END AS 'representante-venta', 
	CASE 
		WHEN o.postalcode IS NULL THEN '-'
		ELSE o.postalcode 
		END AS 'CP-oficina'
FROM ((SELECT customernumber, sum(amount) AS 'monto' 
	FROM payments
	GROUP BY 1
	HAVING sum(amount)>200000)
	UNION
	(SELECT customernumber, CASE 
		WHEN monto2 IS NOT NULL THEN monto2
		ELSE 0
		END AS 'monto'
	FROM 
		(SELECT customernumber
		FROM customers
		WHERE city LIKE 'P%') AS t1
		LEFT JOIN 
		(SELECT customernumber, sum(amount) AS 'monto2'
		FROM payments
		GROUP BY 1
		ORDER BY sum(amount) DESC) AS t2
		USING(customernumber))
	ORDER BY 2 DESC) AS subconsulta
	NATURAL JOIN customers AS c
	LEFT JOIN employees ON salesrepemployeenumber=employeenumber
	LEFT JOIN offices AS o USING (officecode) 
; #dándole formato
*/
SELECT customername AS 'nombre-empresa', c.city AS 'ciudad-empresa', 
	CONCAT('$', FORMAT(monto, 2)) AS 'gasto-empresa',
	CASE 
		WHEN CONCAT(firstname, ' ', lastname) IS NULL THEN '-'
		ELSE CONCAT(firstname, ' ', lastname)
		END AS 'representante-venta', 
	CASE 
		WHEN o.postalcode IS NULL THEN '-'
		ELSE o.postalcode 
		END AS 'CP-oficina'
FROM ((SELECT customernumber, sum(amount) AS 'monto' 
	FROM payments
	GROUP BY 1
	HAVING sum(amount)>200000)
	UNION
	(SELECT customernumber, CASE 
		WHEN monto2 IS NOT NULL THEN monto2
		ELSE 0
		END AS 'monto'
	FROM 
		(SELECT customernumber
		FROM customers
		WHERE city LIKE 'P%') AS t1
		LEFT JOIN 
		(SELECT customernumber, sum(amount) AS 'monto2'
		FROM payments
		GROUP BY 1
		ORDER BY sum(amount) DESC) AS t2
		USING(customernumber))
	ORDER BY 2 DESC) AS subconsulta
	NATURAL JOIN customers AS c
	LEFT JOIN employees ON salesrepemployeenumber=employeenumber
	LEFT JOIN offices AS o USING (officecode) 
;
/*
SOURCE C:\Users\Angel\Desktop\base_biblioteca.sql
*/ 
# Extra
/*
SELECT *
FROM libro_x_autor
	LEFT JOIN libro_x_autor AS t2 USING (id_libro);
*/