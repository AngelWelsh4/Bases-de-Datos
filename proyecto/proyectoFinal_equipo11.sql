/* =======================================================
Proyecto Final Bases de datos
Fecha: 03-06-2023
Equipo N: 11
Integrante 1: Méndez López Pedro Axel
Integrante 2: Mendoza Domínguez Anabel
Integrante 3: Aragón Juárez Daniel
Integrante 4: Ocampo García Víctor Emmanuel Miguel Ángel
Integrante 5: Salmeron Morales Jazel Alizaid
========================================================*/
USE covid;
/* =======================================================
				SECCION 1: Consultas
========================================================*/
/* 
+-------------+
| Ejercicio 1 |
+-------------+
*/

select id_paciente,edad,fecha_sintomas,fecha_ingreso,nom_estado,nom_mun,descripcion 
from (((((pacientes inner join mexicanos using(id_paciente)) 
inner join municipios on mexicanos.edomun_resi = municipios.edo_mun) 
inner join estados using(clave_edo)) inner join resultado using(clave_resultado)) 
inner join tipos_paciente on tipos_paciente.clave_tipo = pacientes.tipo_paciente) 
inner join embarazos using(id_paciente)  
where tipos_paciente.clave_tipo = 2 and (nom_mun like '%Cárdenas%' OR nom_mun like '%Zapata%' OR nom_mun like '%Atotonilco%') 
order by descripcion desc,edad;

/* 
+-------------+
| Ejercicio 2 |
+-------------+
*/

SELECT est_nac.nom_estado AS 'Estado de nacimiento', est_resi.nom_estado AS 'Estado de residencia', mun.nom_mun AS 'Municipio de residencia', p.edad AS Edad 
FROM pacientes p 
JOIN embarazos e ON p.id_paciente = e.id_paciente 
JOIN defunciones d ON e.id_paciente = d.id_paciente 
JOIN mexicanos mex ON e.id_paciente = mex.id_paciente  
JOIN municipios mun ON mex.edomun_resi = mun.edo_mun 
JOIN estados est_nac ON edo_nacim = est_nac.clave_edo 
JOIN estados est_resi ON LEFT(mex.edomun_resi, 2) = est_resi.clave_edo 
WHERE edo_nacim != LEFT(mex.edomun_resi, 2)
AND clave_resultado = 1  
ORDER BY 1 ASC;

/* 
+-------------+
| Ejercicio 3 |
+-------------+
*/

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

/* 
+-------------+
| Ejercicio 4 |
+-------------+
*/

 SELECT p.id_paciente, p.edad, e.nom_estado 'Estado de la Unidad Médica', pa.nom_pais AS Nacionalidad,     CASE WHEN ex.pais_origen = ex.pais_nacionalidad THEN pa.nom_pais
         ELSE 'Se ignora' END AS 'Pais de origen',
         CASE WHEN ex.pais_origen = ex.pais_nacionalidad THEN 'Si'
         ELSE 'No' END AS "Es migrante", res.descripcion AS 'Prueba COVID'
FROM pacientes p
JOIN extranjeros ex USING (id_paciente)
JOIN pais pa ON ex.pais_nacionalidad = pa.clave_pais
JOIN embarazos emb USING (id_paciente)
LEFT JOIN resultado res USING(clave_resultado)
JOIN estados e ON p.edo_um = e.clave_edo ORDER BY 3,4;


/* 
+-------------+
| Ejercicio 5 |
+-------------+
*/

SELECT r.clave_sector, s.nom_sector AS Sector, FORMAT(r.total,0) AS Total 
FROM (
    SELECT clave_sector, count(*) AS total
    FROM pacientes p
    JOIN resultado r ON p.clave_resultado = r.clave_resultado
    WHERE r.descripcion = 'Positivo SARS-CoV-2'
    GROUP BY clave_sector
) r 
JOIN sector s ON r.clave_sector = s.clave_sector 
WHERE r.total = (
    SELECT max(total)
    FROM (
        SELECT count(*) AS total
        FROM pacientes p
        JOIN resultado r ON p.clave_resultado = r.clave_resultado
        WHERE r.descripcion = 'Positivo SARS-CoV-2'
        GROUP BY clave_sector
    ) x
);

/* 
+-------------+
| Ejercicio 6 |
+-------------+
*/
select nom_estado as 'Estado',
lpad(format(pob,0),length('Población total') - 1,' ') as 'Población total',
lpad(format(infectados,0),length('Total de infectados'),' ') as 'Total de infectados'
from (select clave_edo,nom_estado,count(id_paciente) as 'infectados' from (((pacientes inner join mexicanos using(id_paciente)) inner join municipios on mexicanos.edomun_resi = municipios.edo_mun) inner join estados using(clave_edo)) inner join resultado using(clave_resultado) where clave_edo in (select clave_edo from (SELECT clave_edo from estados NATURAL JOIN municipios group by nom_estado order by sum(pob_total) desc limit 5) sub) group by clave_edo,resultado.descripcion having descripcion = 'Positivo SARS-CoV-2' order by 1) as subfuno natural join (SELECT clave_edo,sum(pob_total) as 'pob' from estados NATURAL JOIN municipios group by nom_estado order by sum(pob_total)) as subfdos 
where  infectados = (select min(infectados) from (select clave_edo,nom_estado,count(id_paciente) as 'infectados' from (((pacientes inner join mexicanos using(id_paciente)) inner join municipios on mexicanos.edomun_resi = municipios.edo_mun) inner join estados using(clave_edo)) inner join resultado using(clave_resultado) where clave_edo in (select clave_edo from (SELECT clave_edo from estados NATURAL JOIN municipios group by nom_estado order by sum(pob_total) desc limit 5) sub) group by clave_edo,resultado.descripcion having descripcion = 'Positivo SARS-CoV-2' order by 1) as sub) ;


/* =======================================================
			SECCION 2: Procedimientos Almacenados
========================================================*/
/* 

/* 
+-------------+
| Ejercicio 1 |
+-------------+
*/

DROP PROCEDURE IF EXISTS defExtranjeros;

DELIMITER $$

CREATE PROCEDURE defExtranjeros(IN pais_param VARCHAR(50), IN criterio_param CHAR(1))
BEGIN
    DECLARE criterio_valido BOOLEAN;
    DECLARE pais_busqueda VARCHAR(50);
    DECLARE mensaje VARCHAR(50);
    
    -- Validar el criterio de búsqueda ingresado
    SET criterio_valido = FALSE;
    CASE criterio_param
        WHEN '*' THEN SET criterio_valido = TRUE;
        WHEN '=' THEN SET criterio_valido = TRUE;
        WHEN '!' THEN SET criterio_valido = TRUE;
        ELSE SET criterio_valido = FALSE;
    END CASE;
    
    IF criterio_valido THEN
        -- Ajustar el valor del país de búsqueda según el criterio
        SET pais_busqueda = pais_param;
        
        -- Consulta principal para obtener el reporte de extranjeros fallecidos según el país y criterio
        #SELECT CONCAT('defExtranjeros("',pais_param,'","',criterio_param,'")' ) AS 'Llamadas a procedimiento 1 ';
        SELECT p.id_paciente, p.sexo, p.edad, pa.nom_pais AS 'pais_nacionalidad',
            CASE WHEN ex.pais_origen = ex.pais_nacionalidad THEN pa.nom_pais
                ELSE 'Se ignora' END AS 'pais_origen',
            p.fecha_sintomas, p.fecha_ingreso, d.fecha_defuncion,
            c.descripcion AS 'Fue intubado?',
            c2.descripcion AS 'Tuvo neumonia?',
            tp.nom_tipo AS 'Tipo de paciente',
            res.descripcion AS 'Prueba COVID'
        FROM pacientes p
        JOIN extranjeros ex USING (id_paciente)
        JOIN pais pa ON ex.pais_nacionalidad = pa.clave_pais
        JOIN defunciones d USING (id_paciente)
        JOIN cat_sino c ON p.intubado = c.clave
        JOIN cat_sino c2 ON p.neumonia = c2.clave
        JOIN tipos_paciente tp ON p.tipo_paciente = tp.clave_tipo
        LEFT JOIN resultado res USING (clave_resultado)
        WHERE pa.nom_pais LIKE CONCAT(pais_busqueda, '%')
          AND (criterio_param = '*' OR
               (criterio_param = '=' AND ex.pais_origen = ex.pais_nacionalidad) OR
               (criterio_param = '!' AND ex.pais_origen <> ex.pais_nacionalidad))
        ORDER BY p.edad;
        
     ELSE
        -- Mostrar mensaje de "Opción no válida"
        #SELECT CONCAT('defExtranjeros("',pais_param,'","',criterio_param,'")' ) AS 'Llamadas a procedimiento 1 ';
        SELECT 'Opción no válida' AS 'Error';
    END IF;
END $$

DELIMITER ;

-- PRUEBAS

call defExtranjeros('repu','*');
call defExtranjeros('repu','=');
call defExtranjeros('repu','!');
call defExtranjeros('repu','x');
call defExtranjeros('cuba','*');


/* 
+-------------+
| Ejercicio 2 |
+-------------+
*/

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

/* 
+-------------+
| Ejercicio 3 |
+-------------+
*/

DROP PROCEDURE IF EXISTS tardanza;

DELIMITER //
CREATE PROCEDURE tardanza()
BEGIN
    SELECT
        p1.id_paciente,
        p1.sexo,
        p1.edad,
        p1.fecha_sintomas,
        p1.fecha_ingreso,
        DATEDIFF(p1.fecha_ingreso, p1.fecha_sintomas) AS 'Días transcurridos',
        u.nom_estado AS 'Entidad de la UM',
        tp.nom_tipo AS 'Tipo de paciente',
        cs.descripcion AS 'Fue intubado',
        cs2.descripcion AS Neumonia,
        r.descripcion AS Diagnóstico
    FROM
        pacientes p1
        JOIN estados u ON p1.edo_um = u.clave_edo
        JOIN tipos_paciente tp ON p1.tipo_paciente = tp.clave_tipo
        JOIN cat_sino cs ON p1.intubado = cs.clave
        JOIN cat_sino cs2 ON p1.neumonia = cs2.clave
        JOIN resultado r ON p1.clave_resultado = r.clave_resultado
    WHERE
        p1.clave_resultado = 1  -- Paciente positivo
        AND p1.fecha_sintomas IS NOT NULL
        AND p1.fecha_ingreso IS NOT NULL
        AND DATEDIFF(p1.fecha_ingreso, p1.fecha_sintomas) = (
            SELECT MAX(DATEDIFF(p2.fecha_ingreso, p2.fecha_sintomas))
            FROM pacientes p2
            WHERE
                p2.clave_resultado = 1
                AND p2.fecha_sintomas IS NOT NULL
                AND p2.fecha_ingreso IS NOT NULL
        )
    UNION ALL
    SELECT
        p3.id_paciente,
        p3.sexo,
        p3.edad,
        p3.fecha_sintomas,
        p3.fecha_ingreso,
        DATEDIFF(p3.fecha_ingreso, p3.fecha_sintomas) AS 'Días transcurridos',
        u.nom_estado AS 'Entidad de la UM',
        tp.nom_tipo AS 'Tipo de paciente',
        cs.descripcion AS 'Fue intubado',
        cs2.descripcion AS Neumonia,
        r.descripcion AS Diagnóstico
    FROM
        pacientes p3
        JOIN estados u ON p3.edo_um = u.clave_edo
        JOIN tipos_paciente tp ON p3.tipo_paciente = tp.clave_tipo
        JOIN cat_sino cs ON p3.intubado = cs.clave
        JOIN cat_sino cs2 ON p3.neumonia = cs2.clave
        JOIN resultado r ON p3.clave_resultado = r.clave_resultado
    WHERE
        p3.clave_resultado = 2  -- Paciente negativo
        AND p3.fecha_sintomas IS NOT NULL
        AND p3.fecha_ingreso IS NOT NULL
        AND DATEDIFF(p3.fecha_ingreso, p3.fecha_sintomas) = (
            SELECT MAX(DATEDIFF(p4.fecha_ingreso, p4.fecha_sintomas))
            FROM pacientes p4
            WHERE
                p4.clave_resultado = 2
                AND p4.fecha_sintomas IS NOT NULL
                AND p4.fecha_ingreso IS NOT NULL
        )
    ORDER BY 6 DESC, 1 DESC;
END //
DELIMITER ;

CALL tardanza();


/* 
+-------------+
| Ejercicio 4 |
+-------------+
*/
DROP PROCEDURE IF EXISTS intubados;
Delimiter $$
CREATE PROCEDURE intubados()
begin
select case when fecha_defuncion is NULL then 'Sobreviven' else 'Fallecen' END as 'Intubados',
lpad(FORMAT(count(id_paciente),0),length('Num. Pacientes'),' ') as 'Num. Pacientes',
lpad(concat(FORMAT(round((count(*)/(select count(*) 
from pacientes left join defunciones using(id_paciente) 
where clave_resultado = 1 and intubado = 1))*100),1),' %'),length('Proporción')-1,' ') as 'Proporción' 
from pacientes left join defunciones using(id_paciente) where clave_resultado = 1 and intubado = 1 group by 1
UNION 
select case when fecha_defuncion is NULL then 'Total' else 'Total' END as 'Intubados',
lpad(FORMAT(count(id_paciente),0),length('Num. Pacientes'),' ') as 'Num. Pacientes',
lpad(concat(FORMAT((select sum(Proporción) 
from (select case when fecha_defuncion is NULL then 'Sobreviven' else 'Fallecen' END as 'Intubados',count(id_paciente) as 'Num. Pacientes',round((count(*)/(select count(*) 
from pacientes left join defunciones using(id_paciente) 
where clave_resultado = 1 and intubado = 1))*100) as 'Proporción' from pacientes left join defunciones using(id_paciente) 
where clave_resultado = 1 and intubado = 1 group by 1) as sum),1),' %'),length('Proporción')-1,' ') as 'Proporción' from pacientes left join defunciones using(id_paciente) 
where clave_resultado = 1 and intubado = 1 group by 1;
end;
$$
Delimiter ;

call intubados;