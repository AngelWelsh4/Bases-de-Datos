-- Sección 1: Consultas
-- Ejercicio 3
SELECT nom_estado AS 'Entidad Federativa', LPAD(FORMAT(COUNT(id_paciente), 0), LENGTH('Total de defunciones'), ' ') AS 'Total de defunciones'
FROM 
	((SELECT nom_estado, id_paciente
	FROM defunciones
		LEFT JOIN pacientes USING (id_paciente)
		NATURAL JOIN resultado
		JOIN cat_sino ON otro_caso=clave
		NATURAL JOIN mexicanos
		JOIN municipios ON edomun_resi=edo_mun
		NATURAL JOIN estados
	WHERE clave_resultado=1 AND clave=2)
UNION (SELECT nom_estado, id_paciente
	FROM defunciones
		LEFT JOIN pacientes USING (id_paciente)
		NATURAL JOIN resultado
		JOIN cat_sino ON otro_caso=clave
		NATURAL JOIN extranjeros
		JOIN municipios ON edomun_resi=edo_mun
		NATURAL JOIN estados
	WHERE clave_resultado=1 AND clave=2)) AS sub1
GROUP BY nom_estado
ORDER BY nom_estado;

-- Ejercicio 6
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
