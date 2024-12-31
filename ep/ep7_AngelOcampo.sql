/*
=================================
Ejercicio de participación 7: Outer join
Nombre: Ocampo García Victor Emmanuel Miguel Ángel
Fecha: 07-05-23
=================================
*/
# 1.
USE pixup;
SELECT id_genero, g.nombre AS 'género musical', id_cancion, c.nombre AS 'canción'
FROM genero AS g
	LEFT JOIN disco_cancion USING(id_genero)
	LEFT JOIN cancion AS c USING(id_cancion)
ORDER BY 1, 2;
# 2.
SELECT COUNT(*) AS 'Número de géneros musicales sin canciones'
FROM cancion
	RIGHT JOIN disco_cancion USING(id_cancion)
	RIGHT JOIN genero USING(id_genero)
WHERE id_cancion IS NULL;
# 3.
SELECT id_genero, g.nombre AS 'género musical'
FROM cancion AS c
	RIGHT JOIN disco_cancion USING(id_cancion)
	RIGHT JOIN genero AS g USING(id_genero)
WHERE id_cancion IS NULL;
# 4.
SELECT id_idioma, i.nombre AS 'idioma'
FROM idioma AS i
	LEFT JOIN disco_cancion USING(id_idioma)
	LEFT JOIN cancion AS c USING(id_cancion)
WHERE id_cancion IS NULL
ORDER BY 2;
# 5.
SELECT id_disquera, nombre AS 'disquera'
FROM disco 
	RIGHT JOIN disquera USING(id_disquera)
WHERE id_disco IS NULL;
# 6.
SELECT DISTINCT id_pais, p.nombre AS 'nombre'
FROM disquera AS d
	RIGHT JOIN pais AS p USING(id_pais)
WHERE id_disquera IS NOT NULL;	
# 7.
(SELECT id_disco, titulo AS 'Título del disco', id_ticket, SUBSTRING(fecha, 1, 10) AS 'fecha de venta'
FROM ticket
	LEFT JOIN detalle_ticket USING(id_ticket)
	LEFT JOIN disco USING(id_disco)
WHERE id_disco IS NULL)
UNION
(SELECT id_disco, titulo, id_ticket, fecha
FROM disco
	LEFT JOIN detalle_ticket USING(id_disco)
	LEFT JOIN ticket USING(id_ticket)
WHERE id_ticket IS NULL);
# 8.
(SELECT 'Idiomas' AS 'Tabla', COUNT(*) AS 'Total en catálogo',
	(SELECT COUNT(*)
	FROM idioma
		LEFT JOIN disco_cancion USING(id_idioma)
	WHERE id_disco IS NULL)  AS 'Sin asignación'
FROM idioma)
UNION
(SELECT 'Géneros musicales' AS 'Tabla', COUNT(*) AS 'Total en catálogo',
	(SELECT COUNT(*)
	FROM genero
		LEFT JOIN disco_cancion USING(id_genero)
	WHERE id_disco IS NULL)  AS 'Sin asignación'
FROM genero)
UNION
(SELECT 'Discos' AS 'Tabla', COUNT(*) AS 'Total en catálogo',
	(SELECT COUNT(*)
	FROM disco
		LEFT JOIN disco_cancion USING(id_disco)
	WHERE id_cancion IS NULL)  AS 'Sin asignación'
FROM disco)
UNION
(SELECT 'Canciones' AS 'Tabla', COUNT(*) AS 'Total en catálogo',
	(SELECT COUNT(*)
	FROM cancion
		LEFT JOIN disco_cancion USING(id_cancion)
	WHERE id_disco IS NULL)  AS 'Sin asignación'
FROM cancion)
UNION
(SELECT 'Artistas' AS 'Tabla', COUNT(*) AS 'Total en catálogo',
	(SELECT COUNT(*)
	FROM artista
		LEFT JOIN disco_cancion USING(id_artista)
	WHERE id_disco IS NULL)  AS 'Sin asignación'
FROM artista);