CREATE TABLE IF NOT EXISTS modelo(id_modelo SMALLINT UNSIGNED NOT NULL PRIMARY KEY auto_increment, nombre_modelo VARCHAR(30) NOT NULL,
año SMALLINT NOT NULL, color VARCHAR(20) NOT NULL);

CREATE TABLE IF NOT EXISTS incidente(id_incidente TINYINT UNSIGNED PRIMARY KEY, tipo_incidente VARCHAR(30) NOT NULL);

CREATE TABLE IF NOT EXISTS estado(clave_estado TINYINT UNSIGNED NOT NULL PRIMARY KEY auto_increment, nombre VARCHAR(20) NOT NULL UNIQUE);

CREATE TABLE IF NOT EXISTS administrador(id_admin TINYINT UNSIGNED NOT NULL PRIMARY KEY auto_increment, rfc CHAR(13) NOT NULL, telefono CHAR(10), nombre VARCHAR(20) NOT NULL, apellido_paterno VARCHAR(20) NOT NULL, apellido_materno VARCHAR(20));

CREATE TABLE vehiculo(placa VARCHAR(7) NOT NULL PRIMARY KEY,
		kilometraje SMALLINT UNSIGNED DEFAULT 0, estado_disponible ENUM('YES','NO') NOT NULL,
		transmision VARCHAR(30) NOT NULL, costo_por_dia float(7,2), id_modelo SMALLINT UNSIGNED NOT NULL, CONSTRAINT FK_modelo_vehiculo FOREIGN KEY (id_modelo) REFERENCES modelo(id_modelo));
		