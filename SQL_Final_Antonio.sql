EJERCICIOS
SQL BASES DE DATOS                Antonio Castillo Rocamora   1 DAM

Base de Datos Cine

Consultas sobre una sola tabla

1. Obtener ordenados ascendentemente los códigos de los países de donde son los actores.

    SELECT cod_pais
    FROM PAIS
    ORDER BY cod_pais ASC

2. Obtener el código y el título de las películas de año anterior a 1970 que no estén basadas en ningún libroordenadas por título.

    SELECT cod_peli, titulo
    FROM PELICULA
    WHERE anyo < 1970
    AND cod_lib IS NULL
    ORDER BY titulo

3. Obtener el código y el nombre de los actores cuyo nombre incluye “John”.

    SELECT cod_act, nombre
    FROM ACTOR
    WHERE nombre LIKE '%John%'

4. Obtener el código y el título de las películas de más de 120 minutos de la década de los 80.

    SELECT cod_peli, titulo
    FROM PELICULA
    WHERE duracion > 120
      AND anyo BETWEEN 1980 AND 1989

5. Obtener  el  código  y  el  título  de  las  películas  que  estén  basadas  en  algún  libro  y  cuyo director se apellide ‘Pakula’.

    SELECT cod_peli, titulo
    FROM PELICULA
    WHERE cod_lib IS NOT NULL
      AND director LIKE '%Paluka'

6. ¿Cuántas películas hay de más de 120 minutos de la década de los 80?

    SELECT COUNT(cod_peli)
    FROM PELICULA
    WHERE duracion > 120
      AND anyo BETWEEN 1980 AND 1989

7. ¿Cuántas películas se han clasificado de los géneros de código 'BB5' o 'GG4' o'JH6'?

    SELECT COUNT(cod_peli)
    FROM CLASIFICACION
    WHERE cod_gen = 'BB5'
      AND cod_gen = 'GG4'
      AND cod_gen = 'JH6'

8. ¿De que año es el libro más antiguo?

    SELECT MIN(anyo)
    FROM LIBRO

9. ¿Cuál es la duración media de las películas del año 1987?

    SELECT AVG(duracion)
    FROM PELICULA
    WHERE anyo = 1987

10. ¿Cuántos minutos ocupan todas las películas dirigidas por ‘Steven Spielberg’?

    SELECT SUM(duracion)
    FROM PELICULA
    WHERE director = 'Steven Spielberg' Consultas sobre varias tablas.

1. Obtener  el  código  y  el  título  de  las  películasen  las  que  actúa  un  actor  con  el  mismo nombre que el directorde la película (ordenadas por título).

    SELECT cod_peli, titulo
    FROM ACTOR A, PELICULA P, ACTUA C
    WHERE A.nombre = P.director
      AND P.cod_peli = C.cod_peli
      AND C.cod_act = A.cod_act

    2. Obtener el código y el título de las películas clasificadas del género de nombre ‘Comedia’ (ordenadas por título).

        SELECT cod_peli
        , titulo
    FROM PELICULA P, CLASIFICACION C, GENERO G
    WHERE G.nombre = 'Comedia'
      AND P.cod_peli = C.cod_peli
      AND C.cod_gen = G.cod_gen
    ORDER BY titulo

    3. Obtener el código y el título de las películas basadas en algún libro anterior a 1950.

    SELECT cod_peli, titulo
    FROM PELICULA P,
         LIBRO L
    WHERE L.anyo < 1950
      AND P.cod_lib = L.cod_lib

4. Obtener  el  código  y  el  nombre  de  los  países  de  los  actores  que  actúan  en  películas clasificadas del género de nombre ‘Comedia’ (ordenados por nombre).

    SELECT cod_pais, nombre
    FROM PAIS P, ACTOR A, ACTUA C, PELICULA P, CLASIFICACION I, GENERO G
    WHERE G.nombre = 'Comedia'
      AND P.cod_pais = A.cod_pais
      AND A.cod_act = C.cod_act
      AND C.cod_peli = P.cod_peli
      AND P.cod_peli = I.cod_peli
      AND I.cod_gen = G.cod_gen
    ORDER BY P.nombre

Consultas con subconsultas.

1.Resolver los ejercicios anteriores con subconsultas

    SELECT cod_peli, titulo
    FROM PELICULA P
    WHERE cod_peli IN (
        SELECT cod_peli
        FROM ACTUA
        WHERE cod_act IN (
            SELECT cod_act
            FROM ACTOR A
            WHERE A.nombre = P.director
        )
    );

    SELECT cod_peli, titulo
    FROM PELICULA
    WHERE cod_peli IN (
        SELECT cod_peli
        FROM CLASIFICACION
        WHERE cod_gen IN (
            SELECT cod_gen
            FROM GENERO
            WHERE nombre = 'Comedia'
        )
    );

    SELECT cod_peli, titulo
    FROM PELICULA
    WHERE cod_lib IN (
        SELECT cod_lib
        FROM LIBRO
        WHERE anyo < 1950
    );

    SELECT cod_pais, nombre
    FROM PAIS
    WHERE cod_pais IN (
        SELECT cod_pais
        FROM ACTOR
        WHERE cod_act IN (
            SELECT cod_act
            FROM ACTUA
            WHERE cod_peli IN (
                SELECT cod_peli
                FROM CLASIFICACION
                WHERE cod_gen IN (
                    SELECT cod_gen
                    FROM GENERO
                    WHERE nombre = 'Comedia'
                )
            )
        )
    );

2. Obtener el código y el nombre de los actores nacidos antes de 1950 que actúan con un papel ‘Principal’en alguna película (ordenados por nombre).

    SELECT cod_act, nombre
    FROM ACTORES
    WHERE anyo < 1950
    AND cod_act IN(
        SELECT cod_act
        FROM ACTUA
        WHERE papel = 'Principal'
        AND cod_peli >= 1
    )
    ORDER BY nombre;

3. Obtener elcódigo, el título y el autor de los libros en los que se ha basado alguna película de la décadade los 90 (ordenados por título).

    SELECT cod_lib, titulo, autor
    FROM LIBRO
    WHERE cod_lib IN(
        SELECT cod_lib
        FROM PELICULA
        WHERE anyo BETWEEN 1990 AND 1999
    )
    ORDER BY titulo;

4. Obtener el código, el título yel autor de los libros en los que no se haya basado ninguna película.

    SELECT cod_lib, titulo, autor
    FROM LIBRO
    WHERE cod_lib NOT IN(
        SELECT *
        FROM PELICULA
    );

5. Obtener el nombre del género o géneros a los que pertenecen películas en las que no actúa ningún actor(ordenados por nombre).

    SELECT nombre
    FROM GENERO
    WHERE cod_gen IN(
        SELECT cod_gen
        FROM CLASIFICACION
        WHERE cod_peli IN(
            SELECT cod_peli
            FROM PELICULA
            WHERE cod_peli NOT IN(
                SELECT cod_peli
                FROM ACTUA
            )
        )
    )
ORDER BY nombre;

6. Obtener el título  de  los libros en los que  se  haya basado alguna película en la que  no hayan actuadoactores del país de nombre ‘USA’ (ordenados por título).

    SELECT titulo
    FROM LIBRO
    WHERE cod_lib IN(
        SELECT cod_lib
        FROM PELICULA
        WHERE cod_lib is not null
        AND cod_peli in(
            SELECT cod_peli
            FROM ACTUA
            WHERE cod_act in(
                SELECT cod_act
                FROM ACTOR
                WHERE cod_pais not in(
                    SELECT cod_pais
                    FROM PAIS
                    WHERE nombre = 'USA'
                )
            )
        )
    )
ORDER BY titulo;

7. ¿Cuántas películas hay clasificadas del género de nombre ‘Comedia’ y en las que sólo aparece un actor con el papel ‘Secundario’?

    SELECT COUNT(cod_gen)
    FROM GENERO
    WHERE cod_gen IN (
        SELECT cod_gen
        FROM CLASIFICACION
        WHERE cod_peli IN (
            SELECT cod_peli
            FROM PELICULA
            WHERE cod_peli IN (
                SELECT cod_peli
                FROM ACTUA
                WHERE papel = 'Secundario'
            )
        )
    );

8. Obtener el año de la primera película en la que el actor de nombre ‘Jude Law’ tuvo un papel como‘Principal’.

    SELECT MIN(anyo)
    FROM PELICULA
    WHERE cod_peli IN(
        SELECT cod_peli
        FROM ACTUA
        WHERE papel = 'Principal'
        AND cod_act IN(
            SELECT cod_act
            FROM ACTOR
            WHERE nombre = 'Jude Law'
        )
    );

9. Obtener el código y el nombre de actor o actores más viejos.

    SELECT cod_act, nombre
    FROM ACTOR
    WHERE cod_act IN (
        SELECT MIN(fecha_nac)
        FROM ACTOR
    );

10. Obtener el código, el nombre y la fecha de nacimiento del actor más viejo nacido en el año 1940.

    SELECT cod_act, nombre, fecha_nac
    FROM ACTOR A
    WHERE fecha_nac = 1940
      AND cod_act IN (
        SELECT MIN(fecha_nac)
        FROM ACTOR A2
        WHERE A2.cod_act = A.cod_act
    );

11. Obtener el nombre del género (o de los géneros) en los que se ha clasificado la película más larga.

    SELECT nombre
    FROM GENERO
    WHERE cod_gen IN(
        SELECT cod_gen
        FROM CLASIFICACION C
        WHERE cod_peli IN(
            SELECT MAX(duracion)
            FROM PELICULA P
            WHERE P.cod_peli = C.cod_peli
        )
    );

12. Obtener el código y el título de los libros en los que se han basado películas en las que actúan actores delpaís de nombre España (ordenados por título).

    SELECT cod_lib
    FROM LIBRO L
    WHERE cod_lib IN(
        SELECT cod_lib
        FROM PELICULA
        WHERE cod_peli IN(
            SELECT cod_peli
            FROM ACTUA
            WHERE cod_act IN(
                SELECT cod_act
                FROM ACTOR
                WHERE cod_pais IN(
                    SELECT cod_pais
                    FROM PAIS
                    WHERE nombre = 'España'
                )
            )
        )
    )
ORDER BY L.titulo;

13. Obtener  el  título  de  las  películas  anteriores  a  1950  clasificadas  en  más  de  un  género (ordenadas portítulo).

    SELECT titulo
    FROM PELICULA
    WHERE anyo < 1950
    AND cod_peli IN(
        SELECT cod_peli
        FROM CLASIFICACION
        WHERE 1 > (
            SELECT cod_gen
            FROM GENERO
        )
    );

14. Obtener la cantidad de películas en las que han participado menos de 4 actores.

    SELECT COUNT (*)
    FROM PELICULA
    WHERE 4 < (
        SELECT COUNT (*)
        FROM actua
        WHERE pelicula.cod_peli = actua.cod_peli
    );

15. Obtener los directores que han dirigido más de 250 minutos entre todas sus películas.

    SELECT director
    FROM PELICULA P
    WHERE 250 > (
        SELECT SUM (duracion)
        FROM PELICULA
        WHERE director = P.director
    );

16. Obtener el año o años en el que nacieron más de 3 actores.

    SELECT fecha_nac
    FROM ACTOR A
    WHERE 3 > (
        SELECT COUNT (cod_act)
        FROM ACTOR A2
        WHERE A2.fecha_nac = A.fecha_nac
    );

17. Obtener  el  código  y  nombre  del  actor  más  joven  que  ha  participado  en  una  película clasificada del génerode código ‘DD8’.

    SELECT cod_act, nombre
    FROM ACTOR

Consultas unificanmente adsads

3.

    SELECT a.cod_act, a.nombre
    FROM ACTOR A
    WHERE EXISTS (
        SELECT *
        FROM PELICULA
        WHERE director = 'Guy Ritchie'
        AND cod_peli IN(
            SELECT cod_peli
            FROM ACTUA X2
            WHERE A.cod_act = X2.cod_act
        )
    )AND NOT EXISTS (
        SELECT *
        FROM PELICULA P
        WHERE P.director = 'Guy Ritchie'
        AND P.cod_peli NOT IN (
            SELECT cod_peli
            FROM ACTUA X3
            WHERE A.cod_act = X3.cod_act
            )
    );


Consultas agrupadas

1. Obtener el código y el título del libro o libros en que se ha basado más de una película, indicando cuántaspelículas se han hecho sobre él.

    SELECT cod_lib, titulo, COUNT(P.cod_peli)
    FROM LIBRO L, PELICULA P
    WHERE L.cod_lib = P.cod_lib
    GROUP BY cod_lib, titulo
    HAVING COUNT(P.cod_lib) > 1

2. Obtener para cada género en el que se han clasificado más de 5 películas, el código y el nombre delgénero indicando la cantidad de películas del mismo y duración media de sus  películas.  (Ordenados  pornombre). (La  función  ROUND  redondea  al  entero  más cercano).

    SELECT cod_gen, nombre, COUNT(cod_peli), ROUND(AVG(duracion))
    FROM GENERO G, CLASIFICACION C, PELICULA P
    WHERE G.cod_gen = C.cod_gen
    AND C.cod_peli = P.cod_peli
    GROUP BY cod_gen
    HAVING COUNT(C.cod_peli) > 5
    ORDER BY nombre

3. Obtener el código y el título de las películas de año posterior al 2000 junto con el número de géneros enque están clasificadas, si es que están en alguno. (Ordenadas por título).

    SELECT cod_peli, titulo, COUNT(cod_gen)
    FROM PELICULA P, CLASIFICACION C
    WHERE anyo < 2000
    AND P.cod_peli = C.cod_peli
    GROUP BY cod_peli
    ORDER BY titulo

4. Obtener los directores que tienen la cadena ‘George’ en su nombre y que han dirigido exactamente dospelículas.

    SELECT director, titulo
    FROM PELICULA
    WHERE director LIKE 'George%'
    GROUP BY director
    HAVING COUNT(cod_peli) = 2

5. Obtener  para  cada  película  clasificada  exactamente  en  un  género  y  en  la  que  haya actuado algún actor,el código, el título y la cantidad de actores que actúan en ella.

    SELECT cod_peli, titulo, COUNT(cod_act)
    FROM PELICULA P, CLASIFICACION C, ACTUA A
    WHERE P.cod_peli = C.cod_peli
    AND P.cod_peli = A.cod_peli
    GROUP BY cod_peli
    HAVING COUNT(cod_gen) = 1
    AND COUNT(cod_act) >= 1

6. Obtener el código y el nombre de todos los países con actores indicando cuántos actores de cada paíshan actuado en al menos una película de la década de los 60.

    SELECT cod_pais, nombre, COUNT(cod_act)
    FROM PAIS P,
         ACTOR A,
         ACTUA C,
         PELICULA E
    WHERE P.cod_pais = A.cod_pais
      AND A.cod_act = C.cod_act
      AND C.cod_peli = E.cod_peli
      AND E.anyo BETWEEN 1950 AND 1959
    GROUP BY cod_pais
    HAVING COUNT(DISTINCT cod_act) > 0

7. Obtener el código, el nombre del género en el que hay clasificadas más películas (puede haber más deuno).

    SELECT cod_gen, nombre
    FROM GENERO G,
        CLASIFICACION C
    WHERE G.cod_gen = C.cod_gen
    GROUP BY cod_gen
    HAVING MAX (cod_peli)

8.

Consultas con concatencion

1. Obtener  para  todos  los  países  que  hay  en  la  base  de  datos,  el  código,  el  nombre  y  la cantidad de actoresque hay de ese país.

    SELECT cod_pais, nombre, COUNT (cod_act)
    FROM PAIS LEFT JOIN ACTOR
    ON PAIS.cod_pais = ACTOR.cod_pais

2. Obtener el código y el título de todos los libros de la base de datos de año posterior a 1980 junto con lacantidad de películas a que han dado lugar.

    SELECT cod_lib, titulo, COUNT (cod_peli)
    FROM LIBRO L LEFT JOIN PELICULA P
    ON L.cod_lib = P.cod_lib
    WHERE anyo > 1980

3. Obtener  para  todos  los  países  que  hay  en  la  base  de  datos,  el  código,  el  nombre  y  la cantidad de actoresque hay de ese país que hayan tenido un papel como “Secundario” en alguna película.

    SELECT cod_pais, nombre, COUNT (cod_act)
    FROM PAIS P LEFT JOIN ACTOR A
    ON P.cod_pais = A.cod_pais
    WHERE cod_act IN(
        SELECT cod_act
        FROM ACTUA
        WHERE papel = 'Secundario'
    );

4. Obtener para cada película que hay en la base de datos que dure más de 140 minutos, el código, el título,la cantidad de  géneros en los que está clasificado y la cantidad de actores que han actuado en ella.

    SELECT cod_peli, titulo, COUNT (cod_gen), COUNT (cod_act)
    FROM PELICULA P (LEFT JOIN CLASIFICACION C ON P.cod_peli = C.cod_peli)
    LEFT JOIN ACTUA A ON P.cod_peli = A.cod_peli
    WHERE duracion > 140
    GROUP BY cod_peli, titulo

Conjuntistas

1. Obtener los años, ordenados ascendentemente, que aparecen en la base de datos como año en el quese editó un libro o se filmó una película. Sólo interesan años en los que no aparezca el dígito 9.


UNION

Base de Datos Musica

Consultas agrupadas

1.

    SELECT G.nombre, SUM(C.num)
    FROM GRUPO G, CLUB C
    WHERE G.cod_gru = c.cod_gru
    AND G.pais = 'España'
    GROUP BY G.cod_nombre

Consultas generales

6.

SELECT nombre, num
FROM CLUB C1
WHERE 9 = (
    SELECT COUNT(DISTINCT (cod))
    FROM CLUB C2
    WHERE C2.num > C1.num
);

Base de Datos Ciclismo

Consultas Generales

3.

EXISTS Y NOT IN

5.

    SELECT dorsal, nombre
    FROM CICLISTA
    WHERE dorsal NOT IN(
        SELECT dorsal
        FROM LLEVAR
        WHERE codigo IN(
            SELECT codigo
            FROM LLEVAR
            WHERE dorsal = 20
            )
        );


