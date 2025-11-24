-- Câu 1. Tạo CSDL và các bảng
create database ProjectManagement;
use ProjectManagement;

create table employees (
	employee_id varchar(10) primary key,
    full_name varchar(100) not null,
    hire_date date,
    salary decimal(10,2) default(5000),
    department enum('IT','KeToan','NhanSu')
);

create table project (
	project_id varchar(10) primary key,
    project_name varchar(100) not null,
    budget decimal(15,2)
);

create table assignment (
    employee_id varchar(10),
    foreign key (employee_id) references employees(employee_id),
    project_id varchar(10),
    foreign key (project_id) references project(project_id),
    WorkedHour int not null,
    primary key(employee_id,project_id)
);

-- Câu 2: Thêm dữ liệu
insert into employees 
values 
('NV01', 'Nguyen Tuan Anh', '2022-01-10', 1500.00, 'IT'),
('NV02', 'Tran Thi Mai', '2021-05-20', 1200.00, 'KeToan'),
('NV03', 'Le Van Hung', '2023-03-15', 1400.00, 'IT'),
('NV04', 'Pham Minh Tuan', '2020-11-02', 1600.00, 'NhanSu'),
('NV05', 'Hoang Thi Lan', '2022-08-01', 1300.00, 'IT');

insert into project 
values 
('DA01', 'Website Ban Hang', 50000.00),
('DA02', 'Phan Mem Noi Bo', 30000.00),
('DA03', 'Tuyen Dung Tai Nang', 10000.00);

insert into assignment 
values 
('NV01', 'DA01', 100),
('NV01', 'DA02', 50),
('NV02', 'DA02', 80),
('NV03', 'DA01', 120),
('NV03', 'DA03', 30),
('NV04', 'DA03', 60),
('NV05', 'DA01', 90);

-- Câu 3: Cập nhật dữ liệu
set sql_safe_updates=0;

-- 1.Tăng ngân sách (Budget) của dự án có mã 'DA01' thêm 5000.
update project
set budget=budget+5000
where project_id='DA01';

-- 2.Cập nhật số giờ làm (WorkedHours) của nhân viên 'NV01' tại dự án 'DA02' thành 60.
update assignment
set WorkedHour=60
where employee_id='NV01' and project_id='DA02';

-- 3.Xóa bản ghi phân công của nhân viên 'NV03' khỏi dự án 'DA03'.
delete from assignment 
where employee_id='NV01' and project_id='DA03';

-- Câu 4: Truy vấn cơ bản

-- 1.Lấy danh sách nhân viên gồm (EmployeeId, FullName, Salary) thuộc phòng ban 'IT'.
select Employee_Id, Full_Name, Salary
from employees 
where department like 'IT';

-- 2.Lấy danh sách các dự án gồm (ProjectId, ProjectName) có ngân sách lớn hơn hoặc bằng 40000.
select project_id,project_name
from project
where budget>=40000.00;

-- 3.Lấy danh sách phân công (EmployeeId, WorkedHours) của dự án có mã là 'DA01'.
select employee_id,WorkedHour 
from assignment
where project_id='DA01';

-- 4.Tìm kiếm các nhân viên có tên chứa chữ "Tuan".
select full_name from employees
where full_name like '%Tuan%';

-- 5.Lấy danh sách lương của nhân viên (EmployeeId, FullName, Department, Salary), sắp xếp theo thứ tự giảm dần.
select Employee_Id, Full_Name, Department, Salary
from employees 
order by salary desc;

-- 6.Lấy ra thông tin của 3 nhân viên đầu tiên trong bảng nhân viên có lương thấp nhất.
select * from employees
order by salary asc limit 3;

-- Câu 5: Truy vấn nâng cao

-- 1.Tính tổng số lương mà công ty phải trả cho mỗi phòng ban. Hiển thị: Department, TotalSalary.
select department,sum(salary) as TotalSalary
from employees
group by department;

-- 2.Tính số giờ làm trung bình của các nhân viên trong từng dự án. Hiển thị: ProjectId, AverageWorkedHours.
select project_id,avg(WorkedHour) as AverageWorkedHours
from assignment
group by project_id;

-- 3.Tìm những dự án (ProjectId,ProjectName) có ít nhất 2 nhân viên tham gia
select p.project_id,p.project_name
from project p
join employees e on e.employee_id=p.employee_id
having count(employee_id)>=2;
