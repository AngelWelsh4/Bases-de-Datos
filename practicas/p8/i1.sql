/*
=================================
BASES DE DATOS: Practica 8
Equipo 11
=================================

TEE C:\Users\Angel\Desktop\pr08_eq11.txt
*/
USE replicas;
# 1.1
DELIMITER $$
DROP function IF EXISTS semanas;
CREATE FUNCTION semanas(primerafecha date,segundafecha date)
RETURNS double(8,2) DETERMINISTIC
BEGIN
declare numSem double(8,2);
set numSem = CASE WHEN (SELECT FORMAT(ROUND((ABS(datediff(primerafecha,segundafecha)/7)),1),2)) IS NULL THEN FORMAT(-1,2) ELSE (SELECT FORMAT(ROUND((ABS(datediff(primerafecha,segundafecha)/7)),1),2)) END;
RETURN numSem;
END $$
DELIMITER ;

# 1.2
CREATE OR REPLACE VIEW v_mis_valores AS ((SELECT AVG(semanas(orderDate, shippedDate)) AS 'valores' FROM orders 
WHERE status='Shipped')UNION(SELECT MIN(semanas(orderDate, shippedDate)) FROM orders 
WHERE status='Shipped')UNION(SELECT MAX(semanas(orderDate, shippedDate)) FROM orders 
WHERE status='Shipped'));

# 1.4
DROP FUNCTION IF EXISTS fibonacci;
DELIMITER $$
CREATE FUNCTION fibonacci(n INT)
RETURNS INT DETERMINISTIC
BEGIN
DECLARE f_n INT;
DECLARE f_n1 INT;
DECLARE f_n2 INT;
DECLARE cont INT;

IF n=0 THEN
	SET f_n=0;
	SET cont=1;
	RETURN f_n;
ELSEIF n>0 THEN 
	SET f_n=1;
	SET f_n1=0;
	SET cont=2;
	WHILE (cont <= n) DO
		SET f_n2=f_n1;
		SET f_n1=f_n;
		SET f_n=f_n1+f_n2;
		SET cont=cont+1;
	END WHILE;
	RETURN f_n;
ELSE
	RETURN 0; #caso negativos
END IF;
END $$
DELIMITER ;

# Visualización de que funciona
SELECT fibonacci(0);
SELECT fibonacci(1);
SELECT fibonacci(2);
SELECT fibonacci(3);
SELECT fibonacci(4);
SELECT fibonacci(5);
SELECT fibonacci(6);
SELECT fibonacci(7);
SELECT fibonacci(8);

# 1.5
SELECT LPAD(0, ROUND(LENGTH('Número natural')/2), ' ') AS 'Número natural', 
	LPAD(FORMAT(fibonacci(0), 0), LENGTH('Término Fibonacci'), ' ') AS 'Término Fibonacci';#cadena base

(SELECT LPAD(0, ROUND(LENGTH('Número natural')/2), ' ') AS 'Número natural', 
	LPAD(FORMAT(fibonacci(0), 0), LENGTH('Término Fibonacci'), ' ') AS 'Término Fibonacci')
UNION
(SELECT LPAD(1, ROUND(LENGTH('Número natural')/2), ' '), 
	LPAD(FORMAT(fibonacci(1), 0), LENGTH('Término Fibonacci'), ' '))
UNION
(SELECT LPAD(2, ROUND(LENGTH('Número natural')/2), ' '), 
	LPAD(FORMAT(fibonacci(2), 0), LENGTH('Término Fibonacci'), ' '))
UNION
(SELECT LPAD(15, ROUND(LENGTH('Número natural')/2), ' '), 
	LPAD(FORMAT(fibonacci(15), 0), LENGTH('Término Fibonacci'), ' '))
UNION
(SELECT LPAD(46, ROUND(LENGTH('Número natural')/2), ' '), 
	LPAD(FORMAT(fibonacci(46), 0), LENGTH('Término Fibonacci'), ' '));
	
# 1.3
/*
SELECT city, COUNT(employeenumber) AS 'empleados'
FROM employees
NATURAL JOIN offices
GROUP BY officecode; #primera parte

SELECT o1.city AS 'city', semanas(orderDate, shippedDate) AS 'semanas'
FROM orders AS o
	JOIN customers AS c ON o.customerNumber=c.customernumber
	JOIN employees AS e ON salesrepemployeenumber=employeenumber
	JOIN offices AS o1 USING(officecode)
WHERE status='Shipped';
	
CREATE OR REPLACE VIEW v_semanas_por_orden AS (SELECT o1.city AS 'city', 
	semanas(orderDate, shippedDate) AS 'semanas'
FROM orders AS o
	JOIN customers AS c ON o.customerNumber=c.customernumber
	JOIN employees AS e ON salesrepemployeenumber=employeenumber
	JOIN offices AS o1 USING(officecode)
WHERE status='Shipped');

SELECT city, AVG(semanas) AS 'semprom'
FROM v_semanas_por_orden
GROUP BY city
ORDER BY AVG(semanas) DESC; #segunda parte

SELECT ROUND(AVG(semanas), 2) 
FROM v_semanas_por_orden; #prom ordenes enviadas

*/
CREATE OR REPLACE VIEW v_semanas_por_orden AS (SELECT o1.city AS 'city', 
	semanas(orderDate, shippedDate) AS 'semanas'
FROM orders AS o
	JOIN customers AS c ON o.customerNumber=c.customernumber
	JOIN employees AS e ON salesrepemployeenumber=employeenumber
	JOIN offices AS o1 USING(officecode)
WHERE status='Shipped'); #vista necesaria

SELECT UCASE(city) AS 'Ciudad', empleados AS '# empleados', 
	LPAD(CONCAT('->', ROUND(semprom, 2), '<-'), (LOCATE('n', '# semanas promedio'))+7, ' ') AS '# semanas promedio',
	CASE 
		WHEN semprom>(SELECT ROUND(AVG(semanas), 2) FROM v_semanas_por_orden) THEN 'ALERTA'
		ELSE 'OK'
	END AS 'Aviso'
FROM (SELECT city, COUNT(employeenumber) AS 'empleados'
		FROM employees
		NATURAL JOIN offices
		GROUP BY officecode) AS sub1
	NATURAL JOIN (SELECT city, AVG(semanas) AS 'semprom'
		FROM v_semanas_por_orden
		GROUP BY city) AS sub2
ORDER BY ROUND(semprom, 2) DESC, LENGTH(city);

# 1.6
DROP FUNCTION IF EXISTS cuenta_vocales;
DELIMITER $$
CREATE FUNCTION cuenta_vocales(c VARCHAR(50))
RETURNS INT DETERMINISTIC
BEGIN
DECLARE n_vocales INT;
DECLARE cont INT;
SET n_vocales=0;
SET cont=0;

WHILE (cont<=LENGTH(c)) DO
	IF LCASE(SUBSTR(c, cont, 1)) REGEXP '[aeiou]|[áéíóú]|[äëïöü]'=1 THEN
		SET n_vocales=n_vocales+1;
	END IF;
	SET cont=cont+1;
END WHILE;
RETURN n_vocales;
END $$
DELIMITER ;

(SELECT 'Sofía' AS 'PALABRA', cuenta_vocales('Sofía') AS 'VOCALES')
UNION
(SELECT 'PARAGÜAS', cuenta_vocales('PARAGÜAS'))
UNION
(SELECT 'murciélago', cuenta_vocales('murciélago'))
UNION
(SELECT 'Luis Agustín Joaquín', cuenta_vocales('Luis Agustín Joaquín'))
UNION
(SELECT "gatito hace 'MiAUaëaA'", cuenta_vocales("gatito hace 'MiAUaëaA'"));

# extra 1
DROP FUNCTION IF EXISTS lim_fibonacci;
DELIMITER $$
CREATE FUNCTION lim_fibonacci(i INT UNSIGNED)
RETURNS TEXT DETERMINISTIC
BEGIN
DECLARE salida VARCHAR(200);
DECLARE cont INT;
DECLARE a_n1 INT; 
DECLARE a_n INT;
DECLARE lim DECIMAL(11,10); #aquí se le puede modificar los decimales
DECLARE n_aureo DECIMAL(11,10); #en ambos números va dado por la cantidad máxima de i a usar (10 max para este ejemplo)
DECLARE epsilon DECIMAL(11,10);
SET cont=0;
SET lim=0.0000000000;
SET n_aureo=1.6180339887;
SET epsilon=0.9*POW(10, -i);

WHILE (ABS(n_aureo-lim)>epsilon) DO 
	SET a_n=fibonacci(cont+1);
	SET a_n1=fibonacci(cont+2);
	SET lim=a_n1/a_n;
	SET cont=cont+1;
END WHILE;

IF i<>1 THEN
	SET salida=CONCAT('lim_fibonacci(', i, '): Para n = ', cont, ' la sucesión an+1 / an = ', lim, ' aproxima al límite φ = ',
	1.6180339887,  ' con una precisión de  ', i, ' dígitos decimales.' );
	RETURN salida;
ELSE
	SET salida=CONCAT('lim_fibonacci(', i, '): Para n = ', cont, ' la sucesión an+1 / an = ', lim, ' aproxima al límite φ = ',
	1.6180339887,  ' con una precisión de  ', i, ' dígito decimal.' );
	RETURN salida;
END IF;
END $$
DELIMITER ;


SELECT lim_fibonacci(0), lim_fibonacci(1), lim_fibonacci(2),
	lim_fibonacci(3), lim_fibonacci(8), lim_fibonacci(9);