SOURCE C:\Users\Angel\Desktop\covidAgosto_dump.sql
USE covid;
-- Sección 1: Consultas
-- Ejercicio 3
/*
SELECT nom_estado, COUNT(id_paciente)
FROM defunciones
	LEFT JOIN pacientes USING (id_paciente)
	NATURAL JOIN resultado AS r
	JOIN cat_sino AS cat ON otro_caso=clave
	NATURAL JOIN mexicanos
	JOIN municipios ON edomun_resi=edo_mun
	NATURAL JOIN estados
WHERE r.descripcion='Positivo SARS-CoV-2' AND cat.descripcion='No'
GROUP BY nom_estado
ORDER BY 1;

SELECT nom_estado, COUNT(id_paciente)
FROM defunciones
	LEFT JOIN pacientes USING (id_paciente)
	NATURAL JOIN resultado AS r
	JOIN cat_sino AS cat ON otro_caso=clave
	NATURAL JOIN extranjeros
	JOIN municipios ON edomun_resi=edo_mun
	NATURAL JOIN estados
WHERE r.descripcion='Positivo SARS-CoV-2' AND cat.descripcion='No'
GROUP BY nom_estado
ORDER BY 1;

*/
SELECT sub1.nom_estado AS 'Entidad Federativa', CASE #para abarcar todos los casos
	WHEN (sub1.cont IS NOT NULL AND sub2.cont IS NULL) THEN LPAD(FORMAT(sub1.cont, 0), LENGTH('Total de defunciones'), ' ')
	WHEN (sub1.cont IS NOT NULL AND sub1.cont IS NOT NULL) THEN LPAD(FORMAT(sub1.cont+sub2.cont, 0), LENGTH('Total de defunciones'), ' ')
	WHEN (sub1.cont IS NULL AND sub2.cont IS NOT NULL) THEN LPAD(FORMAT(sub2.cont, 0), LENGTH('Total de defunciones'), ' ')
	ELSE NULL
	END AS 'Total de defunciones'
FROM 
	(SELECT nom_estado, COUNT(id_paciente) AS cont
	FROM defunciones
		LEFT JOIN pacientes USING (id_paciente)
		NATURAL JOIN resultado AS r
		JOIN cat_sino AS cat ON otro_caso=clave
		NATURAL JOIN mexicanos
		JOIN municipios ON edomun_resi=edo_mun
		NATURAL JOIN estados
	WHERE r.descripcion='Positivo SARS-CoV-2' AND cat.descripcion='No'
	GROUP BY nom_estado) AS sub1
LEFT JOIN (SELECT nom_estado, COUNT(id_paciente) AS cont
	FROM defunciones
		LEFT JOIN pacientes USING (id_paciente)
		NATURAL JOIN resultado AS r
		JOIN cat_sino AS cat ON otro_caso=clave
		NATURAL JOIN extranjeros
		JOIN municipios ON edomun_resi=edo_mun
		NATURAL JOIN estados
	WHERE r.descripcion='Positivo SARS-CoV-2' AND cat.descripcion='No'
	GROUP BY nom_estado) AS sub2
ON sub1.nom_estado=sub2.nom_estado
ORDER BY sub1.nom_estado;

-- Sección 2
-- Ejercicio 2
DROP PROCEDURE IF EXISTS reporteTecnico;

DELIMITER $$
CREATE PROCEDURE reporteTecnico(IN parametro VARCHAR(5)) #deje el límite en 5 porque es el máximo empleado
BEGIN 
IF parametro='gral' THEN 
	SELECT (SELECT MAX(STR_TO_DATE(fecha_actualizacion, '%Y-%m-%d')) FROM pacientes) AS 'Fecha de actualización',
		LPAD(FORMAT((SELECT COUNT(*) FROM pacientes), 0), LENGTH('Casos registrados'), ' ') AS 'Casos registrados', 
		LPAD(FORMAT((SELECT COUNT(*) FROM pacientes JOIN resultado USING(clave_resultado) WHERE clave_resultado=1), 0), LENGTH('Positivos'), ' ') AS 'Positivos',
		LPAD(FORMAT((SELECT COUNT(*) FROM pacientes JOIN resultado USING(clave_resultado) WHERE clave_resultado=2), 0), LENGTH('Negativos'), ' ') AS 'Negativos',
		LPAD(FORMAT((SELECT COUNT(*) FROM pacientes JOIN resultado USING(clave_resultado) WHERE clave_resultado=3), 0), LENGTH('Sospechosos'), ' ') AS 'Sospechosos';
ELSEIF parametro='sexo' THEN
	SELECT (SELECT MAX(STR_TO_DATE(fecha_actualizacion, '%Y-%m-%d')) FROM pacientes) AS 'Fecha de actualización',
		LPAD(FORMAT((SELECT COUNT(*) FROM pacientes JOIN resultado USING(clave_resultado) WHERE clave_resultado=1), 0), LENGTH('Positivos'), ' ') AS 'Positivos',
		LPAD(FORMAT((SELECT COUNT(*) FROM pacientes JOIN resultado USING(clave_resultado) WHERE clave_resultado=1 AND sexo='H'), 0), LENGTH('Hombres'), ' ') AS 'Hombres',
		LPAD(FORMAT((SELECT COUNT(*) FROM pacientes JOIN resultado USING(clave_resultado) WHERE clave_resultado=1 AND sexo='M'), 0), LENGTH('Mujeres'), ' ') AS 'Mujeres';
ELSEIF parametro='comor' THEN
	SELECT nom_comor AS 'Comorbilidad', LPAD(FORMAT(COUNT(id_paciente), 0), LENGTH('Total de pacientes'), ' ') AS 'Total de pacientes'
	FROM paciente_comorbilidad NATURAL JOIN comorbilidades
	GROUP BY nom_comor
	ORDER BY COUNT(id_paciente) DESC;
ELSE 
	SELECT 'Opción no válida' AS 'Error';
END IF;
END $$
DELIMITER ;

call reporteTecnico('gral');
call reporteTecnico('sexo');
call reporteTecnico('comor');
call reporteTecnico('otro');

-- Ejercicio 6
SELECT clave_edo, nom_estado
FROM municipios
	NATURAL JOIN estados
GROUP BY 1, 2
ORDER BY SUM(pob_total) DESC
LIMIT 5; #los 5 estados con mayor número de habitantes

SELECT nom_estado, COUNT(id_paciente)
FROM pacientes
	NATURAL JOIN resultado
	JOIN (SELECT clave_edo, nom_estado
	FROM municipios
		NATURAL JOIN estados
	GROUP BY 1, 2
	ORDER BY SUM(pob_total) DESC
	LIMIT 5) AS sub1 ON edo_um=clave_edo
WHERE clave_resultado=1
GROUP BY nom_estado
ORDER BY 2 ASC; #intento1 (fail)

SELECT nom_estado, COUNT(id_paciente)
FROM pacientes
	NATURAL JOIN resultado
	NATURAL JOIN mexicanos
	JOIN municipios ON edomun_resi=edo_mun
	NATURAL JOIN estados
WHERE clave_resultado=1
GROUP BY 1; #casos infectados por estado (sólo mexicanos)

SELECT nom_estado, poblacion_edo, COUNT(id_paciente) AS 'pacientes'
FROM pacientes
	NATURAL JOIN resultado
	NATURAL JOIN mexicanos
	JOIN municipios ON edomun_resi=edo_mun
	NATURAL JOIN estados
	NATURAL JOIN (SELECT clave_edo, SUM(pob_total) AS 'poblacion_edo'
	FROM municipios
		NATURAL JOIN estados
	GROUP BY 1
	ORDER BY SUM(pob_total) DESC
	LIMIT 5) AS sub1
WHERE clave_resultado=1
GROUP BY nom_estado, poblacion_edo; #intento2 (bueno)

SELECT nom_estado AS 'Estado', LPAD(FORMAT(poblacion_edo, 0), LENGTH('Población total'), ' ') AS 'Población total', 
	LPAD(FORMAT(pacientes, 0), LENGTH('Total de infectados'), ' ') AS 'Total de infectados'
FROM (SELECT nom_estado, poblacion_edo, COUNT(id_paciente) AS 'pacientes'
	FROM pacientes
		NATURAL JOIN resultado
		NATURAL JOIN mexicanos
		JOIN municipios ON edomun_resi=edo_mun
		NATURAL JOIN estados
		NATURAL JOIN (SELECT clave_edo, SUM(pob_total) AS 'poblacion_edo'
		FROM municipios
			NATURAL JOIN estados
		GROUP BY 1
		ORDER BY SUM(pob_total) DESC
		LIMIT 5) AS sub1
	WHERE clave_resultado=1
	GROUP BY nom_estado, poblacion_edo) AS sub2
WHERE pacientes=(SELECT MIN(pacientes) FROM (SELECT nom_estado, poblacion_edo, COUNT(id_paciente) AS 'pacientes'
	FROM pacientes
		NATURAL JOIN resultado
		NATURAL JOIN mexicanos
		JOIN municipios ON edomun_resi=edo_mun
		NATURAL JOIN estados
		NATURAL JOIN (SELECT clave_edo, SUM(pob_total) AS 'poblacion_edo'
		FROM municipios
			NATURAL JOIN estados
		GROUP BY 1
		ORDER BY SUM(pob_total) DESC
		LIMIT 5) AS sub1
	WHERE clave_resultado=1
	GROUP BY nom_estado, poblacion_edo) AS sub3);