7. Сделайте запрос с подзапросом, который выберет лекции, которые популярней среднего значения

select *from exam_results where result >(SELECT AVG(result) as avg FROM exam_results);

SELECT name_of_lecture where популярность > avg от всех лекций FROM lectures ;

1) запрос который возвращает count по каждой лекции:

select COUNT(c.name_of_course) as new_column, name_of_lecture
FROM students s
INNER JOIN journal USING (id_student)
INNER JOIN courses c USING (id_course)
INNER JOIN lectures l USING (id_course)
group by l.name_of_lecture;

2) найти среднее значение посетителей лекций: 
 
SELECT avg(new_column) from (select COUNT(c.name_of_course) as new_column
FROM students s
INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures l USING (id_course)
	group by l.name_of_lecture)	popul;
	
3) значение из первого запроса > avg
	
первым селектом мы вытаскиваем имя лекции
вторым мы счиатем сколько посетителей для каждой лекции
третий (после where)сравниваем его со среднем значением.


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
	
	





	
	select COUNT(c.name_of_course) as new_column
FROM students s
INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures l USING (id_course)
	group by l.name_of_lecture;
	
	
select COUNT(c.name_of_course) as new_column, name_of_lecture
FROM students s
INNER JOIN journal USING (id_student)
INNER JOIN courses c USING (id_course)
INNER JOIN lectures l USING (id_course)
group by l.name_of_lecture;

select COUNT(c.name_of_course) as new_column, name_of_lecture
FROM students s
INNER JOIN journal USING (id_student)
INNER JOIN courses c USING (id_course)
INNER JOIN lectures l USING (id_course)
group by l.name_of_lecture;

where new_column > 5;

select *from lectures where produced_date > '2020-01-01';

select *from courses where start_date_course > '2020-01-01';

select l.name_of_lecture
FROM lectures l
INNER JOIN courses c USING (id_course)
where c.start_date_course > '2020-01-01';

9. Выберете средний год рождения студентов для каждого курса 


SELECT EXTRACT(YEAR FROM s.birthday) as year FROM students s;

SELECT AVG(year) from (SELECT EXTRACT(YEAR FROM s.birthday) as year FROM students s) parameter;


сделать среднее по годам, сгруппированныхх по id курса

select avg(s.birthday) as birthday, c.name_of_course
FROM students s
INNER JOIN journal USING (id_student)
INNER JOIN courses c USING (id_course)
INNER JOIN lectures l USING (id_course)
group by c.name_of_course;

выбрали года участников для каждого курса:

SELECT EXTRACT(YEAR FROM s.birthday) as birthday, c.name_of_course
FROM students s
INNER JOIN journal USING (id_student)
INNER JOIN courses c USING (id_course)
INNER JOIN lectures l USING (id_course);

сделать запрос, который использует эту выборку
select avg(birthday), course from (SELECT EXTRACT(YEAR FROM s.birthday) as birthday, c.name_of_course as course 
FROM students s
INNER JOIN journal USING (id_student)
INNER JOIN courses c USING (id_course)
INNER JOIN lectures l USING (id_course)) yulka
group by yulka.course;
	
10. Найдите все почты студентов для тех студентов, которые не зарегистрировались на самую непопулярную лекцию




  CREATE VIEW student_courses AS
  SELECT su.id_student AS id,
    su.name_of_student || ' ' || su.surname AS name,
    c.name_of_course,
    lectures.name_of_lecture,
	journal.id_student,
    lectures.id_course
   FROM students su
    INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures USING (id_course);
	
	
	  CREATE VIEW second_courses AS
  SELECT su.id_student AS id,
    su.name_of_student || ' ' || su.surname AS name,
	su.email,
	su.birthday,
    c.name_of_course,
    lectures.name_of_lecture,
	journal.id_student,
    lectures.id_course
   FROM students su
    INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures USING (id_course);
	
	select birthday from second_courses group by birthday;
	
	
	10. Найдите все почты студентов для тех студентов, которые не зарегистрировались на самую непопулярную лекцию

	
	select email from second_courses where name_of_lecture = new_name from (select l.name_of_lecture as new_name, count (*) as quantity 
FROM students s
INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures l USING (id_course)
	group by l.name_of_lecture ORDER BY quantity limit 1);
	

	
	1. Найти всех студентов, которые не зарегестрированы на эту лекцитю
	
	надо связать id студенда и id_lecture
	
	select id_student from students where id_lecture not in 
	(select l.id_lecture as number, count (*) as quantity from 
FROM students s
    INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures l USING (id_course)
	group by l.name_of_lecture ORDER BY quantity limit 1) test
		INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures l USING (id_course);
	
	INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures l USING (id_course);
	

select l.name_of_lecture as new_name, count (*) as quantity
FROM students s
INNER JOIN journal USING (id_student)
INNER JOIN courses c USING (id_course)
INNER JOIN lectures l USING (id_course)
group by l.name_of_lecture ORDER BY quantity limit 1;

select id_student from students where id_lecture not in 
	(select l.id_lecture as number, count (*) as quantity,  from 
FROM students s
    INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures l USING (id_course)
	group by l.name_of_lecture ORDER BY quantity limit 1) test
		INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures l USING (id_course);
	
	INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures l USING (id_course);
	
	надо связать id студенда и id_lecture

select l.name_of_lecture as new_name, count (*) as quantity
FROM students s
INNER JOIN journal USING (id_student)
INNER JOIN courses c USING (id_course)
INNER JOIN lectures l USING (id_course)
group by l.name_of_lecture ORDER BY quantity limit 1;

переделанный
select l.id_lecture as new_name, count (*) as quantity
FROM students s
INNER JOIN journal USING (id_student)
INNER JOIN courses c USING (id_course)
INNER JOIN lectures l USING (id_course)
group by l.id_lecture ORDER BY quantity limit 1;

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

select l.id_lecture as new_name
FROM students s
INNER JOIN journal USING (id_student)
INNER JOIN courses c USING (id_course)
INNER JOIN lectures l USING (id_course)
group by l.id_lecture ORDER BY count (*) limit 1;

		
	
	
	