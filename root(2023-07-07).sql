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

drop table tbl_bbs;

create database bbsDB;

use bbsDB;

create table tbl_bbs(

	b_seq		bigint		PRIMARY KEY	auto_increment,
	b_pseq		bigint,			
	b_date		varchar(10),			
	b_time		varchar(10)	,		
	b_username	varchar(125),			
	b_nickname	varchar(125),			
	b_subject	varchar(125),			
	b_content	text,			
	b_count		int,			
	b_update	datetime			
	
);
desc tbl_bbs;
select* from tbl_bbs;


select b_username ,b_nickname
from tbl_bbs
group by b_username,b_nickname;

create table tbl_user(
username varchar(125) primary key,
nickname varchar(125) not null,
tel varchar(20)
);

-- tbl_bbs로 부터 user 정보 정규하로 분해하기
insert into tbl_user(username ,nickname)
values('hee462@hee462.com' ,'내멋으로');

desc tbl_user;