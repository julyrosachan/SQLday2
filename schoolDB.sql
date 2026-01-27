create database AnotherSchoolDB;

use AnotherSchoolDB;

create table students(
    ID INT primary key identity (1,10),
    FullName NVARCHAR(67) not null,
    age smallint check (age > 9 and  age < 17),
    email VARCHAR(33) unique,
    score int default 0 check( score > 0 and score < 100)
)

insert into students(FullName, age, email, score) values
(N'fidan əhmədova',12,'fifi@gmail.com',75),
('leyla vahabova',15,'leyla_v@gmail.com', 95),
(N'yasəmən əliyeva',13,'kaori67@gmail.com',65),
(N'banu cəlalova',16,'banuj@gmail.com',100),
(N'turgut rzayev',14,'turgut@gmail.com',85);

alter table Students
add CreatedDate datetime default GETDATE();

update students
set email = CONCAT('top_', Email)
where score > 90;

delete from students
where age < 10;


alter table Students
add CONSTRAINT CK_Students_Score_Mod5
check (Score % 5 = 0);

create table TopStudents (
    Id INT,
    FullName NVARCHAR(100),
    Score INT
);

insert into TopStudents (Id, FullName, Score)
select Id, FullName, Score
from students
where score > 90;

