-- addr 사용자 화면

-- 주소록 + 취미정보가 있는 데이터를 정규화 하여 Relation 설정하기

CREATE TABLE tbl_temp_hb(
    hb_aid	VARCHAR2(5),
    hb_name1	nVARCHAR2(30),
    hb_name2	nVARCHAR2(30),
    hb_name3	nVARCHAR2(30)
);
SELECT * FROM tbl_temp_hb;
SELECT COUNT(*) FROM tbl_temp_hb;
/*
가로로 나열된 데이터를 세로로 배치하기

제 1정규화가 된 취미 데이터는 취미1, 취미2, 취미3 칼럼이 만들어진 table이다
이 테이블에 만약 4번째 취미를 추가하고 싶으면,
    새로운 칼럼을 추가하거나
    4번째 취미를 다른 취미항목으로 교체해야 한다

    만약 취미항목이 늘어나 칼럼을 추가하게 되면
    Table 구조를 변경해야하고, 상당히 많은 비용이 요구된다(시간 등)
    또한 Table 구조를 변경해야 하는 것은 매우 신중하기 처리해야한다.
    다른 어플리케이션과 연동되는 Table의 구조를 변경하면 아주 많은 부분에서
    변경을 해야하는 경우도 있다.
    
    만약 취미항목이 3개 미만인 경우는 데이터가 저장도지 않는 칼럼이 발생하고
    이 칼럼들은 보통 null 값으로 채워진다
    
    Table의 칼럼에 null 값이 많은것은 별로 좋은 현상이 아니다.


*/
SELECT hb_aid,hb_name1 FROM tbl_temp_hb
UNION ALL
SELECT hb_aid,hb_name2 FROM tbl_temp_hb
WHERE hb_name2 IS NOT NULL
UNION ALL
SELECT hb_aid,hb_name3 FROM tbl_temp_hb
WHERE hb_name3 IS NOT NULL
ORDER BY hb_aid;


CREATE TABLE tbl_hobby(
    hb_seq	NUMBER	PRIMARY KEY,
    hb_aid	VARCHAR2(5)	NOT NULL,	
    hb_name	nVARCHAR2(30)	NOT NULL	
);

SELECT * FROM tbl_hobby;
SELECT COUNT (*) FROM tbl_hobby;

-- 취미정보 제 3정규화

/*
DDL 명령 : DBA가 사용하는 명령들, 물리적 객체 생성, 제거, 변경을 수행하는 명령
CREATE : 객체 생성 ,최초 프로젝트 시작할때
DROP : 객체 제거, 최초 프로젝트 시작할때 잘못 생성된 객체를 다시 만들고자 할때
ALTER : 객체 변경 , 사용중에 중용한 변경사항이 발생했을때
                    구조변경을 수행하는 명령
                    구조변경은 매우 신중하게 수행해야 한다

주소 취미 Relation Table 의 제 3 정규화
제 2정규화가 되어있는 tbl_addr_hobby Table에는
주소록의 ID(hb_id)와 취미이름(hb_name)이 저장되있다
hb_id 칼럼은 주소 테이블과 연계되어 있지만 hb_name 칼럼은
평범한 문자열로 구성되어 있다.

만약 어떤 취미의 명칭을 변경하고자 할때는
UPDATE tbl_addr_hobby
SET hb_name = '변경할 이름'
WHERE hb_name ='원래이름'
과 같은 SQL을 사용해야 한다
이 SQL은 Table 데이터를 다수 변경하는 명령이 된다,
UPDATE 명령은 기본적으로 PK를 기준으로 1개의 데이터만 변경되도록 하는 것이 좋다
하지만 이 명령은 이러한 원칙에 위배된다

이때 업데이트, 삭제를 수행하는 과정에서 이 테이블에는 수정이상, 삭제이상 현상이 
발생 할 수 있다.
또한 취미 정보를 추가하는 과정에서 유사한 취미가 다른 형식으로, 등록되는 경우도 있다.

이러한 여러가지 문제를 방지하기 위하여, TABLE을 분리하여 제 3정규화를 수행한다

1. 기존의 TABLE에서 일반문자열로 되어있는 부분을 떼어 새로운 TABLE에 옮긴다
2. 기존 TABLE과 새로운 TABLE간에 RELATION 설정을 한다
*/

--1. tbl_hobby  table 이름변경 : Entity를 Relation으로 이름 변경
ALTER TABLE tbl_hobby
RENAME TO tbl_addr_hobby;

SELECT * FROM tbl_addr_hobby;

--2. 취미 Relation 에서 취미이름(hb_name) 항목을 중복데이터 없이 추출하기
-- 중복없이 데이터를 모으기
-- hb_name 칼럼 데이터를 같은 데이터끼리 그룹지어 리스트 만든다(중복제거)
-- GROUP BY : 중복된 데이터 없이 항목 묶기
SELECT hb_name
FROM tbl_addr_hobby
GROUP BY hb_name
ORDER BY hb_name;

--3. 제 3정규화 데이터 import
-- 주의 !! 기존 제2정규화 데이터를 엑셀로 보내서 제3정규화 데이터가 완료된 후
-- 다음에 진행할것
-- tbl_addr_hobby table 을 기존 table을 DROP 새로운 구조로 생성하기


DROP TABLE tbl_addr_hobby;
 CREATE TABLE tbl_addr_hobby (
    ah_seq	NUMBER		    PRIMARY KEY,
    ah_aid	VARCHAR2(5)	    NOT NULL,	
    ah_hbcode	VARCHAR2(5)	NOT NULL	
		
);
DESC tbl_addr_hobby;

SELECT COUNT (*) FROM tbl_addr_hobby;


SELECT ah_hbcode FROM tbl_addr_hobby
GROUP BY ah_hbcode
ORDER BY ah_hbcode;


--4. 취미 Entity import

DROP TABLE tbl_hobby;

CREATE TABLE tbl_hobby(
    hb_code	VARCHAR2(5)         PRIMARY KEY,
    hb_name	nVARCHAR2(30)       NOT NULL,
    hb_descrip	nVARCHAR2(400)

);

SELECT COUNT (*) FROM tbl_hobby;
SELECT *FROM tbl_addr_hobby;
-- Table JOIN
/*
정규화된(2,3 정규화) 된 Table의 정보를 Select(조회)하면 단순히 1개의 Table 만으로는
어떤 정보를 보여주고 있는지 알수가 없다
2,3 정규화 된 Table은 필연적으로 Table 간의 join이 되어야만 정보를 명확히 알수 있다
JOIN은 2개 이상의 Table을 서로 연계하여, 필요한 정보를 확인하는 것이다.
*/

-- tbl_addr_hobby 곱하기tbl_address
-- 카티션곱
SELECT *
FROM tbl_addr_hobby,tbl_address;
SELECT COUNT (*) FROM tbl_addr_hobby,tbl_address;

-- addr_hobby Relation 과 address Entity 테이블을 나열하되
-- 두 테이블의 칼럼 ah_aid 와 a_id의 데이터가 일치한 정보만 나열하라

-- EQ JOIN은 모든 JOIN 방식중에 가장 빠르다. 단 참조무결성이 제약조건이 완벽해야한다

-- EQ JOIN : 연계하는 Table 간에 참조무결성 제약조건이 완벽할때는 아무런 문제가 없이
-- 결과를 조회할수 있다
-- 하지만 연계하는 Table 간에 참조무결성 제약조건이 위배되면 조회된 데이터를 신뢰할수 없다
SELECT *
FROM tbl_addr_hobby,tbl_address
WHERE ah_aid = a_id;

SELECT ah_aid,a_name,a_tel,a_addr, ah_hbcode
FROM tbl_addr_hobby,tbl_address
WHERE ah_aid = a_id;

SELECT COUNT(*)
FROM tbl_addr_hobby,tbl_address
WHERE ah_aid = a_id;

SELECT COUNT (*)
FROM tbl_addr_hobby;
-- LEFT JOIN : 참조물결성이 의심스럽거나 위배될지 모른다는 전제하에 데이터를 확인하는 JOIN
-- FROM [table1] LETF JOIN [table2]
-- 왼쪽 있는 테이블1 데이터는 무조건 가지고 오고 오른쪽 테이블2에 설정한 조건에 맞는것만 가져오기
-- 오른쪽 테이블2에 조건에 맞는 데이터가 있으면 보여주고 없으면 null
-- 1.  SELECT 한 데이터의 누락이 발생하지 않는다
-- 2.  참조 무걸셩 제약조건이 환벽하게 성립하는지 확인하는 용도
-- 3.  
-- 왼쪽 있는 테이블 tbl_addr_hobby다 나열하고 tbl_address과 일치하는 것만 보여줘
-- 참조무결성을 확인하기 위한 코드
SELECT ah_aid,a_name,a_tel,a_addr, ah_hbcode
FROM tbl_addr_hobby
    LFET JOIN tbl_address
    ON ah_aid =a_id
    ORDER BY ah_aid;

-- NULL 값 찾아보자 
-- 주소취미 Relation과 `주소 Entity`간의 참조무결성 검사
-- 이 결과에서 list가 한개도 나오지 않아야 한다
SELECT ah_aid,a_name,a_tel,a_addr, ah_hbcode
FROM tbl_addr_hobby
    LFET JOIN tbl_address
    ON ah_aid = a_id
    WHERE a_name IS NULL
    ORDER BY ah_aid;

SELECT ah_aid, ah_hbcode,hb_name
FROM tbl_addr_hobby
LEFT JOIN tbl_hobby
ON ah_hbcode = hb_code;
-- 주소취미 Relation과  `취미 Entity`간의 참조무결성 검사
-- 이 결과에서 list가 한개도 나오지 않아야 한다    
SELECT ah_aid, ah_hbcode,hb_name
FROM tbl_addr_hobby
LEFT JOIN tbl_hobby
ON ah_hbcode = hb_code
WHERE hb_name IS NULL;

-- 현재 tbl_address Table의 데이터가 테스트 과정에서 문제가 생겼다
-- 저장된 데이터를 모두 clear 하고, 엑셀의 데이터로 다시 import 하자

-- 기존 테이블을 DROP 하고 다시 CREATE TABLE하라
TRUNCATE TABLE tbl_address;
SELECT * FROM tbl_address;

SELECT ah_aid ,ah_hbcode,a_name,a_tel,a_addr
FROM tbl_addr_hobby
LEFT JOIN tbl_address
ON ah_aid = a_id
WHERE ah_aid <= 'A0010';

SELECT ah_aid ,ah_hbcode,hb_name,hb_descrip
FROM tbl_addr_hobby
LEFT JOIN tbl_hobby
ON ah_hbcode = hb_code;

-- view 의 생성
-- 물리적 Table에 SQL 을 적용하여 작성하였더니 다소 복잡한 SQL이 오나성되었다
-- 이후 이 SQL을 사용할 일이 많을것 같다
-- 그래서 이 SQL 을 view로 생서하였따
-- view는 일반적으로 Read Only(SELECT만가능)


SELECT * FROM view_addr_hobby;

SELECT * FROM view_addr_hobby
WHERE ah_aid = 'A0002';

DROP VIEW view_addr_hobby;
CREATE VIEW view_addr_hobby

AS(
SELECT ah_aid AS 아이디,
        ah_hbcode AS 취미코드,
        hb_name AS 취미, 
        a_name AS 이름,
        a_tel AS 전화번호,
        a_addr AS 주소
    FROM tbl_addr_hobby
    LEFT JOIN tbl_address
        ON ah_aid = a_id
    LEFT JOIN tbl_hobby
        ON ah_hbcode = hb_code
);

-- 참조무결성 설정한기 : FOREIGN KEY  설정하기
-- 연계된 Entity, Relation 간에 참조관계가 잘 유지되도록, Table에 제약조건을
-- 설정하는 것

--1. FK는 Relation Table에 설정한다
--2. FK는 1 :N 관계 Table에서 N의 Table에 설정한다
-- addr_hobby 와 address 간의 FK 설정
ALTER TABLE tbl_addr_hobby -- tbl_addr_hobby TABLE(Relation table)
ADD CONSTRAINT F_ADDR      -- f_addr 이름으로 제약조건을 추가하겟다
FOREIGN KEY (ah_aid)       -- tbl_addr_hobby의 ah_aid칼럼을
REFERENCES tbl_address(a_id) -- tal_address table의 a_id칼럼과 연계


DELETE FROM tbl_address WHERE a_id ='A0001';

-- addr_hobby 와 hobby 간의 FK 설정
ALTER TABLE tbl_addr_hobby -- tbl_addr_hobby TABLE(Relation table)
ADD CONSTRAINT F_HOODY      -- f_addr 이름으로 제약조건을 추가하겟다
FOREIGN KEY (ah_hbcode)       -- tbl_addr_hobby의 ah_hbcode칼럼을
REFERENCES tbl_hobby(hb_code) -- tal_hobby table의 ah_hbcode칼럼과 연계

/*

Table 의 FK연계 조건
--------------------------------------------------------------------------------
tbl_address                tbl_hobby                  tbl_addr_hobby
--------------------------------------------------------------------------------
 코드가 있다    >>                                         코드가 있을수 있다
                             코드가 있다   >>              코드가 있을수 있다
 -------------------------------------------------------------------------------
 코드가 없다    >>                                            절대 없다
                             코드가 없다    >>                절대 없다
 반드시 있어야 한다                                      <<   코드가 있다 
                            반드시 있어야 한다           <<   코드가 있다
--------------------------------------------------------------------------------
 삭제할수 없다                                           <<   코드가 있다
                               삭제할수없다              <<   코드가 있다
--------------------------------------------------------------------------------
*/














