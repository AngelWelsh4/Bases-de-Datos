/*
borrar
TEE C:\Users\Angel\Desktop\ep6_AngelOcampo.txt

PROMPT (AngelOcampo en: \d \\\D) mysql>

*/

/*
=================================
Ejercicio de participación 6: Inner join
Nombre: Ocampo García Victor Emmanuel Miguel Ángel
Fecha: 30-04-23
=================================
*/
USE pixup;
# 1.
/*
SELECT id_disquera, COUNT(id_disco)
FROM disco
GROUP BY 1
HAVING  COUNT(id_disco)>=5
ORDER BY 2 DESC; #la consulta pedida

SELECT nombre, COUNT(id_disco)
FROM disco
NATURAL JOIN disquera 
GROUP BY id_disquera
HAVING  COUNT(id_disco)>=5
ORDER BY 2 DESC; #el primer join

SELECT p.nombre, d.nombre, COUNT(id_disco)
FROM disco
NATURAL JOIN disquera AS d
JOIN pais AS p
USING (id_pais)
GROUP BY id_disquera
HAVING  COUNT(id_disco)>=5
ORDER BY 3 DESC; #segundo join, aquí es join using porque el atrib. nombre esta en paises y disquera
*/
SELECT p.nombre AS 'pais', d.nombre AS 'disquera', COUNT(id_disco) AS 'total_discos'
FROM disco
	NATURAL JOIN disquera AS d
	JOIN pais AS p USING (id_pais)
GROUP BY id_disquera
HAVING  COUNT(id_disco)>=5
ORDER BY 3 DESC, 2;
# 2.
/*
SELECT id_genero, COUNT(id_cancion)
FROM disco_cancion
GROUP BY id_genero
ORDER BY 2 DESC; #consulta

SELECT id_genero, nombre, COUNT(id_cancion)
FROM disco_cancion
NATURAL JOIN genero
GROUP BY id_genero
ORDER BY 3 DESC; #el join
*/
SELECT id_genero, nombre AS 'género musical', COUNT(id_cancion) AS 'Total de canciones por género'
FROM disco_cancion
	NATURAL JOIN genero
GROUP BY id_genero
ORDER BY 3 DESC; 
# 3.
/*
SELECT id_genero
FROM disco_cancion
GROUP BY id_genero
HAVING COUNT(id_cancion)<5
ORDER BY COUNT(id_cancion) DESC; #los géneros que cumplen la cond

SELECT id_cancion, id_genero
FROM disco_cancion
WHERE id_genero IN (SELECT id_genero
	FROM disco_cancion
	GROUP BY id_genero
	HAVING COUNT(id_cancion)<5
					); #obtenemos las canciones de dichos géneros
					
SELECT id_cancion, nombre
FROM disco_cancion
NATURAL JOIN genero
WHERE id_genero IN (SELECT id_genero
	FROM disco_cancion
	GROUP BY id_genero
	HAVING COUNT(id_cancion)<5
					); #join con genero
					
SELECT id_cancion, c.nombre, g.nombre
FROM disco_cancion
NATURAL JOIN genero AS g
JOIN cancion AS c
USING (id_cancion)
WHERE id_genero IN (SELECT id_genero
	FROM disco_cancion
	GROUP BY id_genero
	HAVING COUNT(id_cancion)<5
					); #join con genero y cancion
*/
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
/*
SELECT id_idioma FROM idioma WHERE nombre LIKE '%Español%'; #id idioma español

SELECT id_genero FROM genero WHERE nombre LIKE 'F%' OR nombre LIKE 'R%'; #género empieza con F o R

SELECT id_cancion FROM disco_cancion 
WHERE id_idioma=(SELECT id_idioma FROM idioma WHERE nombre LIKE '%Español%')
	AND id_genero IN (SELECT id_genero FROM genero WHERE nombre LIKE 'F%' OR nombre LIKE 'R%'); #consulta

SELECT id_cancion, c.nombre, g.nombre, i.nombre
FROM disco_cancion
	NATURAL JOIN cancion AS c
	JOIN genero AS g 
	USING (id_genero)
	JOIN idioma AS i
	USING (id_idioma)
WHERE id_idioma=(SELECT id_idioma FROM idioma WHERE nombre LIKE '%Español%')
	AND id_genero IN (SELECT id_genero FROM genero WHERE nombre LIKE 'F%' OR nombre LIKE 'R%'); #3 join's
*/
SELECT id_cancion, c.nombre AS 'canción', g.nombre AS 'género musical', i.nombre AS 'idioma'
FROM disco_cancion
	NATURAL JOIN cancion AS c 
	JOIN genero AS g USING (id_genero) 
	JOIN idioma AS i USING (id_idioma)
WHERE id_idioma=(SELECT id_idioma FROM idioma WHERE nombre LIKE '%Español%')
	AND id_genero IN (SELECT id_genero FROM genero WHERE nombre LIKE 'F%' OR nombre LIKE 'R%');
# 5.
/*
SELECT id_cancion, id_disco, id_artista, id_genero, id_idioma, id_version
FROM disco_cancion
ORDER BY id_disco, id_artista, id_cancion; #consulta
*/
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
/*
SELECT id_ticket, COUNT(id_disco)
FROM detalle_ticket
GROUP BY 1
ORDER BY id_ticket; #núm de discos por ticket

SELECT id_ticket, GROUP_CONCAT(titulo SEPARATOR " :: ")
FROM detalle_ticket
	NATURAL JOIN disco
GROUP BY 1
ORDER BY id_ticket;#join para unir los titulos por ticket

SELECT CONCAT(nombre,' ', apellido_paterno), id_ticket, GROUP_CONCAT(titulo SEPARATOR " :: ")
FROM detalle_ticket
	NATURAL JOIN disco
	NATURAL JOIN ticket 
	NATURAL JOIN cliente 
GROUP BY id_ticket
ORDER BY id_ticket;#join para obtener el nombre del cliente
*/
SELECT CONCAT(nombre,' ', apellido_paterno) AS 'Cliente', id_ticket, 
	GROUP_CONCAT(titulo SEPARATOR " :: ") AS 'Discos vendidos por ticket'
FROM detalle_ticket
	NATURAL JOIN disco
	NATURAL JOIN ticket 
	NATURAL JOIN cliente 
GROUP BY id_ticket
ORDER BY id_ticket;
# 7.
/*
SELECT id_ticket, JSON_ARRAYAGG(titulo)
FROM detalle_ticket
	NATURAL JOIN disco
GROUP BY id_ticket
ORDER BY id_ticket; #cambie el group concat por el json_arrayg
*/
SELECT CONCAT(nombre,' ', apellido_paterno) AS 'Cliente', id_ticket, 
	JSON_ARRAYAGG(titulo) AS 'Discos vendidos por ticket'
FROM detalle_ticket
	NATURAL JOIN disco
	NATURAL JOIN ticket 
	NATURAL JOIN cliente 
GROUP BY id_ticket
ORDER BY id_ticket;
# 8.
/*
SELECT id_ticket, JSON_OBJECTAGG(titulo, cantidad)  
FROM detalle_ticket
	NATURAL JOIN disco
GROUP BY id_ticket
ORDER BY id_ticket; 
*/
SELECT CONCAT(nombre,' ', apellido_paterno) AS 'Cliente', id_ticket, 
	JSON_OBJECTAGG(titulo, cantidad) AS 'Discos vendidos por ticket', ROUND(SUM(precio*cantidad), 0) AS 'total'
FROM detalle_ticket
	NATURAL JOIN disco
	NATURAL JOIN ticket 
	NATURAL JOIN cliente 
GROUP BY id_ticket
ORDER BY id_ticket;
# 9.
/*
SELECT id_cliente
FROM ticket
GROUP BY 1
HAVING COUNT(id_ticket)>1
ORDER BY 2; #id_cliente que han comprado más de una vez

SELECT id_cliente, id_ticket
FROM ticket
WHERE id_cliente IN (SELECT id_cliente
	FROM ticket
	GROUP BY 1
	HAVING COUNT(id_ticket)>1); #id_ticket y id_cliente de clientes que han comprado más de una vez

SELECT id_cliente, id_ticket, DATE(fecha), cantidad, subtotal
FROM ticket
	NATURAL JOIN detalle_ticket
WHERE id_cliente IN (SELECT id_cliente
	FROM ticket
	GROUP BY 1
	HAVING COUNT(id_ticket)>1);

SELECT CONCAT(nombre,' ', apellido_paterno) AS 'Cliente', id_ticket, DATE(fecha),
	titulo AS 'Disco', cantidad, precio, subtotal
FROM ticket
	NATURAL JOIN detalle_ticket
	NATURAL JOIN cliente
	NATURAL JOIN disco
WHERE id_cliente IN (SELECT id_cliente
	FROM ticket
	GROUP BY 1
	HAVING COUNT(id_ticket)>1);		
*/
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
/*
SELECT id_cliente
FROM ticket
GROUP BY id_cliente
HAVING COUNT(id_ticket)=1
ORDER BY id_ticket; #id_cliente's con un solo ticket

SELECT id_ticket
FROM ticket
WHERE id_cliente IN (SELECT id_cliente
	FROM ticket
	GROUP BY id_cliente
	HAVING COUNT(id_ticket)=1
	ORDER BY id_ticket
	); #id_ticket's de clientes con un solo ticket
	
SELECT CONCAT(nombre,' ', apellido_paterno) AS 'Cliente', id_ticket, GROUP_CONCAT(id_disco)
FROM ticket
	NATURAL JOIN detalle_ticket
	NATURAL JOIN cliente
	NATURAL JOIN disco
WHERE id_cliente IN (SELECT id_cliente
	FROM ticket
	GROUP BY id_cliente
	HAVING COUNT(id_ticket)=1
	ORDER BY id_ticket
	)
GROUP BY id_ticket;  #hacemos los join's necesarios y repetimos la idea del ej6
*/
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

NOTEE;