/*
borrar
TEE C:\Users\Angel\Desktop\ep5_AngelOcampo.txt

PROMPT (AngelOcampo en: \d \\\D) mysql>
*/

/*
=================================
Ejercicio de participación 5: Delete
Nombre: Ocampo García Victor Emmanuel Miguel Ángel
Fecha: 26-04-23
=================================
*/

/* SOURCE C:\Users\Angel\Desktop\20_collectionHW.sql 
*/
USE collectionhw;
# 1.
/*
SELECT color, modelo, sku 
FROM carritosAOG
WHERE (color LIKE '%Black%' OR color LIKE '%Orange%') AND (modelo IN (2002, 2012, 2019));
*/
DELETE FROM carritosAOG
WHERE (color LIKE '%Black%' OR color LIKE '%Orange%') AND (modelo IN (2002, 2012, 2019));
# 2.
/*
SELECT *
FROM carritosAOG
WHERE 100<precio AND precio<250;
*/
DELETE FROM carritosAOG
WHERE 100<precio AND precio<250;
# 3.
/*
SELECT color, notas, ubicacion
FROM carritosAOG
WHERE color='Pearl White' AND notas IS NULL AND ubicacion IS NULL;
*/
DELETE FROM carritosAOG
WHERE color='Pearl White' AND notas IS NULL AND ubicacion IS NULL;
# 4.
/*
SELECT descripcion
FROM carritosAOG
WHERE descripcion LIKE '%White stripes%' AND ubicacion IS NULL;
*/
DELETE FROM carritosAOG
WHERE descripcion LIKE '%White stripes%' AND ubicacion IS NULL;
# 5.
/*
SELECT sku, precio FROM carritosAOG ORDER BY 2 DESC LIMIT 5; #vemos los carritos más caros

SELECT precio 
FROM carritosAOG
WHERE precio=(SELECT MAX(precio) FROM carritosAOG); #el precio del carrito cuyo precio es el precio máximo

DELETE FROM carritosAOG
WHERE sku=(SELECT sku FROM carritosAOG WHERE precio=(SELECT MAX(precio) FROM carritosAOG)); #i1

DELETE FROM carritosAOG
WHERE precio=(SELECT MAX(precio) FROM carritosAOG); #i2
*/
DELETE FROM carritosAOG
WHERE precio=(SELECT MAX(precio) FROM carritos); #en la subconsulta no puede estar la misma tabla o marca error
# 6.
SELECT COUNT(*) FROM carritosAOG;