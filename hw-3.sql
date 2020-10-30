Создание бд:


CREATE TABLE "public"."students" (
    "id_student" SERIAL,
	"surname" TEXT NOT NULL,
    "name_of_student" TEXT NOT NULL,
    "patronymic" TEXT NOT NULL,
	"birthday" DATE NOT NULL,
	"email" TEXT NULL,
    PRIMARY KEY ("id_student")
);

CREATE TABLE "public"."courses" (
    "id_course" SERIAL,
    "name_of_course" TEXT NOT NULL,
    "start_date_course" DATE NOT NULL,
	"end_date_course" DATE NOT NULL,
    PRIMARY KEY ("id_course")
);
 
CREATE TABLE "public"."lectures" (
    "id_lecture" SERIAL,
    "name_of_lecture" TEXT NOT NULL,
    "produced_date" DATE NOT NULL,
	"id_course" INT4 NULL,
    PRIMARY KEY ("id_lecture"),
	CONSTRAINT lecture_unique UNIQUE (name_of_lecture),
	FOREIGN KEY (id_course) REFERENCES courses (id_course) ON DELETE CASCADE
	);
	
	CREATE TABLE "public"."journal" (
    "id_student" INT4 NOT NULL,
	"id_course" INT4 NOT NULL,
    CONSTRAINT "journal_pkey"
    PRIMARY KEY ("id_student","id_course"),
	
	CONSTRAINT "journal_fkey"
	FOREIGN KEY (id_student) REFERENCES STUDENTS (id_student) ON DELETE CASCADE,
	FOREIGN KEY (id_course) REFERENCES courses (id_course) ON DELETE CASCADE
);
	
	INSERT INTO "public"."courses" (
    "name_of_course",
    "start_date_course",
	"end_date_course"
)
VALUES
  ('Python','2020-08-16'::date,'2020-09-16'::date),
  ('Java','2020-09-15'::date,'2020-09-30'::date),
  ('Общий','2020-08-01'::date,'2020-08-16'::date),
  ('DevOps','2020-10-16'::date,'2020-11-30'::date),
  ('Testing','2020-10-25'::date,'2020-12-16'::date);
  
  INSERT INTO "public"."lectures" (
    "id_course",
    "name_of_lecture",
    "produced_date"
)
VALUES
  (1,'Python первая','2020-08-16'::date),
  (1,'Python вторая','2020-08-20'::date),
  (1,'Python третья','2020-09-16'::date),
  (2,'Java первая','2020-09-15'::date),
  (2,'Java вторая','2020-09-20'::date),
  (2,'Java третья','2020-09-30'::date),
  (3,'Общий первая','2020-08-01'::date),
  (3,'Общий вторая','2020-08-08'::date),
  (3,'Общий третья','2020-08-16'::date),
  (4,'DevOps первая','2020-10-16'::date),
  (4,'DevOps вторая','2020-10-31'::date),
  (4,'DevOps третья','2020-11-16'::date),
  (5,'Testing первая','2020-10-25'::date),
  (5,'Testing вторая','2020-11-16'::date),
  (5,'Testing третья','2020-12-16'::date);
   

INSERT INTO "public"."students" (
  "surname",
  "name_of_student",
  "patronymic",
  "birthday",
  "email"  
)
VALUES
  ('Аникеев', 'Станислав','Владимирович','1993-01-16'::date, 'Anikeev.S@mail.ru'),
  ('Ключук', 'Анна','Юрьевна','1993-10-07'::date, 'Klyuchuk.A@mail.ru'),
  ('Смолина', 'Юлия','Андреевна','1990-11-08'::date, 'Smolina.Y@gmail.com'),
  ('Иванов', 'Станислав','Иванович','1992-01-15'::date, 'Ivanov.S@gmail.com'),
  ('Петров', 'Александр','Игнатьевич','2003-11-06'::date, 'Petrov.A@yandex.ru'),
  ('Сидоров', 'Виктор','Олегович','2002-01-16'::date, 'Sidorov.V@mail.ru'),
  ('Емельянова', 'Татьяна','Егоровна','2001-12-18'::date, 'Andrianova.T@mail.ru'),
  ('Никонов', 'Андрей','Богданович','2004-01-31'::date, 'Silchenko.A@yandex.ru'),
  ('Егорова', 'Софья','Андреевна','2004-07-12'::date, 'Egorova.S@mail.ru'),
  ('Лешенко', 'Владимир','Александровчи','2002-01-16'::date, 'Lushenko.V@mail.ru');
  
    INSERT INTO "public"."journal" (
    "id_student",
    "id_course"
)
VALUES
  (1,1),
  (2,1),
  (2,2),
  (3,1),
  (4,1),
  (5,1),
  (6,4),
  (6,3),
  (7,1),
  (8,1),
  (8,5),
  (8,3),
  (9,1),
  (10,1);
  
### Запросы

4. Сделать выборку: сколько всего лекций послушает каждый студент

select s.surname, count (*) as lectures 
FROM students s
INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures USING (id_course)
	group by s.surname ORDER BY lectures desc;
	

5. Найти самые популярные лекции, которые увидит больше всего студентов

select l.name_of_lecture, count (*) as visitors 
FROM students s
INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures l USING (id_course)
	group by l.name_of_lecture ORDER BY visitors desc limit 3;

6. Найти наименее популярные лекции, которые увидит больше всего студентов

select name_of_lecture from (
select l.name_of_lecture, count (*) as quantity 
FROM students s
INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures l USING (id_course)
	group by l.name_of_lecture ORDER BY quantity limit 3) netrue limit 1 ;

7. Сделайте запрос с подзапросом, который выберет лекции, которые популярней среднего значения

select name_of_lecture, count_for_each  from 
(select COUNT(c.name_of_course) as count_for_each,l.name_of_lecture FROM students s 
INNER JOIN journal USING (id_student)
INNER JOIN courses c USING (id_course)
INNER JOIN lectures l USING (id_course)
group by l.name_of_lecture) number_1
where count_for_each >
(SELECT avg(new_column) from (select COUNT(c.name_of_course) as new_column
FROM students s
INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures l USING (id_course)
	group by l.name_of_lecture)	popul);
		
8. Выбрать все лекции, которые пройдут в рамках курсов, которые стартуют в текущем году

select l.name_of_lecture
FROM lectures l
INNER JOIN courses c USING (id_course)
where c.start_date_course > '2020-01-01';

9. Выберете средний год рождения студентов для каждого курса

select avg(birthday), course from (SELECT EXTRACT(YEAR FROM s.birthday) as birthday, c.name_of_course as course 
FROM students s
INNER JOIN journal USING (id_student)
INNER JOIN courses c USING (id_course)
INNER JOIN lectures l USING (id_course)) yulka
group by yulka.course;

10. Найдите все почты студентов для тех студентов, которые не зарегистрировались на самую непопулярную лекцию

select distinct email from students
INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures l USING (id_course)
 where l.id_lecture not in 
	(select l.id_lecture as new_name
FROM students s
INNER JOIN journal USING (id_student)
INNER JOIN courses c USING (id_course)
INNER JOIN lectures l USING (id_course)
group by l.id_lecture ORDER BY count (*) limit 1);
