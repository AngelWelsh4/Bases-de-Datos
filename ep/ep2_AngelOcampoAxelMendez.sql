/*
=================================
Ejercicio de participación 2: Funciones de agregación
Nombre:Ocampo Garcia Victor Emmanuel Miguel Angel
    Mendez Lopez Pedro Axel
Fecha: 17-04-23
=================================
# SOURCE 16_pixupDatos8.0_final.sql
*/

-- Ejercicio 1: Reporte de cuantos títulos fueron lanzados por año, ordenado por año descendentemente.
SELECT YEAR(fecha_lanzamiento) AS 'Año', COUNT(titulo) AS 'Discos lanzados' 
FROM disco 
GROUP BY 1 
ORDER BY 1 DESC;

-- Ejercicio 2: Reporte de cantidad de discos lanzados por año solo de los años con lanzamientos de más de 10 discos, ordenado por esa cantidad descendente.
SELECT YEAR(fecha_lanzamiento) AS 'Año', COUNT(titulo) AS 'Total de discos lanzados' 
FROM disco 
GROUP BY 1 
HAVING COUNT(titulo)>10 
ORDER BY 2 DESC;

-- Ejercicio 3: Reporte por año y por mes indicando el nombre del mes, de la cantidad de discos disponibles, ordenado por año descendente y por mes ascendente.
SELECT YEAR(fecha_lanzamiento) AS 'Año', MONTHNAME(fecha_lanzamiento) AS 'Mes',
	SUM(cantidad_disponible) AS 'Cantidad disponible' 
FROM disco GROUP BY 1, 2 
ORDER BY 1 DESC, MONTH(fecha_lanzamiento) ASC;

-- -- Ejercicio 4: Reporte trimestral por año de la cantidad de discos disponibles, ordenado por año y por trimestre. 
SELECT YEAR(fecha_lanzamiento) AS 'Año', CASE
	WHEN MONTH(fecha_lanzamiento) IN (1, 2, 3) THEN 'Trimestre 1'
	WHEN MONTH(fecha_lanzamiento) IN (4, 5, 6) THEN 'Trimestre 2'
	WHEN MONTH(fecha_lanzamiento) IN (7, 8, 9) THEN 'Trimestre 3'
	ELSE 'Trimestre 4'
	END AS 'Trimestre',
	SUM(cantidad_disponible) AS 'Cantidad disponible'
FROM disco
GROUP BY 1, 2
ORDER BY 1, 2;