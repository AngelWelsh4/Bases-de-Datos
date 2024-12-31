/* Ejercicio 1 */
# 1.
prompt [\w\O \R:\m] (\d) ~>

# 2.
CREATE DATABASE IF NOt EXISTS pr03_eq11 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

# 3.
USE pr03_eq11;
CREATE TABLE IF NOT EXISTS trabajador(
id INT UNSIGNED,
nombre_pila VARCHAR(10),
puesto VARCHAR(15) NOT NULL
);
DESC trabajador;
ALTER TABLE trabajador ADD PRIMARY KEY(id);
DESC trabajador;

# 4.
CREATE TABLE IF NOT EXISTS ingrediente(
codigo TINYINT UNSIGNED PRIMARY KEY auto_increment,
nombre VARCHAR(20),
precio_kg DECIMAL(3,1),
disponibilidad ENUM('D', 'ND') DEFAULT 'ND'
);
DESC ingrediente;

# 5.
ALTER TABLE trabajador MODIFY COLUMN id INT UNSIGNED NOT NULL auto_increment;
ALTER TABLE trabajador ADD COLUMN ing_fav TINYINT UNSIGNED NOT NULL;
ALTER TABLE trabajador ADD FOREIGN KEY(ing_fav) REFERENCES ingrediente(codigo);
ALTER TABLE trabajador ADD COLUMN fecha_inicio DATE DEFAULT '2022-09-30' AFTER nombre_pila;
ALTER TABLE trabajador ALTER COLUMN puesto SET DEFAULT 'pasante';
DESC trabajador;
SHOW CREATE TABLE trabajador;



 