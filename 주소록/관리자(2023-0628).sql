----여기는 관리자 화면

-- 주소록 데이터를 관리하기 위하여 Project 시작
-- Oracle은 데이터를 저장하기 위하여 데이터 저장공간을 먼저 설정해야 한다
-- 물지적 저장공간을 tableSpace라고 한다

/*
addrDB라는 이름의 저장소를 만들겟다
실제 데이터가 저장되는 공간은 'c:/app/data/addr.dbf'파일이다
초기 크기는 1M(Byte) 이며 용량이 부족한면 1k(Byte)씩 자동으로 증가하라
*/

CREATE TABLESPACE addrDB
DATAFILE 'c:/app/data/addr.dbf'
SIZE 1M AUTOEXTEND ON NEXT 1K;

/*
Oracle에서는 실제 데이터는 TABLESPACE에 저장되지만
System을 통해 DB 데이터에 접근할때는 TABLESPACE를 통하지 않는다
생성된 TABLESPACE와 연결하는 사용자를 생성하고,
사용자


*/
















