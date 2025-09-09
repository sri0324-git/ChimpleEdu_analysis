create database chimple;
use chimple;

create table students (
student_id varchar(50) primary key,
school_id varchar(50) ,PRIMARYstudents
grade int,
gender char(1),
enrollment_date date
);
create table schools (
school_id varchar(50) primary key,
district varchar(100),
state varchar(100),
program_type varchar(100)
);
create table sessions (
event_id varchar(50) primary key,
    student_id varchar(50),
    lesson_id varchar(50),
    start_time datetime,
    end_time datetime ,
    device_id varchar(50),
    app_version varchar(20)
);
create table assignments (
assignment_id varchar(50) primary key,
teacher_id varchar(50),
student_id varchar(50),
lesson_id varchar(50),
assigned_date date,
completed_date date
);

show variables like 'secure_file_priv';
-- loaded data from table data import wizard
select * from students;
select count(*) from students;

select * from assignments;
select count(*) from assignments;

select * from schools;
select count(*) from schools;

describe sessions;
TRUNCATE TABLE sessions;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sessions_cleaned.csv'
INTO TABLE sessions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(event_id, student_id, lesson_id, start_time, end_time, device_id, app_version, invalid_flag);

select * from sessions;
select count(*) from sessions;

-- to build a fact table
create table fact_table (
student_id int not null,
session_date date not null,
active_flag tinyint not null,
lesson_completed int not null,
min_spent int not null,
primary key (student_id, session_date)
);

select * from fact_table;
describe fact_table;
alter table fact_table modify column student_id varchar(50);

insert into fact_table (student_id,session_date,active_flag,lesson_completed,min_spent)
select 
student_id, date(start_time) as session_date,
1 as active_flag,
count(*) as lesson_completed,
sum(timestampdiff (minute, start_time, end_time)) as min_spent
from sessions 
where invalid_flag = 0
group by student_id,date(start_time);

select * from fact_table ;
select count(*) from fact_table;


