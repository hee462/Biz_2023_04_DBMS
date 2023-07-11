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
values('callor@callor.com' ,'내멋으로');

desc tbl_user;

insert into tbl_user(username,nickname,tel)
values('hong','홍길동','090-1111-1111');

insert into tbl_user(username,nickname,tel)
values('lee','이몽룡','090-2222-2222');

insert into tbl_user(username,nickname,tel)
values('seoung','성춘향','090-3333-3333');

select * from tbl_bbs;

alter table tbl_bbs
add constraint F_user
foreign key(b_username) references tbl_user(username);
-- 이 아이디가 있어야만 연결됨
select b_username
from tbl_bbs
group by b_username;
-- FK 설정이 되면
-- 두 table 간에 Insert, update ,delete 에서 이상현상을  방지하여 참조무결성 관계를 유지한다
insert into tbl_bbs(b_username, b_nickname)
values( 'aaa' ,'임꺽정');

desc tbl_bbs;
select 
	B.b_seq,
	B.b_pseq,
	B.b_date,
	B.b_time,
	B.b_username,
    U.nickname,
	B.b_subject,
	B.b_content,
	B.b_count,
	B.b_update
from tbl_bbs B,tbl_user U 
where B.b_username = U.username









