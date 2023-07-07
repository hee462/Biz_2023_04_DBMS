-- 여기는 root 화면
-- 유저 삭제
drop user 'todo'@localhost;
drop user 'todo'@'192.168.4.%';
drop user 'todo'@'%';
-- 사용자생성
drop user todo@localhost;

create user todo@localhost identified by '88888888';
-- 권한부여
grant all privileges on todoDB.* to todo@localhost;
-- 권한적용
flush privileges;

-- MYSQL 의 SCHEME 생성
create database scoreDB;
grant all privileges on todoDB.* to todo@localhost;
flush privileges;