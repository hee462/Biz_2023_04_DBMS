-- 여기는 주소록 addr user 화면입니다.
/*
tbl_address table에 대하여 다음 결과를 확인하는 SQL을 작성
1.테이블에 저장된 전체 데이터의 개수는 몇개인가?
2.테이블에 저장된 전체 리스트를 전화번호 순으로 정렬하여 확인하기
3.테이블에 저장된 전체 리스트를 이름 순으로 정렬하여 확인하기
4.테이블에 저장된 전체 리스트중에 성씨가"이"으로 시작되는 리스트 확인하기
5.테이블에 저장된 전체 리스트중에 전화번호의 국번(두번째구역)이 3으로 시작되는 
리스트의 갯수는?
*/


SELECT COUNT(*) FROM tbl_address;
-- 오름차순(ASC) 생략가능
SELECT * 
FROM tbl_address
ORDER BY a_tel ;
-- 내림차순
SELECT * 
FROM tbl_address
ORDER BY a_tel DESC;

SELECT *
FROM tbl_address
ORDER BY a_name;

-- ID순으로 정렬하고, 같은 ID가 있으면 그 그룹에서 이름순으로 정렬
SELECT *
FROM tbl_address
ORDER BY a_id,a_name;
-- ID 순으로 오름차순 정렬하고, 같은 ID가 있으면 내림차순 하여 정렬
SELECT *
FROM tbl_address
ORDER BY a_id,a_name DESC;


SELECT *
FROM tbl_address 
WHERE a_name LIKE '이%';

SELECT COUNT (*)
FROM tbl_address 
WHERE a_tel LIKE '090-3%';
-- 위 코드 동일하게 작업됨
SELECT COUNT (*)
FROM tbl_address 
WHERE a_tel LIKE '____3%';

-- 중간 문자열 검색 , 전화번호 중에 3이 포함된 모든 전화번호
SELECT *
FROM tbl_address 
WHERE SUBSTR(a_tel,5,1) ='3';

-- 전화번호 국번이 3으로 시작되는 전화번호 중에서 
-- id가 가장 큰 데이터와 ID가 가장 작은 데이터를 찾으시오
SELECT MAX(a_id) 최댓값,MIN(a_id) 최솟값
FROM tbl_address 
WHERE SUBSTR(a_tel,5,1) ='3';




































