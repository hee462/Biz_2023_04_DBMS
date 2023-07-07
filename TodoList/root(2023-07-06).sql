--  여기는 root 화면

/*
MYSQL 프로젝트 시작
1. database 생성
2. 사용자 생성(DB 서버가 Application 서버와 같은 동일한 운영체제에 
있을 때는 사용자 등록이 선택사항이다)
root 사용자가 등록되어 있는데
root 사용자는 기본적으로 localhost에서만 접근이 된다

만약 네트워크를 통해서 DB서버에 접근하거나 특별히 보완이 요구되는 경우가 아니면
root 사용자를 일반 DB 사용자로 사용하는 경우가 많습니다.
*/

create database todoDB;
use todoDB;
show databases;

-- 사용자 등록
-- 사용자 등록을 할때 접근할수 잇는 범위를 설정해야 한다
-- 로컬에서만 접근할수 있는 todo생성
create user 'todo'@'localhost' identified BY'12341234';

-- 로컬 네트워크(192.168.*.*)형식으로 되어있는것
-- 현재 system 의 mysql에 접속할수 있는 사용자의 생성
create user 'todo'@'192.168.4.%' identified by '88888888';
-- 모든곳에서 사용할수 있는 사용자 생성
-- 보안상 가장 위험한 사용자 생성

/***********************무결성 파괴*************************/
-- 만약 이 사용자가 자신의 id와 비번을 소홀히 하여
-- 누군가에게 노출된다면 이 id와 비번을 통하여 DB에 접근하고
-- DBMS 데이터를 모두 파괴할수 있다
create user 'todo'@'*' identified by '88888888';

-- 현재 등록된 사용자는 MYSQL server에 접속할수 있도록
-- 권한을 가지고 있지만 그 외의 나머지 역할은 수행할수 없다
-- DB생성, table 생성 등을 수행하려면
-- 권한을 부여해야한다
-- grant DBA to user;

-- all privileges :DBA권한
-- *.*: 모든 database에 대하여 모든 역할 수행
grant all privileges on *.* to'todo'@'localhost';
-- 네트워크를 통하여 접근한 todo 사용자에게
-- todoDB에 대하여 모든 권한을 부여하기
grant all privileges on tododb.* to'todo'@'192.168.4.%';
-- todoDB Database의 tbl_todolist table 만 접근하는 권한 부여
grant all privileges on tododb.todolist to'todo'@'192.168.4.%';
-- CRUD 권한 나누어서 줄수도 있음
grant create,drop, select,insert,update,delete 
on tododb.* to'todo'@'192.168.4.%';

