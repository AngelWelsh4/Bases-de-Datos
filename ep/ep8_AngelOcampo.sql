/*
=================================
Ejercicio de participación 8: Vistas y funciones
Nombre: Ocampo García Victor Emmanuel Miguel Ángel
Fecha: 15-05-23
=================================
*/
# 1.
USE collectionhw;

CREATE OR REPLACE VIEW v_autos3erTrim AS (SELECT sku, nombre, series, precio, color, modelo, 
	fechaCompra AS 'fechacompra'
FROM carritosAOG
WHERE (modelo BETWEEN 2006 AND 2010) AND QUARTER(fechaCompra)=3 AND YEAR(fechaCompra)=2020
ORDER BY modelo);

SELECT * FROM v_autos3erTrim;

# 2.
CREATE OR REPLACE VIEW v_reporte2 AS (SELECT MONTHNAME(fechacompra) AS 'mes', 
	COUNT(sku) AS 'Total carritos2010'
FROM v_autos3erTrim
WHERE modelo=2010
GROUP BY MONTHNAME(fechacompra)
ORDER BY MONTH(fechacompra));

SELECT * FROM v_reporte2;

# 3.
CREATE OR REPLACE VIEW v_reporte3 AS (SELECT MONTHNAME(fechacompra) AS 'mes', 
	COUNT(sku) AS 'Total carritos azules'
FROM v_autos3erTrim
WHERE color LIKE '%Blue%'
GROUP BY MONTHNAME(fechacompra)
ORDER BY MONTH(fechacompra));

SELECT * FROM v_reporte3;

# 4.
CREATE OR REPLACE VIEW v_reporte4  AS (SELECT fechacompra AS 'fechaCompra', 
	COUNT(sku) AS 'Total carritos comprados por día'
FROM v_autos3erTrim
WHERE MONTH(fechacompra)=8
GROUP BY fechacompra
ORDER BY fechacompra);

SELECT * FROM v_reporte4;

# 5.
DROP FUNCTION IF EXISTS compara;
DELIMITER //
CREATE FUNCTION compara(x INT, y INT)
RETURNS TEXT
READS SQL DATA DETERMINISTIC
BEGIN
	DECLARE salida VARCHAR(50); #número aproximado de caracteres
	IF x<y THEN
		SET salida=CONCAT('el numero x=', x, ' es menor que y=', y);
	ELSEIF x>y THEN
		SET salida=CONCAT('el numero x=', x, ' es mayor que y=', y);
	ELSE 
		SET salida=CONCAT('el numero x=', x, ' es igual que y=', y);
	END IF;
	RETURN salida;
END;
//
DELIMITER ;

SELECT compara(4, 15);
SELECT compara(4, 1);
SELECT compara(5, 5);
SELECT compara(-152, 37.8); #ejemplo con negativos y flotantes
