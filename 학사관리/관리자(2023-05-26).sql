--관리자로 로그인한 화면
--관리자는 SYSDBZ 권한을 가진 사용자
--SYSDBA 사용자는 데이터베이스 시스템을 생성, 제거,파괴할수 있는 권한을 가진 사용자

--오라클에서 관리자로 로그인하여 수행할 작업
--TableSpace 생성, User 생성
--TABLESPACE : 데이터를 저장할 물리적 저장소(파일), 데이터를 저장하기 위하여
--              가장 먼저 생성해야 할 객체
--User : DBMS 서버에 로그인을 하고, 자신이 관리할 데이터들과 연결하는 객체
--       오라클에서 USER는 데이터 저장소의 개념이다. 
--      이 개념은 다른 DBMS 와는 약간 다르게 취급한다 -> 저장소 SCHEME라고 표현한다

--C:/app/data :TABLESPACE가 저장될 폴더

--TableSpace 생성(CREATE 키워드)
--student TABLESPACE를 생성하고 저장소는 student.db로 하고 초기용량은 1M,부족하면 1K씩 증가 
CREATE TABLESPACE student -- 저장소 이름을 student  이름으로 사용하겟다
DATAFILE'C:/app/data/student.dbf'--저장소 폴더에 파일 student.dbf으로 생성하겟다
SIZE 1M AUTOEXTEND ON NEXT 1K; --초기에 저장소 공간을 1M 확보하고 혹시부족하면 1K씩 자동 증가

--2.사용자 생성
--student라는 사용자를 생성하고 비밀번호 12341234로 설정하고
--기본 저장소 연결을 student로 설정하라

--오라클 12c 이후 버전에는 사용자 이름 등록하는 정책이 변경되었다
--만약 student라는 사용자를 생성하고 싶으면 C##student라는 이름으로 생성을 해야 한다
--이러한 정책은 보안적인 면에서 권장하지만 때로는 불편할때가 있다
--일부 프로그래밍 언어에서 DB에 접속할때 ##와 같은 특수문자가 있으면
--접속에 문제를 일으키는 경우가 있다
--오라클에서는 12c 이후에 사용자 생성 정책을 예전방식으로 사용할수 있도록 하는 
--설정을 제공한다
-- 이설정 명령은 user를 생성하기 전에 항상 실행해 주어야한다

ALTER SESSION SET "_ORACLE_SCRIPT" = true;
CREATE USER student IDENTIFIED BY 12341234
DEFAULT TABLESPACE student;

--3.사용자(student)는 DBMS 소프트웨어어 로그인하고 SQL 사용하여 table 생성하고
--CRUD 명령을 수행하여 데이터를 관리한다
-- 오라클에서 사용자를 생성한 직후에는 아무런 권한이 없다.
-- 심지어 DBMS 소프트웨어 로그인 할수도 없다
-- 사용자에게 권한을 부여하는 기능을 활성화 시켜줘야한다
-- 원칙적으로 권한부여는 각 항목별로 해야하지만 학습의 편리성으로 모든권한을 한번에 부여한다.

-- student사용자에게 DBA (데이터관리자) 권한을 부여하라
GRANT DBA TO student;







