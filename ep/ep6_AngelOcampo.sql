/*
=================================
Ejercicio de participación 6: Inner join
Nombre: Ocampo García Victor Emmanuel Miguel Ángel
Fecha: 30-04-23
=================================
*/
USE pixup;
# 1.
SELECT p.nombre AS 'pais', d.nombre AS 'disquera', COUNT(id_disco) AS 'total_discos'
FROM disco
	NATURAL JOIN disquera AS d
	JOIN pais AS p USING (id_pais)
GROUP BY id_disquera
HAVING  COUNT(id_disco)>=5
ORDER BY 3 DESC, 2;
# 2.
SELECT id_genero, nombre AS 'género musical', COUNT(id_cancion) AS 'Total de canciones por género'
FROM disco_cancion
	NATURAL JOIN genero
GROUP BY id_genero
ORDER BY 3 DESC; 
# 3.
SELECT id_cancion, c.nombre AS 'canción', g.nombre AS 'género musical'
FROM disco_cancion
	NATURAL JOIN genero AS g
	JOIN cancion AS c USING (id_cancion)
WHERE id_genero IN (SELECT id_genero
	FROM disco_cancion
	GROUP BY id_genero
	HAVING COUNT(id_cancion)<5
					)
ORDER BY 3, 2;
# 4.
SELECT id_cancion, c.nombre AS 'canción', g.nombre AS 'género musical', i.nombre AS 'idioma'
FROM disco_cancion
	NATURAL JOIN cancion AS c 
	JOIN genero AS g USING (id_genero) 
	JOIN idioma AS i USING (id_idioma)
WHERE id_idioma=(SELECT id_idioma FROM idioma WHERE nombre LIKE '%Español%')
	AND id_genero IN (SELECT id_genero FROM genero WHERE nombre LIKE 'F%' OR nombre LIKE 'R%');
# 5.
SELECT c.nombre AS 'canción', titulo AS 'disco', a.nombre AS 'artista',
	g.nombre AS 'género musical', i.nombre AS 'idioma', v.nombre AS 'versión'
FROM disco_cancion
	NATURAL JOIN cancion AS c
	JOIN disco USING (id_disco)
	JOIN artista AS a USING (id_artista)
	JOIN genero AS g USING (id_genero)
	JOIN idioma AS i USING (id_idioma)
	JOIN version AS v USING (id_version)
ORDER BY titulo, a.nombre, c.nombre;
# 6.
SELECT CONCAT(nombre,' ', apellido_paterno) AS 'Cliente', id_ticket, 
	GROUP_CONCAT(titulo SEPARATOR " :: ") AS 'Discos vendidos por ticket'
FROM detalle_ticket
	NATURAL JOIN disco
	NATURAL JOIN ticket 
	NATURAL JOIN cliente 
GROUP BY id_ticket
ORDER BY id_ticket;
# 7.
SELECT CONCAT(nombre,' ', apellido_paterno) AS 'Cliente', id_ticket, 
	JSON_ARRAYAGG(titulo) AS 'Discos vendidos por ticket'
FROM detalle_ticket
	NATURAL JOIN disco
	NATURAL JOIN ticket 
	NATURAL JOIN cliente 
GROUP BY id_ticket
ORDER BY id_ticket;
# 8.
SELECT CONCAT(nombre,' ', apellido_paterno) AS 'Cliente', id_ticket, 
	JSON_OBJECTAGG(titulo, cantidad) AS 'Discos vendidos por ticket', ROUND(SUM(precio*cantidad), 0) AS 'total'
FROM detalle_ticket
	NATURAL JOIN disco
	NATURAL JOIN ticket 
	NATURAL JOIN cliente 
GROUP BY id_ticket
ORDER BY id_ticket;
# 9.
SELECT CONCAT(nombre,' ', apellido_paterno) AS 'Cliente', id_ticket, DATE(fecha) AS 'Fecha de venta',
	titulo AS 'Disco', cantidad, CONCAT('$', ROUND(precio, 1)) AS 'Precio', 
	LPAD(CONCAT('$', ROUND(precio*cantidad, 1)), LENGTH('Subtotal'), ' ') AS 'Subtotal'
FROM ticket
	NATURAL JOIN detalle_ticket
	NATURAL JOIN cliente
	NATURAL JOIN disco
WHERE id_cliente IN (SELECT id_cliente
	FROM ticket
	GROUP BY 1
	HAVING COUNT(id_ticket)>1)
ORDER BY 1;
# 10.
SELECT CONCAT(nombre,' ', apellido_paterno) AS 'Cliente', id_ticket, DATE(fecha) AS 'Fecha de venta',
	JSON_OBJECTAGG(titulo, cantidad) AS 'Discos vendidos por ticket', 
	LPAD(CONCAT('$', FORMAT(ROUND(SUM(precio*cantidad), 0), 1)), LENGTH('Total pagado'), ' ') AS 'Total pagado'
FROM ticket
	NATURAL JOIN detalle_ticket
	NATURAL JOIN cliente
	NATURAL JOIN disco
WHERE id_cliente IN (SELECT id_cliente
	FROM ticket
	GROUP BY id_cliente
	HAVING COUNT(id_ticket)=1
	ORDER BY 1
	)
GROUP BY id_ticket
ORDER BY id_direccion;  
