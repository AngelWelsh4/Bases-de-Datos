/*
borrar

TEE C:\Users\Angel\Desktop\ep4_AngelOcampo.txt

PROMPT (AngelOcampo en: \d \\\D) mysql>

*/

/*
=================================
Ejercicio de participación 4: Update
Nombre: Ocampo García Victor Emmanuel Miguel Ángel
Fecha: 25-04-23
=================================
*/

/* SOURCE C:\Users\Angel\Desktop\20_collectionHW.sql 
*/
USE collectionhw;
# 1.
DROP TABLES IF EXISTS carritosAOG;
CREATE TABLE IF NOT EXISTS carritosAOG AS SELECT * FROM carritos;
# 2.
SELECT DISTINCT color FROM carritosAOG ORDER BY 1;
# 3.
/*  SELECT DISTINCT SUBSTRING(color, LENGTH('Mtflk. _'), LENGTH(color)) 
	FROM carritosAOG 
	WHERE color 
	LIKE 'Mtflk.%'; #porque queremos que el substring tome desde '_'
*/
UPDATE carritosAOG 
SET color=SUBSTRING(color, LENGTH('Mtflk. _'), LENGTH(color)) 
WHERE color LIKE 'Mtflk.%';

UPDATE carritosAOG 
SET color=SUBSTRING(color, LENGTH('Satin _'), LENGTH(color)) 
WHERE color LIKE 'Satin%';

UPDATE carritosAOG 
SET color=SUBSTRING(color, LENGTH('Spectraflame _'), LENGTH(color)) 
WHERE color LIKE 'Spectraflame%';
# 4.
SELECT DISTINCT color FROM carritosAOG ORDER BY 1;
# 5.
UPDATE carritosAOG 
SET ubicacion='Perisur' 
WHERE ubicacion IS NULL 
	AND color='Red' 
	AND (series LIKE '%Stars%' OR series LIKE '%Racers%' OR series LIKE '%Muscle%');
# 6.
UPDATE carritosAOG
SET notas=CONCAT(modelo, ' modelo corregido'), modelo=SUBSTRING(nombre, 1, 4)*1
WHERE nombre LIKE '19__ %' OR nombre LIKE '20__ %'; 
/*
comprobación
SELECT nombre, modelo, color, notas 
FROM carritosAOG 
WHERE nombre LIKE '19__ %' OR nombre LIKE '20__ %'
ORDER BY 2, 1;
*/
# 7.
ALTER TABLE carritosAOG
ADD precioNuevo DECIMAL(10,2) DEFAULT 0.0 
AFTER precio;
# 8.
SELECT nombre, modelo, precio, precioNuevo FROM carritosAOG LIMIT 10;
# 9.
UPDATE carritosAOG
SET precioNuevo=precio*(1-.25)
WHERE modelo=2012;
UPDATE carritosAOG
SET precioNuevo=precio*(1-.20)
WHERE modelo=2019;
UPDATE carritosAOG
SET precioNuevo=precio*(1-.10)
WHERE modelo=2010 OR modelo=2013 OR modelo=2020;
# 10.
SELECT modelo, COUNT(*) AS 'Total de carritos' 
FROM carritosAOG
GROUP BY 1
ORDER BY 2 DESC;
# 11.
SELECT nombre, modelo, precio, ROUND(precioNuevo, 1) AS 'precio con descuento', ROUND(precio-precioNuevo, 1) AS 'cantidad descontada',
ROUND(((precio-precioNuevo)/precio)*100, 0) AS '% de descuento' 
FROM carritosAOG
WHERE precioNuevo!=0.0
ORDER BY 2;
# 12.
SELECT modelo, COUNT(*) AS 'Total de carritos', 
	LPAD(FORMAT(SUM(precio), 1), LENGTH('Venta Total'), ' ') AS 'Venta total', 
	CASE 
		WHEN precioNuevo=0.0 THEN LPAD(FORMAT(SUM(precio), 1), LENGTH('Venta con descuento'), ' ') 
		ELSE LPAD(FORMAT(SUM(precioNuevo), 1), LENGTH('Venta con descuento'), ' ')
		END AS 'Venta con descuento', 
	CASE 
		WHEN precioNuevo=0.0 THEN LPAD(0.0, LENGTH('Cantidad descontada'), ' ')
		ELSE LPAD(FORMAT((SUM(precio)-SUM(precioNuevo)), 1), LENGTH('Cantidad descontada'), ' ') 
		END AS 'Cantidad descontada'
FROM carritosAOG
GROUP BY 1
ORDER BY 1;
# 13.
SELECT COUNT(*) FROM carritosAOG;