## Практика

Нам необходимо смоделировать процесс обучения на наших курсах.

У нас есть несколько сущностей, которые нам нужно хранить для успешной организации и проведения курсов.

1. Список студентов. У каждого студента есть имя, фамилия, отчество, дата рождения, почта.
2. Список курсов. У каждого курса есть название, дата начала и дата окончания.
3. Список лекции. У каждой лекции есть название, дата проведения.

Логика:

1. Каждый студент может записаться на несколько курсов: Python, Java, Общий, DevOps, Testing
2. У каждого курса может быть много лекций.
3. Лекция проходит всегда в рамках одного курса. - constraint? получается что она должна быть unique Lectures

### Задания

1. Написать скрипт создания таблиц с правильными типами полей
2. Создать правильные связи между таблицами
3. Создать данные для вставки в таблицы. 10 студентов, 5 курсов, ~15 лекций (по одной / две / три на курс), запись как минимум на один курс для каждого студента. Максимум - можно записаться на все

### Запросы

4. Сделать выборку: сколько всего лекций послушает каждый студент

С использованием view:
select name,count(*) as quantity from student_courses group by name ORDER BY quantity desc;

Без использования view:
select s.surname, count (*) as lectures 
FROM students s
INNER JOIN journal USING (id_student)
    INNER JOIN courses c USING (id_course)
    INNER JOIN lectures USING (id_course)
	group by s.surname ORDER BY lectures desc;
	

5. Найти самые популярные лекции, которые увидит больше всего студентов

select *from student_courses;


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




### Форма сдачи

Вы должны сдать несколько SQL запросов вида:

```sql
-- Задача 1
CREATE ...

-- Задача 2
-- ...

-- ...
```


Загрузите решение в scm.x5.ru:

- В репозитории "postgresql" (созданном для выполнения ДЗ-1 по БД) создайте ветку "hw-3".

- В неё закомитьте файл hw3.sql с командами.

- Создайте Merge Request из ветки "hw-3" в ветку master. Укажите в "Labels" для Merge Request-а метку "DB-3".
    Указывать Assignee НЕ нужно.
    Сливать изменения или закрывать Merge Request НЕ нужно, оставьте Merge Request открытым.

