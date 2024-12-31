drop database if exists bank;

create database if not exists bank;

use bank

    create table account (
        account_id integer not null auto_increment,
        avail_balance float,
        close_date date,
        last_activity_date date,
        open_date date not null,
        pending_balance float,
        status varchar(10),
        cust_id integer,
        open_branch_id integer not null,
        open_emp_id integer not null,
        product_cd varchar(10) not null,
        primary key (account_id)
    );

    create table acc_transaction (
        txn_id bigint not null auto_increment,
        amount float not null,
        funds_avail_date datetime not null,
        txn_date datetime not null,
        txn_type_cd varchar(10),
        account_id integer,
        execution_branch_id integer,
        teller_emp_id integer,
        primary key (txn_id)
    );

    create table branch (
        branch_id integer not null auto_increment,
        address varchar(30),
        city varchar(20),
        name varchar(20) not null,
        state varchar(10),
        zip_code varchar(12),
        primary key (branch_id)
    );

    create table business (
        incorp_date date,
        name varchar(255) not null,
        state_id varchar(10) not null,
        cust_id integer not null,
        primary key (cust_id)
    );

    create table customer (
        cust_id integer not null auto_increment,
        address varchar(30),
        city varchar(20),
        cust_type_cd varchar(1) not null,
        fed_id varchar(12) not null,
        postal_code varchar(10),
        state varchar(20),
        primary key (cust_id)
    );

    create table department (
        dept_id integer not null auto_increment,
        name varchar(20) not null,
        primary key (dept_id)
    );

    create table employee (
        emp_id integer not null auto_increment,
        end_date date,
        first_name varchar(20) not null,
        last_name varchar(20) not null,
        start_date date not null,
        title varchar(20),
        assigned_branch_id integer,
        dept_id integer,
        superior_emp_id integer,
        primary key (emp_id)
    );

    create table individual (
        birth_date date,
        first_name varchar(30) not null,
        last_name varchar(30) not null,
        cust_id integer not null,
        primary key (cust_id)
    );

    create table officer (
        officer_id integer not null auto_increment,
        end_date date,
        first_name varchar(30) not null,
        last_name varchar(30) not null,
        start_date date not null,
        title varchar(20),
        cust_id integer,
        primary key (officer_id)
    );

    create table product (
        product_cd varchar(10) not null,
        date_offered date,
        date_retired date,
        name varchar(50) not null,
        product_type_cd varchar(255),
        primary key (product_cd)
    );

    create table product_type (
        product_type_cd varchar(255) not null,
        name varchar(50),
        primary key (product_type_cd)
    );

    alter table account 
        add constraint account_customer_fk 
        foreign key (cust_id) 
        references customer (cust_id);

    alter table account 
        add constraint account_branch_fk 
        foreign key (open_branch_id) 
        references branch (branch_id);

    alter table account 
        add constraint account_employee_fk 
        foreign key (open_emp_id) 
        references employee (emp_id);

    alter table account 
        add constraint account_product_fk 
        foreign key (product_cd) 
        references product (product_cd);

    alter table acc_transaction 
        add constraint acc_transaction_account_fk 
        foreign key (account_id) 
        references account (account_id);

    alter table acc_transaction 
        add constraint acc_transaction_branch_fk 
        foreign key (execution_branch_id) 
        references branch (branch_id);

    alter table acc_transaction 
        add constraint acc_transaction_employee_fk 
        foreign key (teller_emp_id) 
        references employee (emp_id);

    alter table business 
        add constraint business_employee_fk 
        foreign key (cust_id) 
        references customer (cust_id);

    alter table employee 
        add constraint employee_branch_fk 
        foreign key (assigned_branch_id) 
        references branch (branch_id);

    alter table employee 
        add constraint employee_department_fk 
        foreign key (dept_id) 
        references department (dept_id);

    alter table employee 
        add constraint employee_employee_fk 
        foreign key (superior_emp_id) 
        references employee (emp_id);

    alter table individual 
        add constraint individual_customer_fk 
        foreign key (cust_id) 
        references customer (cust_id);

    alter table officer 
        add constraint officer_customer_fk 
        foreign key (cust_id) 
        references customer (cust_id);

    alter table product 
        add constraint product_product_type_fk 
        foreign key (product_type_cd) 
        references product_type (product_type_cd);


 

-- begin data population


-- SET MODE -- 
-- http://stackoverflow.com/questions/11448068/mysql-error-code-1175-during-update-in-mysql-workbench
SET SQL_SAFE_UPDATES = 0;


-- department data  
insert into department (dept_id, name)
values (null, 'Operations');
insert into department (dept_id, name)
values (null, 'Loans');
insert into department (dept_id, name)
values (null, 'Administration');

insert into department (dept_id, name)
values (null, 'IT');

/* branch data */
insert into branch (branch_id, name, address, city, state, Zip_Code)
values (null, 'Headquarters', '3882 Main St.', 'Waltham', 'MA', '02451');
insert into branch (branch_id, name, address, city, state, Zip_Code)
values (null, 'Woburn Branch', '422 Maple St.', 'Woburn', 'MA', '01801');
insert into branch (branch_id, name, address, city, state, Zip_Code)
values (null, 'Quincy Branch', '125 Presidential Way', 'Quincy', 'MA', '02169');
insert into branch (branch_id, name, address, city, state, Zip_Code)
values (null, 'So. NH Branch', '378 Maynard Ln.', 'Salem', 'NH', '03079');

/* employee data */
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Michael', 'Smith', '2001-06-22', 
  (select dept_id from department where name = 'Administration'), 
  'President', 
  (select branch_id from branch where name = 'Headquarters'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Susan', 'Barker', '2002-09-12', 
  (select dept_id from department where name = 'Administration'), 
  'Vice President', 
  (select branch_id from branch where name = 'Headquarters'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Robert', 'Tyler', '2000-02-09',
  (select dept_id from department where name = 'Administration'), 
  'Treasurer', 
  (select branch_id from branch where name = 'Headquarters'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Susan', 'Hawthorne', '2002-04-24', 
  (select dept_id from department where name = 'Operations'), 
  'Operations Manager', 
  (select branch_id from branch where name = 'Headquarters'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'John', 'Gooding', '2003-11-14', 
  (select dept_id from department where name = 'Loans'), 
  'Loan Manager', 
  (select branch_id from branch where name = 'Headquarters'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Helen', 'Fleming', '2004-03-17', 
  (select dept_id from department where name = 'Operations'), 
  'Head Teller', 
  (select branch_id from branch where name = 'Headquarters'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Chris', 'Tucker', '2004-09-15', 
  (select dept_id from department where name = 'Operations'), 
  'Teller', 
  (select branch_id from branch where name = 'Headquarters'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Sarah', 'Parker', '2002-12-02', 
  (select dept_id from department where name = 'Operations'), 
  'Teller', 
  (select branch_id from branch where name = 'Headquarters'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Jane', 'Grossman', '2002-05-03', 
  (select dept_id from department where name = 'Operations'), 
  'Teller', 
  (select branch_id from branch where name = 'Headquarters'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Paula', 'Roberts', '2002-07-27', 
  (select dept_id from department where name = 'Operations'), 
  'Head Teller', 
  (select branch_id from branch where name = 'Woburn Branch'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Thomas', 'Ziegler', '2000-10-23', 
  (select dept_id from department where name = 'Operations'), 
  'Teller', 
  (select branch_id from branch where name = 'Woburn Branch'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Samantha', 'Jameson', '2003-01-08', 
  (select dept_id from department where name = 'Operations'), 
  'Teller', 
  (select branch_id from branch where name = 'Woburn Branch'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'John', 'Blake', '2000-05-11', 
  (select dept_id from department where name = 'Operations'), 
  'Head Teller', 
  (select branch_id from branch where name = 'Quincy Branch'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Cindy', 'Mason', '2002-08-09', 
  (select dept_id from department where name = 'Operations'), 
  'Teller', 
  (select branch_id from branch where name = 'Quincy Branch'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Frank', 'Portman', '2003-04-01', 
  (select dept_id from department where name = 'Operations'), 
  'Teller', 
  (select branch_id from branch where name = 'Quincy Branch'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Theresa', 'Markham', '2001-03-15', 
  (select dept_id from department where name = 'Operations'), 
  'Head Teller', 
  (select branch_id from branch where name = 'So. NH Branch'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Beth', 'Fowler', '2002-06-29', 
  (select dept_id from department where name = 'Operations'), 
  'Teller', 
  (select branch_id from branch where name = 'So. NH Branch'));
insert into employee (emp_id, First_Name, Last_Name, start_date, 
  dept_id, title, assigned_branch_id)
values (null, 'Rick', 'Tulman', '2002-12-12', 
  (select dept_id from department where name = 'Operations'), 
  'Teller', 
  (select branch_id from branch where name = 'So. NH Branch'));

/* create data for self-referencing foreign key 'superior_emp_id' */
create temporary table emp_tmp as
select emp_id, First_Name, Last_Name from employee;



update employee set superior_emp_id =
 (select emp_id from emp_tmp where Last_Name = 'Smith' and First_Name = 'Michael')
where ((Last_Name = 'Barker' and First_Name = 'Susan')
  or (Last_Name = 'Tyler' and First_Name = 'Robert'));
update employee set superior_emp_id =
 (select emp_id from emp_tmp where Last_Name = 'Tyler' and First_Name = 'Robert')
where Last_Name = 'Hawthorne' and First_Name = 'Susan';
update employee set superior_emp_id =
 (select emp_id from emp_tmp where Last_Name = 'Hawthorne' and First_Name = 'Susan')
where ((Last_Name = 'Gooding' and First_Name = 'John')
  or (Last_Name = 'Fleming' and First_Name = 'Helen')
  or (Last_Name = 'Roberts' and First_Name = 'Paula') 
  or (Last_Name = 'Blake' and First_Name = 'John') 
  or (Last_Name = 'Markham' and First_Name = 'Theresa')); 
update employee set superior_emp_id =
 (select emp_id from emp_tmp where Last_Name = 'Fleming' and First_Name = 'Helen')
where ((Last_Name = 'Tucker' and First_Name = 'Chris') 
  or (Last_Name = 'Parker' and First_Name = 'Sarah') 
  or (Last_Name = 'Grossman' and First_Name = 'Jane'));  
update employee set superior_emp_id =
 (select emp_id from emp_tmp where Last_Name = 'Roberts' and First_Name = 'Paula')
where ((Last_Name = 'Ziegler' and First_Name = 'Thomas')  
  or (Last_Name = 'Jameson' and First_Name = 'Samantha'));   
update employee set superior_emp_id =
 (select emp_id from emp_tmp where Last_Name = 'Blake' and First_Name = 'John')
where ((Last_Name = 'Mason' and First_Name = 'Cindy')   
  or (Last_Name = 'Portman' and First_Name = 'Frank'));    
update employee set superior_emp_id =
 (select emp_id from emp_tmp where Last_Name = 'Markham' and First_Name = 'Theresa')
where ((Last_Name = 'Fowler' and First_Name = 'Beth')   
  or (Last_Name = 'Tulman' and First_Name = 'Rick'));    

drop table emp_tmp;

/* product type data */
insert into product_type (product_type_cd, name)
values ('ACCOUNT','Customer Accounts');
insert into product_type (product_type_cd, name)
values ('LOAN','Individual and Business Loans');
insert into product_type (product_type_cd, name)
values ('INSURANCE','Insurance Offerings');

/* product data */
insert into product (product_cd, name, product_type_cd, date_offered)
values ('CHK','checking account','ACCOUNT','2000-01-01');
insert into product (product_cd, name, product_type_cd, date_offered)
values ('SAV','savings account','ACCOUNT','2000-01-01');
insert into product (product_cd, name, product_type_cd, date_offered)
values ('MM','money market account','ACCOUNT','2000-01-01');
insert into product (product_cd, name, product_type_cd, date_offered)
values ('CD','certificate of deposit','ACCOUNT','2000-01-01');
insert into product (product_cd, name, product_type_cd, date_offered)
values ('MRT','home mortgage','LOAN','2000-01-01');
insert into product (product_cd, name, product_type_cd, date_offered)
values ('AUT','auto loan','LOAN','2000-01-01');
insert into product (product_cd, name, product_type_cd, date_offered)
values ('BUS','business line of credit','LOAN','2000-01-01');
insert into product (product_cd, name, product_type_cd, date_offered)
values ('SBL','small business loan','LOAN','2000-01-01');

/* residential customer data */
insert into customer (cust_id, fed_id, cust_type_cd,
  address, city, state, postal_code)
values (null, '111-11-1111', 'I', '47 Mockingbird Ln', 'Lynnfield', 'MA', '01940');
insert into individual (cust_id, First_Name, Last_Name, birth_date)
select cust_id, 'James', 'Hadley', '1972-04-22' from customer
where fed_id = '111-11-1111';
insert into customer (cust_id, fed_id, cust_type_cd,
  address, city, state, postal_code)
values (null, '222-22-2222', 'I', '372 Clearwater Blvd', 'Woburn', 'MA', '01801');
insert into individual (cust_id, First_Name, Last_Name, birth_date)
select cust_id, 'Susan', 'Tingley', '1968-08-15' from customer
where fed_id = '222-22-2222';
insert into customer (cust_id, fed_id, cust_type_cd,
  address, city, state, postal_code)
values (null, '333-33-3333', 'I', '18 Jessup Rd', 'Quincy', 'MA', '02169');
insert into individual (cust_id, First_Name, Last_Name, birth_date)
select cust_id, 'Frank', 'Tucker', '1958-02-06' from customer
where fed_id = '333-33-3333';
insert into customer (cust_id, fed_id, cust_type_cd,
  address, city, state, postal_code)
values (null, '444-44-4444', 'I', '12 Buchanan Ln', 'Waltham', 'MA', '02451');
insert into individual (cust_id, First_Name, Last_Name, birth_date)
select cust_id, 'John', 'Hayward', '1966-12-22' from customer
where fed_id = '444-44-4444';
insert into customer (cust_id, fed_id, cust_type_cd,
  address, city, state, postal_code)
values (null, '555-55-5555', 'I', '2341 Main St', 'Salem', 'NH', '03079');
insert into individual (cust_id, First_Name, Last_Name, birth_date)
select cust_id, 'Charles', 'Frasier', '1971-08-25' from customer
where fed_id = '555-55-5555';
insert into customer (cust_id, fed_id, cust_type_cd,
  address, city, state, postal_code)
values (null, '666-66-6666', 'I', '12 Blaylock Ln', 'Waltham', 'MA', '02451');
insert into individual (cust_id, First_Name, Last_Name, birth_date)
select cust_id, 'John', 'Spencer', '1962-09-14' from customer
where fed_id = '666-66-6666';
insert into customer (cust_id, fed_id, cust_type_cd,
  address, city, state, postal_code)
values (null, '777-77-7777', 'I', '29 Admiral Ln', 'Wilmington', 'MA', '01887');
insert into individual (cust_id, First_Name, Last_Name, birth_date)
select cust_id, 'Margaret', 'Young', '1947-03-19' from customer
where fed_id = '777-77-7777';
insert into customer (cust_id, fed_id, cust_type_cd,
  address, city, state, postal_code)
values (null, '888-88-8888', 'I', '472 Freedom Rd', 'Salem', 'NH', '03079');
insert into individual (cust_id, First_Name, Last_Name, birth_date)
select cust_id, 'Louis', 'Blake', '1977-07-01' from customer
where fed_id = '888-88-8888';
insert into customer (cust_id, fed_id, cust_type_cd,
  address, city, state, postal_code)
values (null, '999-99-9999', 'I', '29 Maple St', 'Newton', 'MA', '02458');
insert into individual (cust_id, First_Name, Last_Name, birth_date)
select cust_id, 'Richard', 'Farley', '1968-06-16' from customer
where fed_id = '999-99-9999';

/* corporate customer data */
insert into customer (cust_id, fed_id, cust_type_cd,
  address, city, state, postal_code)
values (null, '04-1111111', 'B', '7 Industrial Way', 'Salem', 'NH', '03079');
insert into business (cust_id, name, state_id, incorp_date)
select cust_id, 'Chilton Engineering', '12-345-678', '1995-05-01' from customer
where fed_id = '04-1111111';
insert into officer (officer_id, cust_id, First_Name, Last_Name,
  title, start_date)
select null, cust_id, 'John', 'Chilton', 'President', '1995-05-01'
from customer
where fed_id = '04-1111111';
insert into customer (cust_id, fed_id, cust_type_cd,
  address, city, state, postal_code)
values (null, '04-2222222', 'B', '287A Corporate Ave', 'Wilmington', 'MA', '01887');
insert into business (cust_id, name, state_id, incorp_date)
select cust_id, 'Northeast Cooling Inc.', '23-456-789', '2001-01-01' from customer
where fed_id = '04-2222222';
insert into officer (officer_id, cust_id, First_Name, Last_Name,
  title, start_date)
select null, cust_id, 'Paul', 'Hardy', 'President', '2001-01-01'
from customer
where fed_id = '04-2222222';
insert into customer (cust_id, fed_id, cust_type_cd,
  address, city, state, postal_code)
values (null, '04-3333333', 'B', '789 Main St', 'Salem', 'NH', '03079');
insert into business (cust_id, name, state_id, incorp_date)
select cust_id, 'Superior Auto Body', '34-567-890', '2002-06-30' from customer
where fed_id = '04-3333333';
insert into officer (officer_id, cust_id, First_Name, Last_Name,
  title, start_date)
select null, cust_id, 'Carl', 'Lutz', 'President', '2002-06-30'
from customer
where fed_id = '04-3333333';
insert into customer (cust_id, fed_id, cust_type_cd,
  address, city, state, postal_code)
values (null, '04-4444444', 'B', '4772 Presidential Way', 'Quincy', 'MA', '02169');
insert into business (cust_id, name, state_id, incorp_date)
select cust_id, 'AAA Insurance Inc.', '45-678-901', '1999-05-01' from customer
where fed_id = '04-4444444';
insert into officer (officer_id, cust_id, First_Name, Last_Name,
  title, start_date)
select null, cust_id, 'Stanley', 'Cheswick', 'President', '1999-05-01'
from customer
where fed_id = '04-4444444';

/* residential account data */
insert into account (account_id, product_cd, cust_id, open_date,
  last_activity_date, status, open_branch_id,
  open_emp_id, avail_balance, pending_balance)
select null, a.prod_cd, c.cust_id, a.open_date, a.last_date, 'ACTIVE',
  e.branch_id, e.emp_id, a.avail, a.pend
from customer c cross join 
 (select b.branch_id, e.emp_id 
  from branch b inner join employee e on e.assigned_branch_id = b.branch_id
  where b.city = 'Woburn' limit 1) e
  cross join
 (select 'CHK' prod_cd, '2000-01-15' open_date, '2005-01-04' last_date,
    1057.75 avail, 1057.75 pend union all
  select 'SAV' prod_cd, '2000-01-15' open_date, '2004-12-19' last_date,
    500.00 avail, 500.00 pend union all
  select 'CD' prod_cd, '2004-06-30' open_date, '2004-06-30' last_date,
    3000.00 avail, 3000.00 pend) a
where c.fed_id = '111-11-1111';
insert into account (account_id, product_cd, cust_id, open_date,
  last_activity_date, status, open_branch_id,
  open_emp_id, avail_balance, pending_balance)
select null, a.prod_cd, c.cust_id, a.open_date, a.last_date, 'ACTIVE',
  e.branch_id, e.emp_id, a.avail, a.pend
from customer c cross join 
 (select b.branch_id, e.emp_id 
  from branch b inner join employee e on e.assigned_branch_id = b.branch_id
  where b.city = 'Woburn' limit 1) e
  cross join
 (select 'CHK' prod_cd, '2001-03-12' open_date, '2004-12-27' last_date,
    2258.02 avail, 2258.02 pend union all
  select 'SAV' prod_cd, '2001-03-12' open_date, '2004-12-11' last_date,
    200.00 avail, 200.00 pend) a
where c.fed_id = '222-22-2222';
insert into account (account_id, product_cd, cust_id, open_date,
  last_activity_date, status, open_branch_id,
  open_emp_id, avail_balance, pending_balance)
select null, a.prod_cd, c.cust_id, a.open_date, a.last_date, 'ACTIVE',
  e.branch_id, e.emp_id, a.avail, a.pend
from customer c cross join 
 (select b.branch_id, e.emp_id 
  from branch b inner join employee e on e.assigned_branch_id = b.branch_id
  where b.city = 'Quincy' limit 1) e
  cross join
 (select 'CHK' prod_cd, '2002-11-23' open_date, '2004-11-30' last_date,
    1057.75 avail, 1057.75 pend union all
  select 'MM' prod_cd, '2002-12-15' open_date, '2004-12-05' last_date,
    2212.50 avail, 2212.50 pend) a
where c.fed_id = '333-33-3333';
insert into account (account_id, product_cd, cust_id, open_date,
  last_activity_date, status, open_branch_id,
  open_emp_id, avail_balance, pending_balance)
select null, a.prod_cd, c.cust_id, a.open_date, a.last_date, 'ACTIVE',
  e.branch_id, e.emp_id, a.avail, a.pend
from customer c cross join 
 (select b.branch_id, e.emp_id 
  from branch b inner join employee e on e.assigned_branch_id = b.branch_id
  where b.city = 'Waltham' limit 1) e
  cross join
 (select 'CHK' prod_cd, '2003-09-12' open_date, '2005-01-03' last_date,
    534.12 avail, 534.12 pend union all
  select 'SAV' prod_cd, '2000-01-15' open_date, '2004-10-24' last_date,
    767.77 avail, 767.77 pend union all
  select 'MM' prod_cd, '2004-09-30' open_date, '2004-11-11' last_date,
    5487.09 avail, 5487.09 pend) a
where c.fed_id = '444-44-4444';
insert into account (account_id, product_cd, cust_id, open_date,
  last_activity_date, status, open_branch_id,
  open_emp_id, avail_balance, pending_balance)
select null, a.prod_cd, c.cust_id, a.open_date, a.last_date, 'ACTIVE',
  e.branch_id, e.emp_id, a.avail, a.pend
from customer c cross join 
 (select b.branch_id, e.emp_id 
  from branch b inner join employee e on e.assigned_branch_id = b.branch_id
  where b.city = 'Salem' limit 1) e
  cross join
 (select 'CHK' prod_cd, '2004-01-27' open_date, '2005-01-05' last_date,
    2237.97 avail, 2897.97 pend) a
where c.fed_id = '555-55-5555';
insert into account (account_id, product_cd, cust_id, open_date,
  last_activity_date, status, open_branch_id,
  open_emp_id, avail_balance, pending_balance)
select null, a.prod_cd, c.cust_id, a.open_date, a.last_date, 'ACTIVE',
  e.branch_id, e.emp_id, a.avail, a.pend
from customer c cross join 
 (select b.branch_id, e.emp_id 
  from branch b inner join employee e on e.assigned_branch_id = b.branch_id
  where b.city = 'Waltham' limit 1) e
  cross join
 (select 'CHK' prod_cd, '2002-08-24' open_date, '2004-11-29' last_date,
    122.37 avail, 122.37 pend union all
  select 'CD' prod_cd, '2004-12-28' open_date, '2004-12-28' last_date,
    10000.00 avail, 10000.00 pend) a
where c.fed_id = '666-66-6666';
insert into account (account_id, product_cd, cust_id, open_date,
  last_activity_date, status, open_branch_id,
  open_emp_id, avail_balance, pending_balance)
select null, a.prod_cd, c.cust_id, a.open_date, a.last_date, 'ACTIVE',
  e.branch_id, e.emp_id, a.avail, a.pend
from customer c cross join 
 (select b.branch_id, e.emp_id 
  from branch b inner join employee e on e.assigned_branch_id = b.branch_id
  where b.city = 'Woburn' limit 1) e
  cross join
 (select 'CD' prod_cd, '2004-01-12' open_date, '2004-01-12' last_date,
    5000.00 avail, 5000.00 pend) a
where c.fed_id = '777-77-7777';
insert into account (account_id, product_cd, cust_id, open_date,
  last_activity_date, status, open_branch_id,
  open_emp_id, avail_balance, pending_balance)
select null, a.prod_cd, c.cust_id, a.open_date, a.last_date, 'ACTIVE',
  e.branch_id, e.emp_id, a.avail, a.pend
from customer c cross join 
 (select b.branch_id, e.emp_id 
  from branch b inner join employee e on e.assigned_branch_id = b.branch_id
  where b.city = 'Salem' limit 1) e
  cross join
 (select 'CHK' prod_cd, '2001-05-23' open_date, '2005-01-03' last_date,
    3487.19 avail, 3487.19 pend union all
  select 'SAV' prod_cd, '2001-05-23' open_date, '2004-10-12' last_date,
    387.99 avail, 387.99 pend) a
where c.fed_id = '888-88-8888';
insert into account (account_id, product_cd, cust_id, open_date,
  last_activity_date, status, open_branch_id,
  open_emp_id, avail_balance, pending_balance)
select null, a.prod_cd, c.cust_id, a.open_date, a.last_date, 'ACTIVE',
  e.branch_id, e.emp_id, a.avail, a.pend
from customer c cross join 
 (select b.branch_id, e.emp_id 
  from branch b inner join employee e on e.assigned_branch_id = b.branch_id
  where b.city = 'Waltham' limit 1) e
  cross join
 (select 'CHK' prod_cd, '2003-07-30' open_date, '2004-12-15' last_date,
    125.67 avail, 125.67 pend union all
  select 'MM' prod_cd, '2004-10-28' open_date, '2004-10-28' last_date,
    9345.55 avail, 9845.55 pend union all
  select 'CD' prod_cd, '2004-06-30' open_date, '2004-06-30' last_date,
    1500.00 avail, 1500.00 pend) a
where c.fed_id = '999-99-9999';

-- corporate account data  
insert into account (account_id, product_cd, cust_id, open_date,
  last_activity_date, status, open_branch_id,
  open_emp_id, avail_balance, pending_balance)
select null, a.prod_cd, c.cust_id, a.open_date, a.last_date, 'ACTIVE',
  e.branch_id, e.emp_id, a.avail, a.pend
from customer c cross join 
 (select b.branch_id, e.emp_id 
  from branch b inner join employee e on e.assigned_branch_id = b.branch_id
  where b.city = 'Salem' limit 1) e
  cross join
 (select 'CHK' prod_cd, '2002-09-30' open_date, '2004-12-15' last_date,
    23575.12 avail, 23575.12 pend union all
  select 'BUS' prod_cd, '2002-10-01' open_date, '2004-08-28' last_date,
    0 avail, 0 pend) a
where c.fed_id = '04-1111111';
insert into account (account_id, product_cd, cust_id, open_date,
  last_activity_date, status, open_branch_id,
  open_emp_id, avail_balance, pending_balance)
select null, a.prod_cd, c.cust_id, a.open_date, a.last_date, 'ACTIVE',
  e.branch_id, e.emp_id, a.avail, a.pend
from customer c cross join 
 (select b.branch_id, e.emp_id 
  from branch b inner join employee e on e.assigned_branch_id = b.branch_id
  where b.city = 'Woburn' limit 1) e
  cross join
 (select 'BUS' prod_cd, '2004-03-22' open_date, '2004-11-14' last_date,
    9345.55 avail, 9345.55 pend) a
where c.fed_id = '04-2222222';
insert into account (account_id, product_cd, cust_id, open_date,
  last_activity_date, status, open_branch_id,
  open_emp_id, avail_balance, pending_balance)
select null, a.prod_cd, c.cust_id, a.open_date, a.last_date, 'ACTIVE',
  e.branch_id, e.emp_id, a.avail, a.pend
from customer c cross join 
 (select b.branch_id, e.emp_id 
  from branch b inner join employee e on e.assigned_branch_id = b.branch_id
  where b.city = 'Salem' limit 1) e
  cross join
 (select 'CHK' prod_cd, '2003-07-30' open_date, '2004-12-15' last_date,
    38552.05 avail, 38552.05 pend) a
where c.fed_id = '04-3333333';
insert into account (account_id, product_cd, cust_id, open_date,
  last_activity_date, status, open_branch_id,
  open_emp_id, avail_balance, pending_balance)
select null, a.prod_cd, c.cust_id, a.open_date, a.last_date, 'ACTIVE',
  e.branch_id, e.emp_id, a.avail, a.pend
from customer c cross join 
 (select b.branch_id, e.emp_id 
  from branch b inner join employee e on e.assigned_branch_id = b.branch_id
  where b.city = 'Quincy' limit 1) e
  cross join
 (select 'SBL' prod_cd, '2004-02-22' open_date, '2004-12-17' last_date,
    50000.00 avail, 50000.00 pend) a
where c.fed_id = '04-4444444';

-- put $100 in all checking/savings accounts on date account opened  
insert into acc_transaction (txn_id, txn_date, account_id, txn_type_cd,
  amount, funds_avail_date)
select null, a.open_date, a.account_id, 'CDT', 100, a.open_date
from account a
where a.product_cd IN ('CHK','SAV','CD','MM');

select table_name as tabla, table_rows as num_registros
	from INFORMATION_SCHEMA.TABLES
	where TABLE_SCHEMA = 'bank';

/* Verificar que tengan 11 tablas y sus respectivos registros */   