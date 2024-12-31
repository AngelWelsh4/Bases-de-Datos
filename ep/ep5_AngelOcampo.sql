/*
=================================
Ejercicio de participación 5: Delete
Nombre: Ocampo García Victor Emmanuel Miguel Ángel
Fecha: 26-04-23
=================================
*/
USE collectionhw;
# 1.
DELETE FROM carritosAOG
WHERE (color LIKE '%Black%' OR color LIKE '%Orange%') AND (modelo IN (2002, 2012, 2019));
# 2.
DELETE FROM carritosAOG
WHERE 100<precio AND precio<250;
# 3.
DELETE FROM carritosAOG
WHERE color='Pearl White' AND notas IS NULL AND ubicacion IS NULL;
# 4.
DELETE FROM carritosAOG
WHERE descripcion LIKE '%White stripes%' AND ubicacion IS NULL;
# 5.
DELETE FROM carritosAOG
WHERE precio=(SELECT MAX(precio) FROM carritos); #en la subconsulta no puede estar la misma tabla o marca error
# 6.
SELECT COUNT(*) FROM carritosAOG;