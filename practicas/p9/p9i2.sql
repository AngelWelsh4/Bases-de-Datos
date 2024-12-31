# Ejercicio 2

# 2.1
DROP TRIGGER IF EXISTS detalle_ticket_BI_trigger;
DROP TRIGGER IF EXISTS detalle_ticket_AU_trigger;
DROP TRIGGER IF EXISTS detalle_ticket_AD_trigger;
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