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

Consultas universalmente cuantificadas

1. Obtener el código y el nombre de los países con actores y tales que todos los actores de ese país hannacido en el siglo XX (ordenados por nombre).

    SELECT cod_pais, nombre
    FROM PAIS
    WHERE NOT EXISTS (
        SELECT *
        FROM ACTOR
        WHERE fecha_nac < 1/1/1900 or fecha_nac > 1/1/2000
        AND PAIS.cod_pais = ACTOR.cod_pais
    )AND EXISTS (
        SELECT *
        FROM ACTOR
        WHERE PAIS.cod_pais = ACTOR.cod_pais
    )
    ORDER BY nombre;

2. Obtener el código y el nombre de los actores tales que todos los papeles que han tenido son  de‘Secundario’. Sólo interesan aquellos actores que hayan actuado en alguna película.

    SELECT cod_act, nombre
    FROM ACTOR
    WHERE EXISTS (
        SELECT *
        FROM ACTUA
        WHERE papel = 'Secundario'
        AND cod_peli IN(
            SELECT cod_peli
            FROM PELICULA
        )
    )AND NOT EXISTS (
        SELECT *
        FROM ACTUA
        WHERE papel = 'Secundario'
        AND cod_peli NOT IN(
            SELECT cod_peli
            FROM PELICULA
        )
    );

3. Obtener el código y el nombre de los actores que han aparecido en todas las películas del director 'Guy Ritchie' (sólo si ha dirigido al menos una).

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

4. Resolver la consulta, pero para el director de nombre 'John Steel'

    SELECT a.cod_act, a.nombre
    FROM ACTOR A
    WHERE EXISTS (
            SELECT *
            FROM PELICULA
            WHERE director = 'John Steel'
              AND cod_peli IN(
                SELECT cod_peli
                FROM ACTUA X2
                WHERE A.cod_act = X2.cod_act
            )
        )AND NOT EXISTS (
            SELECT *
            FROM PELICULA P
            WHERE P.director = 'John Steel'
              AND P.cod_peli NOT IN (
                SELECT cod_peli
                FROM ACTUA X3
                WHERE A.cod_act = X3.cod_act
            )
    );

5. Obtener el codigo y el titulo de las peliculas de menos de 100 minutos en las que todos los actores que han actuado son de un mismo pais.

    SELECT cod_peli, titulo
    FROM PELICULA
    WHERE EXISTS(
        SELECT *
        FROM PELICULA
        WHERE duracion < 100
        AND cod_peli IN(
            SELECT cod_peli
            FROM ACTUA
            WHERE cod_act IN(
                SELECT cod_act
                FROM ACTORES A
                WHERE cod_pais IN(
                    SELECT DISTINCT(cod_pais)
                    FROM PAIS P
                    WHERE P.cod_pais = A.cod_pais
                )
            )
    )
    )AND NOT EXISTS(
        SELECT *
        FROM PELICULA
        WHERE duracion < 100
        AND cod_peli IN(
            SELECT cod_peli
            FROM ACTUA
            WHERE cod_act IN(
                SELECT cod_act
                FROM ACTORES A
                WHERE cod_pais IN(
                    SELECT DISTINCT(cod_pais)
                    FROM PAIS P
                    WHERE P.cod_pais <> A.cod_pais
                )
            )
        )
    );

6. Obtener el código, el título y el año de las películas en las que haya actuado algún actor si  se  cumple  quetodos  los  actores  que  han  actuado en  ella  han  nacido  antes  del  año 1943 (hasta el 31/12/1942).

    SELECT cod_peli, titulo, anyo
    FROM PELICULA
    WHERE EXISTS(
        SELECT *
        FROM PELICULA
        WHERE cod_peli IN(
            SELECT cod_peli
            FROM ACTUA
            WHERE cod_act IN(
                SELECT cod_act
                FROM ACTOR
                WHERE fecha_nac < 01/01/1943
            )
        )
    )AND NOT EXISTS(
        SELECT *
        FROM PELICULA
        WHERE cod_peli IN(
            SELECT cod_peli
            FROM ACTUA
            WHERE cod_act IN(
                SELECT cod_act
                FROM ACTOR
                WHERE fecha_nac > 01/01/1943
            )
        )
    );

7. Obtener  el  código y  el  nombre  de  cada  país  si  se  cumple  que  todos  sus  actores  han actuado en al menosuna película de más de 120 minutos. (Ordenados por nombre).

    SELECT cod_pais, nombre
    FROM PAIS
    WHERE EXISTS(
        SELECT *
        FROM ACTOR
        WHERE cod_act IN(
            SELECT cod_act
            FROM ACTUA
            WHERE cod_peli IN(
                SELECT cod_peli
                FROM PELICULA
                WHERE duracion< 120
            )
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

Consultas Generales

2. Obtener  el  nombre  del  género  (o  de  los  géneros)  a  los  que  pertenece  la  película  de duración máxima.

    SELECT nombre
    FROM GENERO
    WHERE cod_gen IN(
        SELECT cod_gen
        FROM CLASIFICACION
        WHERE cod_peli IN(
            SELECT cod_peli
            FROM PELICULA
            WHERE cod_peli =(
                SELECT MAX(duracion)
                FROM PELICULA
            )
        )
    );

3. Obtener,  para  cada  actor  nacido  antes  de  1948  y  que  haya  actuado  en  al  menos  2 películas en cualquier papel, el código, el nombre y la fecha de nacimiento indicando en cuántas películas ha actuado con elpapel de 'Principal'.

    SELECT cod_act, nombre, fecha_nac, COUNT (cod_peli)
    FROM ACTOR A (LEFT JOIN ACTUA C  ON A.cod_act = C.act)
    LEFT JOIN PELICULA P ON P.cod_act = A.cod_act
    WHERE fecha_nac < 1948
    AND papel = 'Principal'


Base de Datos Musica

Consultas sobre una relacion

1. ¿Cuantos discos hay?

    SELECT COUNT (cod)
    FROM DISCOS

2. Selecciona el nombre de los grupos que no sean de España.

    SELECT nombre
    FROM GRUPO
    WHERE pais <> 'España'

3. Obtener el título de las canciones con más de 5 minutos de duración.

    SELECT titulo
    FROM CANCION
    WHERE duracion > 5

4. Obtener la lista de las distintas funciones que se pueden realizar en un grupo.

    SELECT DISTINCT funcion
    FROM PERTENECE

5. Obtener  la  lista  de clubs  de  fans  junto  con  su  tamaño  (número  de  personas).  La  lista debe estar ordenadade menor a mayor según el tamaño del club.

    SELECT nombre, num
    FROM CLUB
    ORDER BY ASC

6. Selecciona el nombre y la sede de los clubes de fans con más de 500 socios.

    SELECT nombre, sede
    FROM CLUB
    WHERE num > 500

Consultas sobre varias relaciones

1. Obtener  el  nombre  y  la  sede  de  cada  club  de  fans  de  grupos  de  España  así  como  el nombre del grupo alque admiran.

    SELECT C.nombre, sede, G.nombre
    FROM CLUB C, GRUPO G
    WHERE C.cod_gru = G.cod
    AND G.pais = 'España'

2. Obtener el nombre de los artistas que pertenezcan a un grupo de España.

    SELECT nombre
    FROM ARTISTA A, PERTENECE P, GRUPO G
    WHERE A.dni = P.dni
    AND P.cod = G.cod
    AND G.pais = 'España'

3. Obtener  el  nombre  de  los  discos  que  contienen  alguna  canción  que  dure  más  de  5 minutos.

    SELECT D.nombre
    FROM DISCO D, ESTA E, CANCION C
    WHERE D.cod = E.cod
    AND E.can = C.cod
    AND C.duracion > 5

4. Obtener los nombres de las canciones que dan nombre al disco en el que aparecen.

    SELECT titulo
    FROM CANCION C, ESTA E, DISCO D
    WHERE C.cod = E.can
    AND E.cod = D.cod
    AND C.titulo = D.nombre

5. Obtener los nombres de compañías y direcciones postales de aquellas compañías que han grabado algún.

    SELECT nombre, dir
    FROM COMPANYIA C, DISCO D
    WHERE C.cod = D.cod_comp

6. DNI de los artistas que pertenecen a más de un grupo.

    SELECT dni
    FROM ARTISTA A, PERTENECE C
    WHERE A.dni = C.dni
    AND C.cod > 1

Consultas con subconsultas

1. Obtener el nombre de los discos del grupo más viejo.

    SELECT nombre
    FROM DISCO
    WHERE cod_gru IN(
        SELECT MIN(cod)
        FROM GRUPO
    );

2. Obtener el nombre de los discos grabados por grupos con club de fans con más de 5000 personas.

    SELECT nombre
    FROM DISCO
    WHERE cod_gru IN(
        SELECT cod
        FROM GRUPO
        WHERE cod IN(
            SELECT cod_gru
            FROM CLUB
            WHERE num > 5000
        )
    );

3. Obtener el nombre de los clubes con mayor número de fans indicando ese número.

    SELECT nombre, num
    FROM CLUB
    WHERE cod IN(
        SELECT MAX (num)
        FROM CLUB
    );

4. Obtener el título de las canciones de mayor duración indicando la duración.

    SELECT titulo, duracion
    FROM CANCION
    WHERE cod IN(
        SELECT MAX(duracion)
        FROM CANCION
    );

Consultas agrupadas

1. Obtener los nombres de los artistas de grupos con clubes de fans de más de 500 personas y que el grupo sea de Inglaterra.

    SELECT G.nombre, SUM(C.num)
    FROM GRUPO G, CLUB C
    WHERE G.cod_gru = C.cod_gru
    AND G.pais = 'España'
    GROUP BY G.cod_nombre

2. Obtener  para  cada grupo  con  más  de  dos  componentes  el  nombre  y  el  número  de componentes del grupo.

    SELECT G.nombre, COUNT(P.funcion)
    FROM GRUPO G, PERTENECE P
    WHERE G.cod = P.cod
    AND P.funcion > 2
    GROUP BY G.nombre

3. Obtener el número de discos de cada grupo.

    SELECT COUNT(D.cod)
    FROM DISCO D, GRUPO G
    WHERE D.cod_gru = G.cod
    GROUP BY D.cod

4. Obtener  el  número  de  canciones  que  ha  grabado  cada  compañía  discográfica  y  su dirección.

    SELECT C.nombre, COUNT(A.cod), C.dir
    FROM COMPANYIA C, DISCO D, ESTA E, CANCION A
    WHERE C.cod = D.cod_comp
    AND D.cod = E.cod
    AND E.can = A.cod
    GROUP BY C.nombre

Consultas generales

1. Obtener los nombres de los artistas de grupos con clubes de fans de más de 500 personas y que el grupo sea de Inglaterra.

    SELECT nombre
    FROM ARTISTA
    WHERE dni IN(
        SELECT dni
        FROM PERTENECE
        WHERE cod IN(
            SELECT cod
            FROM GRUPO
            WHERE pais = 'Inglaterra'
            AND cod IN(
                SELECT cod_gru
                FROM CLUB
                WHERE num > 500
            )
        )
    );

2. Obtener el título de las canciones de todos los discos del grupo U2.

    SELECT titulo
    FROM CANCION
    WHERE EXISTS (
        SELECT *
        FROM CANCION
        WHERE cod IN(
            SELECT can
            FROM ESTA
            WHERE cod IN(
                SELECT cod
                FROM DISCO
                WHERE cod_gru IN(
                    SELECT cod
                    FROM GRUPO
                    WHERE nombre = 'U2'
                )
            )
        )
    )WHERE NOT EXISTS (
        SELECT *
        FROM CANCION
        WHERE cod IN(
            SELECT can
            FROM ESTA
            WHERE cod IN(
                SELECT cod
                FROM DISCO
                WHERE cod_gru IN(
                    SELECT cod
                    FROM GRUPO
                    WHERE nombre != 'U2'
                )
            )
        )
    )

3. El dúo dinámico por fin se jubila; para sustituirles se pretende hacer una selección sobre todos los paresde artistas de grupos españoles distintos tales que el primero sea voz y el segundo guitarra. Obtenerdicha selección.

    SELECT nombre
    FROM GRUPO
    WHERE EXISTS(
        SELECT *
        FROM GRUPO
        WHERE cod IN(
            SELECT cod
            FROM PERTENECE
            WHERE dni IN(
                SELECT COUNT(dni)
                FROM PERTENECE
                WHERE dni = 2
                AND funcion = 'Voz'
            )
        )
    );

4. Obtener el nombre de los artistas que pertenecen a más de un grupo.



6. Obtener el décimo (debe haber sólo 9 por encima de él) club con mayor número de fans indicando esenúmero.

    SELECT nombre, num
    FROM CLUB C1
    WHERE 9 = (
        SELECT COUNT(DISTINCT (cod))
        FROM CLUB C2
        WHERE C2.num > C1.num
    );

Base de Datos Biblioteca

Consultas de una sola relacion

1. Obtener el nombre de los autores de nacionalidad ‘Argentina’.

    SELECT nombre
    FROM AUTOR
    WHERE nacionalidad = 'Argentina'

2. Obtener los títulos de las obras que contengan la palabra ‘mundo’.

    SELECT titulo
    FROM OBRA
    WHERE LIKE '%mundo%'

3. Obtener  el  identificador  de  los  libros  anteriores  a  1990  y  que  contengan más  de  una obra indicando elnúmero de obras que contiene.

    SELECT id_lib, num_obras
    FROM LIBRO
    WHERE año < 1990
    AND num_obras > 2

4. ¿Cuántos libros hay de los que se conozca el año de adquisición?

    SELECT COUNT(id_lib)
    FROM LIBRO
    WHERE año IS NOT NULL

5. ¿Cuántos libros tienen más de  una obra? Resolver este ejercicio utilizando el atributo num_obras.

    SELECT COUNT(id_lib)
    FROM LIBRO
    WHERE num_obra > 1

6. Obtener el identificador de los libros del año 1997 que no tienen título.

    SELECT id_lib
    FROM LIBRO
    WHERE año = '1997'
    AND titulo IS NULL

7. Mostrar todos los títulos de los libros que tienen título en orden alfabético descendente.

    SELECT titulo
    FROM LIBRO
    WHERE titulo IS NOT NULL
    ORDER BY DESC

8. Obtener cuántas obras hay en los libros publicados entre 1990 y 1999.

    SELECT num_obras
    FROM LIBRO
    WHERE año BETWEEN 1990 AND 1999

Consultas sobre varias relaciones

1. Obtener cuántos autores han escrito alguna obra con la palabra “ciudad” en su título.

    SELECT TCOUNT autot_id
    FROM AUTOR a, ESCRIBIR e, OBRA o
    WHERE a.autor_id = e.autor_id
    AND e.cod_ob = o.cod_ob
    AND o.titulo LIKE '%ciudad%'

2. Obtener el titulo de todas las obras escritas por el autor de nombre 'Camus, Albert'

    SELECT titulo
    FROM OBRA o, ESCRIBIR e, AUTOR a
    WHERE o.cod_ob = e.cod_ob
    AND e.autor_id = a.autor_id
    AND a.nombre = 'Camús' && 'Albert'


3. ¿Quien es el autor de la obra de titulo 'La tata'?

    SELECt nombre
    FROM AUTOR a, ESCRIBIR e, OBRA o
    WHERE a.autor_id = e.autor_id
    AND e.cod_ob = o.cod_ob
    AND o.titulo = 'La tata'

4. Obtener el nombre de los amigos que han leido alguna obra del autor de identificador 'RUKI'.

    SELECT DISTINCT nombre
    FROM AMIGO A, LEER L, OBRA O, ESCRIBIR E
    WHERE A.num = L.num
    AND L.cod_ob = O.cod_ob
    AND O.cod_ob = E.cod_ob
    AND E.autor_id = 'RUKI'

5. Obtener  el  título  y  el  identificador  de  los  libros  que  tengan  título  y  más  de  una  obra. Resolver esteejercicio sin utilizar el atributo num_obras.

    SELECT titulo, id_lib
    FROM LIBRO L, ESTA_EN S
    WHERE L.id_lib = S.id_lib
    AND S.cod_ob > 1
    AND titulo IS NOT NULL

Consultas con subconsultas

1. Obtener el título de las obras escritas sólo por un autor si éste es de nacionalidad “Francesa” indicandotambién el nombre del autor.

    SELECT o.titulo, a.nombre
    FROM OBRA o, AUTOR a
    WHERE cod_ob IN (
        SELECT cod_ob
        FROM ESCRIBIR
        WHERE autor_id IN (
        SELECT nombre
        FROM AUTOR
        WHERE nacionalidad = "francesa"
        )
    );

2. ¿Cuántos autores hay en la base de datos de los que no se tiene ninguna obra?

    SELECT COUNT (autor_id)
    FROM AUTOR
    WHERE autor_id NOT IN (
        SELECT autor_id
        FROM ESCRIBIR
    );

3. Obtener el nombre de esos autores.

    SELECT nombre
    FROM AUTOR
    WHERE autor_id NOT IN (
        SELECT autor_id
        FROM ESCRIBIR
    );

4. Obtener el nombre de los autores de nacionalidad “Española” que han escrito dos o más obras.

    SELECT nombre
    FROM AUTOR a
    WHERE nacionalidad = 'Española'
    AND 2 => IN (
        SELECT COUNT (cod_ob)
        FROM ESCRIBIR
        WHERE autor_id = a.autor_id
    );

5. Obtener el nombre de los autores de nacionalidad “Española” que han escrito alguna obra que está endos o más libros.

    SELECT nombre
    FROM AUTOR
    WHERE nacionalidad = 'Española'
    AND autor_id IN (
        SELECT autor_id
        FROM ESCRIBIR
        WHERE cod_ob IN (
            SELECT cod_ob
            FROM ESTA_EN
            WHERE id_lib
            AND => 2 IN (
                SELECT COUNT (id_lib)
                FROM LIBRO
            )
        )
    );

6. Obtener el título y el código de las obras que tengan más de un autor.

    SELECT titulo, a.cod_ob
    FROM OBRA a
    WHERE 1 < (
        SELECT cod_ob
        FROM ESCRIBIR
        WHERE cod_ob = a.cod_ob
    );

Consultas con cuantificacion universal

1. Obtener el nombre de los amigos que han leído todas las obras del autor de identificador ‘RUKI’.

    SELECT nombre
    FROM AMIGO a
    WHERE NOT EXISTS (
        SELECT *
        FROM ESCRIBIR
        WHERE autor_id = "RUKI"
        AND cod_ob NOT IN (
            SELECT cod_ob
            FROM LEER
            WHERE num = a.num
        )
    )AND EXISTS (
        SELECT *
        FROM ESCRIBIR NATURAL JOIN LEER
        WHERE autor_id = "RUKI"
        AND num = a.num
    )

2. Resolver de nuevo la consulta anterior,pero para el autor de identificador ‘GUAP’.

SELECT nombre
    FROM AMIGO a
    WHERE NOT EXISTS (
        SELECT *
        FROM ESCRIBIR
        WHERE autor_id = "GUAP"
        AND cod_ob NOT IN (
            SELECT cod_ob
            FROM LEER
            WHERE num = a.num
        )
    )AND EXISTS (
        SELECT *
        FROM ESCRIBIR NATURAL JOIN LEER
        WHERE autor_id = "GUAP"
        AND num = a.num
    )

3. Obtener el nombre de los amigos que han leído todas las obras de algún autor de los que hay en la tabla

    SELECT nombre
    FROM AMIGO a, LEER l, ESCRIBIR e
    WHERE a.num = l.num
    AND l.cod_ob = e.cod_ob
    AND NOT EXISTS (
        SELECT *
        FROM ESCRIBIR
        WHERE autor_id = e.autor_id
        AND cod_ob NOT IN (
            SELECT cod_ob
            FROM LEER
            num = a.num
        )
    );

5. Resolver la consulta anterior indicando también el nombre de ese autor.

    SELECT a.nombre, h.nombre
    FROM AMIGO a, LEER l, ESCRIBIR e, AUTOR h
    WHERE a.num = l.num
    AND l.cod_ob = e.cod_ob
    AND NOT EXISTS (
        SELECT *
        FROM ESCRIBIR
        WHERE autor_id = e.autor_id
        AND cod_ob NOT IN (
            SELECT cod_ob
            FROM LEER
            num = a.num
        )
    );

6. Obtener el nombre de los amigos que sólo han leído obras del autor de identificador ‘CAMA’.

SELECT nombre
FROM AMIGO
WHERE num NOT IN (
    SELECT num
    FROM LEER
    WHERE cod_ob NOT IN (
        SELECT cod_ob
        FROM ESCRIBIR
        WHERE autor_id = "CAMA"
    )
)AND num IN (
    SELECT num
    FROM LEER
);

7. Resolver de nuevo la consulta anterior,pero para el autor de identificador ‘GUAP’.



8. Obtener el nombre de los amigos tales que todas las obras que han leído son del mismo autor.

    SELECT nombre
    FROM AMIGO
    WHERE num IN (
        SELECT num
        FROM LEER
        WHERE cod_ob IN (
            SELECT cod_ob
            FROM ESCRIBIR e
            WHERE NOT EXISTS (
                SELECT *
                FROM ESCRIBIR
                WHERE e.autor_id <> autor_id
                AND cod_ob IN (
                    SELECT cod_ob
                    FROM LEER
                    WHERE num = AMIGO.num
                )
            )
        )
    );

9. Resolver la consulta anterior indicando también el nombre del autor.

    SELECT A.nombre, U.nombre
    FROM AMIGO A AUTOR U
    WHERE num IN (
        SELECT num
        FROM LEER
        WHERE cod_ob IN (
            SELECT cod_ob
            FROM ESCRIBIR e
            WHERE NOT EXISTS (
                SELECT *
                FROM ESCRIBIR
                WHERE e.autor_id <> autor_id
                AND cod_ob IN (
                    SELECT cod_ob
                    FROM LEER
                    WHERE num = A.num
                )
            )
        )
    );

10. Obtener el nombre de los amigos que han leído todas las obras de algún autor y no han leído nada deningún otro indicando también el nombre del autor.



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


