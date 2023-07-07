-- 여기는 todo로 접근한 화면
use todoDB;


create table tbl_todolist(
	to_seq bigint primary key auto_increment,
    to_sdate varchar(10) not null,
    to_stime varchar(10) not null,
    to_content varchar(400) not null,
    to_edate varchar(10),
    to_etime varchar(10) 
);
desc tbl_todolist;