/*
SOURCE C:\Users\Angel\Desktop\16_pixupDatos8.0_final.sql

USE pixup;

#pre
UPDATE detalle_ticket NATURAL JOIN disco
SET subtotal=precio*cantidad; #actualizar subtotal

UPDATE ticket NATURAL JOIN (SELECT id_ticket, SUM(subtotal) AS 'total_cal'
FROM detalle_ticket
GROUP BY id_ticket) AS sub1
SET total=total_cal; #actualizar total
*/

# Ejercicio 2
# 2.1
DROP TRIGGER IF EXISTS detalle_ticket_BI_trigger;
DROP TRIGGER IF EXISTS detalle_ticket_BU_trigger;
DROP TRIGGER IF EXISTS detalle_ticket_AD_trigger;
DROP TRIGGER IF EXISTS disco_AU_trigger;

# 2.2
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
-- encontrar el total dado
SELECT total INTO vtotal FROM ticket WHERE id_ticket=NEW.id_ticket;
-- actualizar el total
UPDATE ticket 
SET total=vtotal+NEW.subtotal
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
-- encontrar el total dado
SELECT total INTO vtotal FROM ticket WHERE id_ticket=NEW.id_ticket;
-- actualizar el total
UPDATE ticket 
SET total=vtotal-OLD.subtotal+NEW.subtotal
WHERE id_ticket=NEW.id_ticket;
END ; $$
DELIMITER ;

-- Prueba 3
DELIMITER $$
CREATE TRIGGER detalle_ticket_AD_trigger AFTER DELETE ON detalle_ticket
FOR EACH ROW
BEGIN  
DECLARE vtotal DECIMAL(10, 0);
-- encontrar el total dado
SELECT total INTO vtotal FROM ticket WHERE id_ticket=OLD.id_ticket;
-- actualizar el total
UPDATE ticket 
SET total=total-OLD.subtotal
WHERE id_ticket=OLD.id_ticket;
END ; $$
DELIMITER ;

/*
DELIMITER $$
CREATE TRIGGER disco_AU_trigger AFTER UPDATE ON disco
FOR EACH ROW
BEGIN  
DECLARE vtotal DECIMAL(10, 0);
DECLARE vid_ticket INT UNSIGNED;
DECLARE vcantidad TINYINT UNSIGNED;
-- encontrar la cantidad
SELECT cantidad INTO vcantidad FROM detalle_ticket WHERE id_disco=NEW.id_disco;
-- actualizar el subtotal
UPDATE detalle_ticket 
SET subtotal=NEW.precio*vcantidad
WHERE id_disco=NEW.id_disco;
-- actualizar el total
UPDATE ticket NATURAL JOIN detalle_ticket
SET total=total-(OLD.precio*vcantidad)+(NEW.precio*vcantidad)
WHERE id_disco=NEW.id_disco;
END ; $$
DELIMITER ;
*/

-- Prueba 4
DELIMITER $$
CREATE TRIGGER disco_AU_trigger AFTER UPDATE ON disco
FOR EACH ROW
BEGIN  
DECLARE vtotal DECIMAL(10, 0);
-- actualizar el subtotal
UPDATE detalle_ticket 
SET subtotal=NEW.precio*cantidad
WHERE id_disco=NEW.id_disco;
-- actualizar el total
UPDATE ticket NATURAL JOIN detalle_ticket
SET total=total-(OLD.precio*cantidad)+(NEW.precio*cantidad)
WHERE id_disco=NEW.id_disco;
END ; $$
DELIMITER ;


# 2.3