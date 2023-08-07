drop database Collegeinfo;
create database Collegeinfo;
use Collegeinfo;

create table Students(
	student_id int,
    first_name varchar(50),
    last_name varchar(50),
    age int,
    department varchar(50),
    primary key(student_id)
);
create table Courses(
	course_id int,
    course_name varchar(50),
    credits int,
    primary key(course_id)
);
create table Enrollments(
	enrollment_id int,
    student_id int,
    course_id int,
    grade int
);
alter table Enrollments add foreign key (student_id) references Students(student_id);
alter table Enrollments add foreign key (course_id) references Courses(course_id);
alter table Enrollments add primary key (enrollment_id);

insert into Students values 
(1,'Amjad','Hussain',21,'MCA'),
(2,'Alan','Thomas',20,'ME'),
(3,'Nidal','Basheer',22,'EEE'),
(4,'Amal','Roshan',21,'CSE'),
(5,'Faiz','Arif',20,'CE'),
(6,'Shiva','Krishnan',20,'MCA'),
(7,'Aswin','R',21,'ME'),
(8,'Arjun','R',22,'EEE')
;

insert into Courses values 
(1,'IPR',10),
(2,'Artificial Intelligence',20),
(3,'Virtualization',30),
(4,'Statistics',40)
;

create table avggrade(
	sino int auto_increment primary key,
    course varchar(50),
    avg_grade int
);

insert into avggrade (sino,avg_grade) values 
(1,0),
(2,0),
(3,0),
(4,0)
;

-- DELIMITER $$
-- CREATE DEFINER = CURRENT_USER TRIGGER `collegeinfo`.`enrollments_AFTER_INSERT` AFTER INSERT ON `enrollments` FOR EACH ROW
-- BEGIN
-- 	update avggrade set avggrade.avg_grade = (avggrade.avg_grade + NEW.grade) where (NEW.course_id = avggrade.sino) ;
-- END $$
-- DELIMITER ;

-- Create a trigger that automatically updates the average grade of a course whenever a new grade is added to the Enrollments table 
DELIMITER $$
CREATE DEFINER = CURRENT_USER TRIGGER `collegeinfo`.`enrollments_AFTER_INSERT` AFTER INSERT ON `enrollments` FOR EACH ROW
BEGIN
	update avggrade set avg_grade = avg_grade + NEW.grade , course = (select course_name from Courses where Courses.course_id = NEW.course_id) where NEW.course_id = avggrade.sino;
END $$
DELIMITER ;
insert into Enrollments values (14,1,3,30);
select * from avggrade;


insert into Enrollments values 
(1,1,1,10),
(2,1,4,40),
(3,2,2,20),
(4,3,3,30),
(5,3,2,20),
(6,4,4,40),
(7,5,1,10),
(8,6,2,20),
(9,6,4,40),
(10,7,3,30),
(11,8,4,40),
(12,8,1,10),
(13,7,4,40)
;














-- Retrieve the names of all students who are enrolled in a specific course
-- select first_name, Courses.course_name as Course from Students inner join Enrollments on Students.student_id = Enrollments.student_id inner join Courses on Enrollments.course_id = Courses.course_id;
-- select first_name, Courses.course_name as Course from Students inner join Enrollments on Students.student_id = Enrollments.student_id inner join Courses on Enrollments.course_id = Courses.course_id where Courses.course_name = "Statistics";

-- Calculate the total number of credits taken by a particular student
-- select Students.first_name, sum(Courses.credits) as Total_Credits from Students inner join Enrollments on Students.student_id = Enrollments.student_id inner join Courses on Enrollments.course_id = Courses.course_id group by Enrollments.student_id;
-- select Students.first_name, sum(Courses.credits) as Total_Credits from Students inner join Enrollments on Students.student_id = Enrollments.student_id inner join Courses on Enrollments.course_id = Courses.course_id where Students.student_id = 3 group by Enrollments.student_id;

-- Find the average grade of a specific course
select Courses.course_name, sum(Enrollments.grade) as avg_grade from Courses inner join Enrollments on Enrollments.course_id = Courses.course_id group by Enrollments.course_id;
select Courses.course_name, sum(Enrollments.grade) as avg_grade from Courses inner join Enrollments on Enrollments.course_id = Courses.course_id where Courses.course_id = 3 group by Enrollments.course_id;

-- Delete all enrollments of a particular student from the Enrollments table
delete from Enrollments where student_id = 3;
select * from Enrollments;