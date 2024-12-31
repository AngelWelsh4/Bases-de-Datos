-- 0
-- prompt '\O\y \R:\m (\d) \(EQUIPO 11)'>

-- 1
USE pixup
DROP PROCEDURE IF EXISTS muestra_artistasInicial;
DELIMITER $$
CREATE PROCEDURE muestra_artistasInicial(IN n INT)
BEGIN
-- CONSULTA REQUERIDA
     SELECT a.id_artista, a.nombre, a.descripcion
     FROM artista AS a
     INNER JOIN (
     SELECT LEFT(nombre, 1) AS inicial
     FROM artista
     GROUP BY LEFT(nombre, 1)
     HAVING COUNT(*) = n
  ) AS sub ON LEFT(a.nombre, 1) = sub.inicial;

END $$
DELIMITER ;

CALL muestra_artistasInicial(1);
CALL muestra_artistasInicial(2);
CALL muestra_artistasInicial(4);

-- VERIFICAMOS QUE CALL muestra_artistasInicial(3); ES VACÍO 
CALL muestra_artistasInicial(3);

-- 2 

DROP PROCEDURE IF EXISTS cuantosMun; 

DELIMITER $$

CREATE PROCEDURE cuantosMun(IN estado_param VARCHAR(50))
BEGIN
-- CONSULTA REQUERIDA
    SELECT estado.clave, estado.nombre, COUNT(municipio.clave) AS total_mun
    FROM estado
    INNER JOIN municipio ON estado.clave = municipio.clave_estado
    WHERE estado.nombre LIKE CONCAT(estado_param, '%')
    GROUP BY 1,2;
END $$

DELIMITER ;

CALL cuantosMun('Aguascalientes');
CALL cuantosMun('Yucatán');
CALL cuantosMun('Hidalgo');

-- 3

DROP PROCEDURE IF EXISTS cuenta_cliente;
DELIMITER $$
CREATE PROCEDURE cuenta_cliente(IN cuenta DECIMAL(6,2), IN d VARCHAR(100), IN cantidad INT)
BEGIN
DECLARE p DECIMAL(6,2);
DECLARE gasto DECIMAL(6,2);
DECLARE picafresa INT;
SELECT precio INTO p FROM disco WHERE titulo = d;
SET gasto = p * cantidad;
SET cuenta = cuenta - gasto;
IF cuenta > 0 THEN SELECT CONCAT('Su saldo es de: ', cuenta) AS saldo;
ELSE SELECT CONCAT('Su compra excede a su saldo disponible');
END IF;
SET picafresa = cuenta/3;
SELECT CONCAT('Con su saldo actual le alcanza para comprar: ', picafresa, ' picafresas gigantes') AS picafresas;
END $$

DELIMITER ;

CALL cuenta_cliente(4100.50, 'Love Goes', 1);
CALL cuenta_cliente(3921.50, 'AM', 5);
CALL cuenta_cliente(2671.50, 'dont smile at me', 3);
CALL cuenta_cliente(2041.50, 'Grandes éxitos de los Tigres del Norte', 2);
/*
PREGUNTAS:
Si llamamos el procedimiento podemos contestar las siguientes preguntas
¿Cuánto dinero quedaría en su cuenta si comprara todos los discos anteriores?
 
    Al final le queda 41.50

¿Cuántas pica fresas gigantes de 3 pesos c/u puede comprarse con lo que le queda luego
de adquirir todos los discos?

    Y le alcanza para 14 picafresas Gigantes

*/



# Ejercicio 2

# 2.1
DROP TRIGGER IF EXISTS detalle_ticket_BI_trigger;
DROP TRIGGER IF EXISTS detalle_ticket_AU_trigger;
DROP TRIGGER IF EXISTS detalle_ticket_AD_trigger;
DROP TRIGGER IF EXISTS detalle_ticket_BU_trigger;
DROP TRIGGER IF EXISTS disco_AU_trigger;


# 2.2
/*
-- Prueba 0
UPDATE detalle_ticket NATURAL JOIN disco
SET subtotal=precio*cantidad; #actualizar subtotal

UPDATE ticket NATURAL JOIN (SELECT id_ticket, SUM(subtotal) AS 'total_cal'
FROM detalle_ticket
GROUP BY id_ticket) AS sub1
SET total=total_cal; #actualizar total
*/

-- Prueba 1
DELIMITER $$
CREATE TRIGGER detalle_ticket_BI_trigger BEFORE INSERT ON detalle_ticket
FOR EACH ROW
BEGIN
DECLARE vprecio DECIMAL(6, 2);
DECLARE vtotal DECIMAL(10, 0);
-- encontrar el precio del disco
SELECT precio INTO vprecio FROM disco WHERE id_disco=NEW.id_disco;
-- actualizar el subtotal
SET NEW.subtotal=vprecio*NEW.cantidad;
-- actualizar el total
UPDATE ticket 
SET total=total+NEW.subtotal
WHERE id_ticket=NEW.id_ticket;
END ; $$
DELIMITER ;

-- Prueba 2
DELIMITER $$
CREATE TRIGGER detalle_ticket_BU_trigger BEFORE UPDATE ON detalle_ticket
FOR EACH ROW
BEGIN 
DECLARE vprecio DECIMAL(6, 2); 
DECLARE vtotal DECIMAL(10, 0);
-- encontrar el precio del disco
SELECT precio INTO vprecio FROM disco WHERE id_disco=NEW.id_disco;
-- actualizar el subtotal
SET NEW.subtotal=vprecio*NEW.cantidad;
-- actualizar el total
UPDATE ticket 
SET total=total-OLD.subtotal+NEW.subtotal
WHERE id_ticket=NEW.id_ticket;
END ; $$
DELIMITER ;

-- Prueba 3
DELIMITER $$
CREATE TRIGGER detalle_ticket_AD_trigger AFTER DELETE ON detalle_ticket
FOR EACH ROW
BEGIN  
-- actualizar el total
UPDATE ticket 
SET total=total-OLD.subtotal
WHERE id_ticket=OLD.id_ticket;
END ; $$
DELIMITER ;

-- Prueba 4
DELIMITER $$
CREATE TRIGGER disco_AU_trigger AFTER UPDATE ON disco
FOR EACH ROW
BEGIN  
-- actualizar el subtotal
UPDATE detalle_ticket 
SET subtotal=NEW.precio*cantidad
WHERE id_disco=NEW.id_disco;
-- el total ya se actualizó
END ; $$
DELIMITER ;

# 2.3
/*
# Anexo
-- Prueba 0
select * from detalle_ticket;
select * from ticket;

-- Prueba 1
insert into detalle_ticket(id_ticket,id_disco,cantidad) values(7,6,2);
select * from detalle_ticket;
select * from ticket;
select * from disco where id_disco = 6;
insert into detalle_ticket(id_ticket,id_disco,cantidad)
values(7,59,1);
select * from detalle_ticket;
select * from ticket;

-- Prueba 2
select * from detalle_ticket;
update detalle_ticket set cantidad = 2 where id_ticket = 6 and
id_disco = 69;
select * from detalle_ticket;
select * from ticket;
update detalle_ticket set cantidad = 10 where id_ticket = 10 and
id_disco = 67;
select * from detalle_ticket;
select * from ticket;

-- Prueba 3
delete from detalle_ticket where id_ticket = 10 and id_disco = 67;
select * from detalle_ticket;
select * from ticket;
select * from detalle_ticket;
delete from detalle_ticket where id_ticket = 6;
select * from detalle_ticket;
select * from ticket;

-- Prueba 4
select id_disco, titulo, precio from disco where id_disco = 41;
select * from detalle_ticket;
select * from ticket;
update disco set precio = 200 where id_disco = 41;
select * from detalle_ticket;
select * from ticket;
select id_disco, titulo, precio from disco where id_disco = 6;
select * from detalle_ticket;
update disco set precio = 150 where id_disco = 6;
select * from detalle_ticket;
select * from ticket;

*/