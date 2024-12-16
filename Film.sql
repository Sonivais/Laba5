-- DROP SCHEMA public;

CREATE SCHEMA public AUTHORIZATION pg_database_owner;

COMMENT ON SCHEMA public IS 'standard public schema';

-- DROP SEQUENCE isaeva_225_film_film_id_seq;

CREATE SEQUENCE isaeva_225_film_film_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32767
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE isaeva_225_film_film_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE isaeva_225_film_film_id_seq TO postgres;

-- DROP SEQUENCE isaeva_225_hall_id_hall_seq;

CREATE SEQUENCE isaeva_225_hall_id_hall_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32767
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE isaeva_225_hall_id_hall_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE isaeva_225_hall_id_hall_seq TO postgres;

-- DROP SEQUENCE isaeva_225_screening_screening_id_seq;

CREATE SEQUENCE isaeva_225_screening_screening_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 32767
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE isaeva_225_screening_screening_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE isaeva_225_screening_screening_id_seq TO postgres;
-- public."ISaeva_225_film" определение

-- Drop table

-- DROP TABLE "ISaeva_225_film";

CREATE TABLE "ISaeva_225_film" (
	film_id int2 DEFAULT nextval('isaeva_225_film_film_id_seq'::regclass) NOT NULL,
	"name" varchar NOT NULL,
	description varchar(150) NULL,
	CONSTRAINT isaeva_225_film_pk PRIMARY KEY (film_id)
);

-- Permissions

ALTER TABLE "ISaeva_225_film" OWNER TO postgres;
GRANT ALL ON TABLE "ISaeva_225_film" TO postgres;


-- public."ISaeva_225_hall" определение

-- Drop table

-- DROP TABLE "ISaeva_225_hall";

CREATE TABLE "ISaeva_225_hall" (
	id_hall int2 DEFAULT nextval('isaeva_225_hall_id_hall_seq'::regclass) NOT NULL,
	"name" varchar NULL,
	CONSTRAINT isaeva_225_hall_pk PRIMARY KEY (id_hall)
);

-- Permissions

ALTER TABLE "ISaeva_225_hall" OWNER TO postgres;
GRANT ALL ON TABLE "ISaeva_225_hall" TO postgres;


-- public."ISaeva_225_hall_row" определение

-- Drop table

-- DROP TABLE "ISaeva_225_hall_row";

CREATE TABLE "ISaeva_225_hall_row" (
	hall_id int2 NOT NULL,
	"number" int4 NULL,
	capasity int4 NULL,
	CONSTRAINT isaeva_225_hall_row_isaeva_225_hall_fk FOREIGN KEY (hall_id) REFERENCES "ISaeva_225_hall"(id_hall) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Permissions

ALTER TABLE "ISaeva_225_hall_row" OWNER TO postgres;
GRANT ALL ON TABLE "ISaeva_225_hall_row" TO postgres;


-- public."ISaeva_225_screening" определение

-- Drop table

-- DROP TABLE "ISaeva_225_screening";

CREATE TABLE "ISaeva_225_screening" (
	screening_id int2 DEFAULT nextval('isaeva_225_screening_screening_id_seq'::regclass) NOT NULL,
	hall_id int2 NOT NULL,
	film_id int2 NOT NULL,
	"time" time NULL,
	CONSTRAINT isaeva_225_screening_pk PRIMARY KEY (screening_id),
	CONSTRAINT isaeva_225_screenin_isaeva_225_hall_fk FOREIGN KEY (hall_id) REFERENCES "ISaeva_225_hall"(id_hall) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT isaeva_225_screening_isaeva_225_film_fk FOREIGN KEY (film_id) REFERENCES "ISaeva_225_film"(film_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Permissions

ALTER TABLE "ISaeva_225_screening" OWNER TO postgres;
GRANT ALL ON TABLE "ISaeva_225_screening" TO postgres;


-- public."ISaeva_225_tickets" определение

-- Drop table

-- DROP TABLE "ISaeva_225_tickets";

CREATE TABLE "ISaeva_225_tickets" (
	id_screening int2 NOT NULL,
	"row" int4 NOT NULL,
	seat int4 NOT NULL,
	"cost" int4 NULL,
	CONSTRAINT isaeva_225_tickets_pk PRIMARY KEY (id_screening),
	CONSTRAINT isaeva_225_tickets_unique UNIQUE ("row", seat),
	CONSTRAINT isaeva_225_tickets_isaeva_225_screening_fk FOREIGN KEY (id_screening) REFERENCES "ISaeva_225_screening"(screening_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Permissions

ALTER TABLE "ISaeva_225_tickets" OWNER TO postgres;
GRANT ALL ON TABLE "ISaeva_225_tickets" TO postgres;


-- public.cinema исходный текст

CREATE OR REPLACE VIEW cinema
AS SELECT "ISaeva_225_hall".name AS "Зал",
    "ISaeva_225_film".name AS "Название фильма",
    "ISaeva_225_screening"."time" AS "Воемя начада фильма"
   FROM "ISaeva_225_screening"
     JOIN "ISaeva_225_hall" ON "ISaeva_225_hall".id_hall = "ISaeva_225_screening".hall_id
     JOIN "ISaeva_225_film" ON "ISaeva_225_film".film_id = "ISaeva_225_screening".film_id
  WHERE "ISaeva_225_screening".film_id = 4;

-- Permissions

ALTER TABLE cinema OWNER TO postgres;
GRANT ALL ON TABLE cinema TO postgres;


-- public.film__ исходный текст

CREATE OR REPLACE VIEW film__
AS SELECT "ISaeva_225_hall".name AS "Зал",
    "ISaeva_225_film".name AS "Название ",
    "ISaeva_225_screening"."time" AS "начало фильма"
   FROM "ISaeva_225_screening"
     JOIN "ISaeva_225_hall" ON "ISaeva_225_hall".id_hall = "ISaeva_225_screening".hall_id
     JOIN "ISaeva_225_film" ON "ISaeva_225_film".film_id = "ISaeva_225_screening".film_id
  WHERE "ISaeva_225_screening".hall_id = 3;

-- Permissions

ALTER TABLE film__ OWNER TO postgres;
GRANT ALL ON TABLE film__ TO postgres;


-- public.hall_three_row_two исходный текст

CREATE OR REPLACE VIEW hall_three_row_two
AS SELECT "ISaeva_225_hall".name AS "Номер зала",
    "ISaeva_225_hall_row".number AS "Номер ряда",
    "ISaeva_225_hall_row".capasity AS "Количество мест"
   FROM "ISaeva_225_hall_row"
     JOIN "ISaeva_225_hall" ON "ISaeva_225_hall".id_hall = "ISaeva_225_hall_row".hall_id
  WHERE "ISaeva_225_hall".name::text = 'детский'::text AND "ISaeva_225_hall_row".number = 2;

-- Permissions

ALTER TABLE hall_three_row_two OWNER TO postgres;
GRANT ALL ON TABLE hall_three_row_two TO postgres;


-- public.late_movies исходный текст

CREATE OR REPLACE VIEW late_movies
AS SELECT "ISaeva_225_film".name AS "Название фильма",
    "ISaeva_225_screening"."time" AS "Время показа фильма"
   FROM "ISaeva_225_screening"
     JOIN "ISaeva_225_film" ON "ISaeva_225_film".film_id = "ISaeva_225_screening".film_id
  WHERE "ISaeva_225_screening"."time" > '11:00:00'::time without time zone;

-- Permissions

ALTER TABLE late_movies OWNER TO postgres;
GRANT ALL ON TABLE late_movies TO postgres;



-- DROP FUNCTION public.salary_check();

CREATE OR REPLACE FUNCTION public.salary_check()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin 
	new.salary = new.price_reception * (new.percentage_salary/100) * 0.87;
return new;
end
$function$
;

-- Permissions

ALTER FUNCTION public.salary_check() OWNER TO postgres;
GRANT ALL ON FUNCTION public.salary_check() TO postgres;


-- Permissions

GRANT ALL ON SCHEMA public TO pg_database_owner;
GRANT USAGE ON SCHEMA public TO public;

INSERT INTO public."ISaeva_225_film" (film_id,"name",description) VALUES
	 (9,'Человек-дьявол','Из плаксы в красавчика'),
	 (10,'Спираль','Узумаки'),
	 (11,'Звездное дитя','История про парня который хотел отомстить своему отцу и о девочке которая хотела стать айдолом как её покойная мать'),
	 (12,'Башня бога','Парень поднимается по башне в надежде встреть девушку которая его предала'),
	 (14,'Берсерк','Мужик который выжил '),
	 (15,'Евангелион','Мальчик - плакса спасает мир'),
	 (16,'Наруто','Глупы мальчик который мечтает стать хокаге'),
	 (17,'Сказка о Хвосте Феи','Веселые приключения гильдии пьяниц'),
	 (18,'Ниндзя камуи','Месть за семью'),
	 (13,'Меч и жезл Вистории ','Вперед за юбкой!');
INSERT INTO public."ISaeva_225_hall" (id_hall,"name") VALUES
	 (1,'А1'),
	 (2,'А2'),
	 (3,'А3'),
	 (4,'B1'),
	 (5,'B2'),
	 (6,'B3'),
	 (9,'Вип'),
	 (10,'Вип++'),
	 (7,'С1'),
	 (8,'С2');
INSERT INTO public."ISaeva_225_hall_row" (hall_id,"number",capasity) VALUES
	 (1,22,600),
	 (2,7,550),
	 (4,11,900),
	 (6,4,666),
	 (8,10,400),
	 (3,5,100),
	 (5,8,800),
	 (9,17,1500),
	 (10,14,2500),
	 (7,8,400);
INSERT INTO public."ISaeva_225_screening" (screening_id,hall_id,film_id,"time") VALUES
	 (10,2,9,'10:00:00'),
	 (11,3,18,'15:00:00'),
	 (12,5,11,'20:30:00'),
	 (13,10,15,'09:00:00'),
	 (14,7,12,'11:00:00'),
	 (15,1,13,'21:00:00'),
	 (16,8,10,'08:00:00'),
	 (17,4,17,'14:00:00'),
	 (18,9,14,'18:00:00'),
	 (19,6,16,'12:00:00');
INSERT INTO public."ISaeva_225_tickets" (id_screening,"row",seat,"cost") VALUES
	 (10,2,3,300),
	 (11,1,9,100);
