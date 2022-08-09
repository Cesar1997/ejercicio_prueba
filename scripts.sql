
CREATE DATABASE test_dafiti;

use test_dafiti;

CREATE TABLE equipos(
    id_equipos INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(45) NOT NULL,
    CONSTRAINT pk_id_equipos PRIMARY KEY(id_equipos)
)


CREATE TABLE jugadores(
    id_jugadores INT NOT NULL AUTO_INCREMENT,
    fk_equipos INT NOT NULL,
    nombre VARCHAR(45) NOT NULL,
    fecha_nacimiento DATETIME,
    CONSTRAINT pk_id_jugadores PRIMARY KEY(id_jugadores),
    CONSTRAINT fk_column_fk_equipos_to_table_equipos FOREIGN KEY(fk_equipos) REFERENCES equipos(id_equipos)
)

CREATE TABLE partidos(
    id_partidos INT NOT NULL AUTO_INCREMENT,
    fk_equipo_local INT NOT NULL,
    fk_equipo_visitante INT NOT NULL,
    goles_local INT NOT NULL DEFAULT 0,
    goles_visitante INT NOT NULL DEFAULT 0,
    fecha_partido DATETIME NOT NULL,
    CONSTRAINT pk_id_partidos PRIMARY KEY(id_partidos),
    CONSTRAINT fk_column_fk_equipo_local_to_table_equipos FOREIGN KEY(fk_equipo_local) REFERENCES equipos(id_equipos),
    CONSTRAINT fk_column_fk_equipo_visitante_to_table_equipos FOREIGN KEY(fk_equipo_visitante) REFERENCES equipos(id_equipos)
);

INSERT INTO equipos(nombre) VALUES('Barcelona'),
                                  ('Chacarita');

-- crear información para tabla jugadores Barcelona
INSERT INTO jugadores(fk_equipos, nombre, fecha_nacimiento)
VALUES(
    (SELECT id_equipos FROM equipos where nombre like '%Barcelona%'),
    'Ter Stegen',
    '1992-04-29 00:00:00'
),(
    (SELECT id_equipos FROM equipos where nombre like '%Barcelona%'),
    'Pique',
    '1987-02-01 00:00:00'
),
(
    (SELECT id_equipos FROM equipos where nombre like '%Barcelona%'),
    'Jordi Alba',
    '1989-03-20 00:00:00'
),
(
    (SELECT id_equipos FROM equipos where nombre like '%Barcelona%'),
    'Pedri',
    '2002-11-24 00:00:00'
);


-- crear información para tabla jugadores Chacarita
INSERT INTO jugadores(fk_equipos, nombre, fecha_nacimiento)
VALUES(
    (SELECT id_equipos FROM equipos where nombre like '%Chacarita%'),
    'Courtois',
    '1992-05-10 00:00:00'
),(
    (SELECT id_equipos FROM equipos where nombre like '%Chacarita%'),
    'Carvajal',
    '1992-01-10 00:00:00'
),
(
    (SELECT id_equipos FROM equipos where nombre like '%Chacarita%'),
    'Kroos',
    '1990-01-03 00:00:00'
),
(
    (SELECT id_equipos FROM equipos where nombre like '%Chacarita%'),
    'Hazard',
    '1991-01-06 00:00:00'
);



-- Partidos del barcelona
INSERT INTO partidos
(fk_equipo_local, fk_equipo_visitante, goles_local, goles_visitante, fecha_partido)
VALUES(
    (SELECT id_equipos FROM equipos where nombre like '%Barcelona%'),
    (SELECT id_equipos FROM equipos where nombre like '%Chacarita%'),
    3,
    1,
    '2016-01-01 00:00:00'
),
(
    (SELECT id_equipos FROM equipos where nombre like '%Barcelona%'),
    (SELECT id_equipos FROM equipos where nombre like '%Chacarita%'),
    1,
    2,
    '2016-02-11 00:00:00'
),
(
    (SELECT id_equipos FROM equipos where nombre like '%Barcelona%'),
    (SELECT id_equipos FROM equipos where nombre like '%Chacarita%'),
    5,
    0,
    '2017-01-11 00:00:00'
),

(
    (SELECT id_equipos FROM equipos where nombre like '%Barcelona%'),
    (SELECT id_equipos FROM equipos where nombre like '%Chacarita%'),
    2,
    0,
    '2021-05-11 00:00:00'
);

-- 
-- Partidos de “Chacarita”
INSERT INTO partidos
(fk_equipo_local, fk_equipo_visitante, goles_local, goles_visitante, fecha_partido)
VALUES(
    (SELECT id_equipos FROM equipos where nombre like '%Chacarita%'),
    (SELECT id_equipos FROM equipos where nombre like '%Barcelona%'),
    1,
    1,
    '2018-01-01 00:00:00'
),
(
    (SELECT id_equipos FROM equipos where nombre like '%Chacarita%'),
    (SELECT id_equipos FROM equipos where nombre like '%Barcelona%'),
    2,
    1,
    '2019-02-11 00:00:00'
),
(
    (SELECT id_equipos FROM equipos where nombre like '%Chacarita%'),
    (SELECT id_equipos FROM equipos where nombre like '%Barcelona%'),
    1,
    5,
    '2020-01-11 00:00:00'
),

(
    (SELECT id_equipos FROM equipos where nombre like '%Chacarita%'),
    (SELECT id_equipos FROM equipos where nombre like '%Barcelona%'),
    3,
    3,
    '2022-01-01 00:00:00'
);



-- Queries
    -- ¿Cuál es el jugador más viejo de cada equipo?
        SELECT  nombre as equipo , (
            SELECT
                j.nombre
            FROM jugadores j
            WHERE
                j.fk_equipos  = e.id_equipos
            ORDER  BY fecha_nacimiento ASC
            LIMIT 1
        ) as jugador_mas_viejo
        FROM equipos e ;
    -- Cuántos partidos jugó de visitante cada equipo? (nota: hay equipos no jugaron ningún partido)
    SELECT
        e.nombre  as equipo,
            (
                    SELECT
                    count(p.id_partidos)
                from
                    partidos p
                WHERE
                    p.fk_equipo_visitante  = e.id_equipos
            ) as cantidad_partidos_visitante
    FROM  equipos e ;

    -- ¿Qué equipos jugaron el 01/01/2016 y el 12/02/2016?
  SELECT DISTINCT equipos.nombre FROM (
        SELECT
            e.nombre
        FROM
            partidos p
            RIGHT JOIN equipos e ON e.id_equipos  = p.fk_equipo_local 
        WHERE
            p.fecha_partido BETWEEN '2016-01-01 00:00:00' AND '2016-02-12 23:59:59'
        UNION ALL
        SELECT
            e.nombre
        FROM
            partidos p
            RIGHT JOIN equipos e ON e.id_equipos  = p.fk_equipo_visitante
        WHERE p.fecha_partido   BETWEEN '2016-01-01 00:00:00' AND '2016-02-12 23:59:59'

    ) AS equipos


-- Diga el total de goles que hizo el equipo “Chacarita” en su historia (como local o visitante)

SELECT
    SUM(
        (
            SELECT
                SUM(p.goles_local)
            FROM
                partidos p
            WHERE p.fk_equipo_local  = e.id_equipos
            GROUP BY  p.fk_equipo_local
        )+
        (
            SELECT
                SUM(p.goles_visitante)
            FROM 
                partidos p
            WHERE p.fk_equipo_visitante  = e.id_equipos
            GROUP  BY  p.fk_equipo_visitante
        )
    ) AS goles 
FROM equipos e WHERE e.nombre  = 'Chacarita';
 -- new line