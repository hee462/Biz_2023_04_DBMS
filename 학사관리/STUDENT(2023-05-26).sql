-- 여기는 student 사용자 화면
-- student 사용자는 현재 DBA 권한을 가지고 있다
-- DBA 권한은 테이블 생성,수정,삭제, 데이터의 CRUD, COMMIT ROLLBACK등의 명령 수행가능

/*
                RDBMS에서 데이터 취급하기
    1.물리적인 저장소를 생성하기 :  오라클에서는 TableSpace =CREATE TABLESPACE
    2.Table 저장소 생성 : 논리적 개념 = table = CREATE TABLESPACE
    3.CRUD 구현하기

*/
--데이터 추가하기 전에 테이블 생성오류 발생시 제거후 재생성 하면된다
--DROP TABLE tbl_student;
CREATE TABLE tbl_student(

    st_num	  VARCHAR2(10)		PRIMARY KEY,
    st_name	  nVARCHAR2(20)	     NOT NULL,	
    st_dept	  nVARCHAR2(20),		
    st_grade	NUMBER,		
    st_tel	  VARCHAR2(20)	     NOT NULL	
    
);
--이미 데이터가 추가 되었는데 Table 구조에 문제를 발견햇을때
--Table 을 변경(수정) 하기
--st_tel 칼럼의 데이터 type 변경
--테이블의 구조를 변경하는 명령은 매우 비용이 크기때문에 사용하기전에 주의한다
--특히 칼럼의 크기(길이)를 변경하거나 type을 변경할때는 데이터 손상이 될수 있기때문에 주의한다.
ALTER TABLE tbl_student MODIFY (st_tel VARCHAR2(20));

-- 1. CRUD TEST
--1.데이터 추가 : CAREAT
--st_num은 PK로 선언되어 있기 때문에 데이터는 필수이며, 중복 될 수 없다.
--st_num 칼럼은 PK로 선언되어있기때문에 NOT NULL과 QNIQUE 성질을 갖는다 => 유일성
INSERT INTO tbl_student(st_num, st_name, st_dept, st_grade, st_tel)
VALUES('230001','홍길동','정보통신',3,'010-1111-1111');

INSERT INTO tbl_student(st_num, st_name, st_dept, st_grade, st_tel)
VALUES('230002','성춘향','법학과',3,'010-1234-1111');

INSERT INTO tbl_student(st_num, st_name, st_dept, st_grade, st_tel)
VALUES('230003','이몽룡','행정학과',2,'010-1111-1234');

-- 2. 데잍터 조회하기 :READ
--아무조건없이 모든데이터 보기 -> 나열 안됌
SELECT * FROM tbl_student;

--Projection
-- 칼럼을 원하는 순서대로 나열하여 모든 데이터 보이기
SELECT st_num, st_name, st_dept, st_grade, st_tel
FROM tbl_student;

--Projection
--전체 칼럼(속성)중에서 학번, 이름만 보이도록
SELECT st_num,st_name
FROM tbl_student;

--Selection
--데이터 중에서 이름(st_name) 값이 홍길동인 데이터들을 보여라
--조건부여 검색, 조건부여 SELECT, 조건부여 조회
SELECT st_num, st_name, st_dept, st_grade, st_tel
FROM tbl_student
WHERE st_name = '홍길동';

--전체 데이처를  SELECT 하되
--학생이름(st_name) 값을 기준으로 오름차순 정렬하여 보여라
SELECT st_num, st_name, st_dept, st_grade, st_tel
FROM tbl_student
ORDER BY st_name;

--학생이름으로 정렬하고, 같은 이름일때 전화번호 정렬하여 보여라
SELECT st_num, st_name, st_dept, st_grade, st_tel
FROM tbl_student
ORDER BY st_name,st_tel;

-- 3.UPDATE
-- Update를 수행할때는 내가 변경하는 데이터가 정말 변경하고자는 데이터인가? ->확인필수
-- 홍길동 학생의 전화번호가 010-1111-1111 에서 010-4321-1111 로 변경으로 수정


-- 문법적으로 아무런 문제가 없으나 결과적으로 심각한 문제를 안고 있다
-- 홍길동이라는 동명이인이 있을경우, 원하지 않는 데이터가 변경될 수있다.
--    이 코드를 실행하면 원하지 않는 홍길동 학새으이 전화번호가 변경될수 있다
--    이러한 현상을 "수정이상","변경이상"이라고 한다.
UPDATE tbl_student
SET st_tel = '010-4321-1111'
WHERE st_name = '홍길동';

-- Update 절차
-- 1.변경하고자 하는 데잍터를 조회한다
SELECT * FROM tbl_student
WHERE st_name = '홍길동';
-- 2.조회된 데이터 중에서 변겨하고자 하는 데이터의 PK가 무엇인지 확인한다
-- 여기서는 230001으로 확인이 되었다

-- 3.PK를 기준으로 데이터 변경하기
UPDATE tbl_student
SET st_tel = '010-4321-1111'
WHERE st_num = '230001';

-- 4. 데이터 삭제 : DELETE 효용이 없어진 데이터를 Table로부터 삭제하기
SELECT *FROM tbl_student;

--이몽룡(전화번호 010-1111-1234)학생이 자최를 하고 이민을 갔다.
--이몽룡학생의 데이터를 table에서 삭제하고자 한다
-- 동명이인인 이몽룡을 삭제하는 문제가 있다 
-- 원하지 않는 데이터가 삭제되는 현상을 "삭제이상"이라고 한다.
-- 이러한 코드도 매우 신정하게 사용해야 한다
DELETE FROM tbl_student
WHERE st_name = '이몽룡';

--                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      DELETE 절차
-- 1. 내가 삭제하고자 하는 이몽룡데이터 조회
SELECT *FROM tbl_student
WHERE st_name ='이몽룡';
-- 2. 삭제하고자 하는 데이터 PK 확인
-- '230003' PK 확인
-- 3. PK기준으로 데이터 삭제를 실행
DELETE FROM tbl_student
WHERE st_num = '230003';

COMMIT;












