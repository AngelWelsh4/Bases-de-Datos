/*
=================================
Ejercicio de participación 3: Consultas anidadas
Nombre: Ocampo García Victor Emmanuel Miguel Ángel
Fecha: 22-04-23
=================================
*/
USE pixup;
-- Ejercicio 1: Obtener el id, título y precio del disco más barato
SELECT id_disco, titulo, precio FROM  disco WHERE precio=(SELECT MIN(precio) FROM disco); 
-- Ejercicio 2: Obtener el id, título y cantidad disponible del disco con mayor cantidad disponible
SELECT id_disco, titulo, cantidad_disponible FROM disco WHERE cantidad_disponible=(SELECT MAX(cantidad_disponible) FROM disco);
-- Ejercicio 3: Obtener el id,título y fecha de lanzamiento del disco lanzado más reciente
SELECT id_disco, titulo, fecha_lanzamiento FROM disco WHERE fecha_lanzamiento=(SELECT MAX(fecha_lanzamiento) FROM disco);
-- Ejercicio 4: Obtener el id, título y precio de los discos con precios mayores que el precio promedio pero menores que $500, ordenados por precio.
SELECT id_disco, titulo, precio FROM disco WHERE precio>(SELECT AVG(precio) FROM disco) AND precio<500 ORDER BY precio;
