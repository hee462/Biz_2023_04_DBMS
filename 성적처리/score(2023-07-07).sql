 -- ScoreDB 화면
 
use scoreDB;
-- 일반(엑셀) 성적표를 저장하기 위한 table 생성
 create table tbl_scoreV1(
	sc_stnum	VARCHAR(5)		PRIMARY KEY,
	sc_kor		INT,		
	sc_eng		INT,		
	sc_math		INT,		
	sc_music	INT,		
	sc_art		INT,		
	sc_software	INT,		
	sc_database	INT		
 );
 
 show tables;
 desc tbl_scoreV1;
 
 select * from tbl_scoreV1;
 create view view_scoreV1 AS
 (
 select *,
 sc_kor 
 +sc_eng 
 +sc_math
 +sc_art
 +sc_music
 +sc_software
 +sc_database as 총점,
(sc_kor 
+sc_eng 
+sc_math
+sc_art
+sc_music
+sc_software
+sc_database)/7 as  평균
 from tbl_scoreV1
);
select * from view_scoreV1;

-- 국어성적이 50점 이상인 학생들 리스트
-- WHERE SELECT
select * from view_scoreV1
where sc_kor >= 50;

-- 평균점수가 60점 미만인 학생들
select * FROM view_scoreV1
where 평균 < 70;
-- SQL을 사용한 간이통계
-- 전체학생의 각 과목별 성적총점계산
-- 국어성적의 총점 계산
-- sum() : ANSI SQL의 총합계를 계산하는 통계함수
-- avg() : ANSI SQL의 평균을 계산하는 통계함수
-- max(),min() : ANSI SQL의 최댓값, 최솟값을 계산하는 통계함수
-- count() : ANSI SQL의 개수를 계산하는 통계함수

 select sum(sc_kor), avg(sc_kor)
 from view_scoreV1;
 
select 
avg(sc_kor) as 국어, 
avg(sc_eng) as 영어,
avg(sc_math) as 수학,
avg(sc_music) as 음악,
avg(sc_art) as 미술
from view_scoreV1;

-- MySQL8의 전용함수
select*
from view_scoreV1
order by 평균 DESC;

-- over (order by 평균 desc) : 평균을 오름차순한 것을 기준으로
-- rank() 순위를 계산하라
select*,
rank() over (order by 평균 desc) 랭킹
from view_scoreV1
order by 평균 DESC;

-- dense_rank() : 동점자 처리를 하되 석차를 건너뜀 없이
select*,
dense_rank() over (order by 평균 desc) 랭킹
from view_scoreV1
order by 평균 DESC;

-- sub Query : SQL 결과를 사용하여 다른 SQL 을 실행하는 것
select * from
(
select *,
rank() over (order by 평균 desc) 랭킹
from view_scoreV1
) sub
where sub랭킹 <5;
select sub.과목코드, sub.과목명 from
(
	select sc_stnum,'B001' as 과목코드,'국어' as 과목명,sc_kor from tbl_scoreV1
	union all
	select sc_stnum,'B002' ,'영어',sc_eng from tbl_scoreV1
	union all
	select sc_stnum,'B003' ,'수학',sc_math from tbl_scoreV1
	union all
	select sc_stnum,'B004' ,'음악',sc_music from tbl_scoreV1
	union all
	select sc_stnum,'B005' ,'미술',sc_art from tbl_scoreV1
	union all
	select sc_stnum,'B006' ,'소프트웨어',sc_software from tbl_scoreV1
	union all
	select sc_stnum,'B007' ,'데이터베이스',sc_database from tbl_scoreV1
) as sub
group by sub.과목코드, sub.과목명;
-- 학생정보 제 3정규화 데이터 테이블
-- 학번과 과목코드를 복합키(슈퍼키) PK생성
create table tbl_score(
	sc_stnum	VARCHAR(5)	NOT NULL,
	sc_bcode	VARCHAR(4)	NOT NULL,
	sc_score	INT	NOT NULL,
	PRIMARY KEY(sc_stnum,sc_bcode)	
);
-- 과목정보 테이블
create table tbl_subject(
	b_code	VARCHAR(4)		PRIMARY KEY,
	b_name	VARCHAR(20)		
);
-- 과목정보 Excel 데이터를 tbl_subject에 insert 해보기
insert into tbl_subject(b_code, b_name) values('B001','국어');
insert into tbl_subject(b_code, b_name) values('B002','영어');
insert into tbl_subject(b_code, b_name) values('B003','수학');
insert into tbl_subject(b_code, b_name) values('B004','음악');
insert into tbl_subject(b_code, b_name) values('B005','미술');
insert into tbl_subject(b_code, b_name) values('B006','소프트웨어');
insert into tbl_subject(b_code, b_name) values('B007','데이터베이스');
select count(*) from tbl_subject;
select count(*) from tbl_score;

-- 성적표와 과목정보를 join하여 
-- 학번, 과목코드, 과목명 ,점수를 projection 하여출력
select sc_stnum,b_code, b_name,sc_score 
from tbl_score
 left join tbl_subject
 on sc_bcode = b_code;
 
 -- 완전참조 관계 확인
 -- 다음의 LEFT JOIN 을 사용하여 확인 여기서 결과가 없어야 완전참조관계
 select sc_stnum,b_code, b_name,sc_score 
from tbl_score
 left join tbl_subject
 on sc_bcode = b_code
 where b_name is null;
 
-- 성적표와 과목정보가 완전 참조 관계일때는  EQ JOIN을 사용가능
 select sc_stnum,sc_bcode,b_name,sc_score
 from tbl_score,tbl_subject
 where sc_bcode = b_code;
 
-- 성적표와 과목정보가 앞으로도 계속 완전참조 관계가 되도록 
-- FK설정(완전참조 무결성 관계 설정)
 
 -- ANSI SQL
 alter table tbl_score
 add constraint F_subject foreign key(sc_bcode)
 references tbl_subject(b_code);
 
 -- MYSQL
alter table tbl_score
add foreign key F_subject(sc_bcode)
references tbl_subject(b_code);
 
 alter table tbl_score
drop foreign key tbl_score_ibfk_1;

-- on delete, on update
-- on delete  : Master(tbl_subject) table의 키가 삭제될때
/*
cascade : Master 삭제 -> sub도 모두 삭제
set null : Master 삭데  -> sub는 null
			만약 sub 칼럼이 not null 이면 오류발생
no action : Master삭제 -> sub에는 변화없이
set default : Master삭제 -> sub Table 생성할때
			default 옵션으로 지정한 값으로 세팅
restrict : 아무것도 하지마, 삭제하지마
*/
-- ont update : Master(tbl_subject) table의 키가 변경될때
 alter table tbl_score
 add constraint F_SUBJECT foreign key(sc_bcode)
 references tbl_subject(b_code)
 on delete cascade;
 
 select sc_stnum,sc_bcode,b_name, sc_score
 from tbl_score ,tbl_subject
 where sc_bcode = b_code and b_name = '국어';
 
 -- 학생별 총점 계산하기
 select sc_stnum, sum(sc_score)
 from tbl_score
 group by sc_stnum;
 
 -- 과목별 총점과 평균 계산하기
 select sc_bcode,sum(sc_score) 총첨 ,avg(sc_score) 평균
 from tbl_score
 group by sc_bcode;
 
 -- 제3정규화된 데이터를 PIVOT 펼쳐서 보고서 형식으로 출력
 -- 세로방향으로 펼쳐진 데이터를 가로방향으로 펼쳐서 보기
 select sc_stnum,
sum( if(sc_bcode ='B001',sc_score,0) )as 국어,
sum( if(sc_bcode ='B002',sc_score,0) )as 영어,
sum( if(sc_bcode ='B003',sc_score,0) )as 수학,
sum( if(sc_bcode ='B004',sc_score,0) )as 음악,
sum( if(sc_bcode ='B005',sc_score,0) )as 미술,
sum( if(sc_bcode ='B006',sc_score,0) )as 소프트웨어,
sum( if(sc_bcode ='B007',sc_score,0) )as 데이터베이스,
sum(sc_score) as 총점,
avg(sc_score) as 평균
from tbl_score
group by sc_stnum; 
 
 select sc_stnum, Sum(sc_score)
 from tbl_score
 group by sc_stnum;
 -- 통계함수로 학생별 총점을 계산하고
 -- 계산된 총점에 대하여 조건을 부여하여 selection 하기
 select sc_stnum, Sum(sc_score) as 총점
 from tbl_score
 group by sc_stnum
 having sum(sc_score) > 600;
 
  select sc_stnum, Sum(sc_score) as 총점
 from tbl_score
 group by sc_stnum
 having 총점 > 600;
 
 -- 학번이 S0010 보다 작은 학생들의 총점 계산
 select sc_stnum as 학번 , sum(sc_score)
 from tbl_score
 group by sc_stnum
 having 학번 < 'S0010';
 
 select sc_stnum as 학번 , sum(sc_score)
 from tbl_score
 where sc_stnum = 'S0010'
 group by sc_stnum;
 
 -- 총점이 S0010 보다 낮은 학생리스트 
 -- 조건절(where, having)에 sub query 적용하기
 -- 조건절에 적용하는 sub query는 결과가 반드시 한개 이하여야 한다.
 select sc_stnum as 학번 , sum(sc_score) as 총점
 from tbl_score
 group by sc_stnum
 having 총점 < (select sum(sc_score) from tbl_score where sc_stnum = 'S0001');
 
 
 
 
 
 
 
 