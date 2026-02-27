show user;
-- USER이(가) "SYS"입니다.

alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

--  sistuser 이라는 오라클 일반사용자 계정을 생성합니다. 암호는 sistsix 라고 하겠습니다.
create user sistuser identified by sistsix default tablespace users;
-- User SISTUSER이(가) 생성되었습니다.


-- 생성되어진 오라클 일반사용자 계정인 sistuser 에게 오라클서버에 접속이 되어지고, 
-- 접속이 되어진 후 테이블 등을 생성할 수 있도록 권한을 부여해주겠다.
grant connect, resource, unlimited tablespace to sistuser;
-- Grant을(를) 성공했습니다.


------ **** 데이터베이스 링크(database link) 만들기 **** -------
   1. 탐색기에서 C:\oraclexe\app\oracle\product\11.2.0\server\network\ADMIN 에 간다.
   1. DB클라이언트 컴퓨터의 탐색기에서 C:\OracleXE18C\product\18.0.0\dbhomeXE\network\admin 에 간다.
   1. DB클라이언트 컴퓨터의 탐색기에서 C:\OracleXE21C\product\21c\homes\OraDB21Home1\network\admin 에 간다.
   
   2. tnsnames.ora 파일을 메모장으로 연다.
   
   3. SIXCLASS =
      (DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = 211.63.89.70)(PORT = 1521))
        (CONNECT_DATA =
          (SERVER = DEDICATED)
          (SERVICE_NAME = XE)
        )
      )

     을 추가한다.
     HOST = 211.63.89.70 이 연결하고자 하는 원격지 오라클서버의 IP 주소이다.
     그런데 전제조건은 원격지 오라클서버(211.63.89.70)의 방화벽에서 포트번호 1521 을 허용으로 만들어주어야 한다.
     
     그리고 SIXCLASS 를 'Net Service Name 네트서비스네임(넷서비스명)' 이라고 부른다.
     
     CHAESAM =
      (DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = 211.238.142.22)(PORT = 1521))
        (CONNECT_DATA =
          (SERVER = DEDICATED)
          (SERVICE_NAME = XE)
        )
      )

      을 추가한다.
     
   4. 명령프롬프트를 열어서 원격지 오라클서버(211.63.89.70)에 연결이 가능한지 테스트를 한다. 
      C:\Users\w2krg>tnsping SIXCLASS 5

        TNS Ping Utility for 64-bit Windows: Version 21.0.0.0.0 - Production on 01-2월 -2026 00:39:20
        
        Copyright (c) 1997, 2021, Oracle.  All rights reserved.
        
        사용된 매개변수 파일:
        C:\OracleXE21C\product\21c\homes\OraDB21Home1\network\admin\sqlnet.ora
        
        
        별칭 분석을 위해 TNSNAMES 어댑터 사용
        (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 211.63.89.70)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = XE)))에 접속하려고 시도하는 중
        확인(50밀리초)
        확인(50밀리초)
        확인(40밀리초)
        확인(50밀리초)
        확인(50밀리초)
      
      C:\Users\w2krg>tnsping CHAESAM 5

        TNS Ping Utility for 64-bit Windows: Version 21.0.0.0.0 - Production on 01-2월 -2026 00:35:28
        
        Copyright (c) 1997, 2021, Oracle.  All rights reserved.
        
        사용된 매개변수 파일:
        C:\OracleXE21C\product\21c\homes\OraDB21Home1\network\admin\sqlnet.ora
        
        
        별칭 분석을 위해 TNSNAMES 어댑터 사용
        (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 211.238.142.22)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = XE)))에 접속하려고 시도하는 중
        확인(40밀리초)
        확인(50밀리초)
        확인(50밀리초)
        확인(40밀리초)
        확인(50밀리초)   
        
        
    5.  데이터베이스 링크(database link) 만들기
    
    create database link chaesamServer
    connect to hr identified by happy   -- 이때 hr 과 암호 happy 는 연결하고자 하는 원격지 오라클서버(211.238.142.22)의 계정명과 암호 이다. 
    using 'CHAESAM';  -- CHAESAM 는 Net Service Name 네트서비스네임(넷서비스명) 이다.
    -- Database link CHAESAMSERVER이(가) 생성되었습니다.
    
    create database link sixclassServer
    connect to sistuser identified by sistsix   -- 이때 sistuser 과 암호 sistsix 는 연결하고자 하는 원격지 오라클서버(211.63.89.70)의 계정명과 암호 이다. 
    using 'SIXCLASS';  -- SIXCLASS 는 Net Service Name 네트서비스네임(넷서비스명) 이다.
    -- Database link SIXCLASSSERVER이(가) 생성되었습니다.
    
    
    ---- *** 생성되어진 데이터베이스 링크를 조회해봅니다. *** -----
    select *
    from user_db_links;
    /*
        --------------------------------------------------------------
         DB_LINK        USERNAME   PASSWORD      HOST        CREATED
        -------------------------------------------------------------- 
         SIXCLASSSERVER  SISTUSER                SIXCLASS    26/02/01
                                              -- SIXCLASS 는 Net Service Name 네트서비스네임(넷서비스명) 이다.
         CHAESAMSERVER   HR                      CHAESAM     26/02/01         
    */
    
    select * 
	from genie_music@chaesamServer;  --- 원격지 오라클서버(211.238.142.22)
	
    create table genie_music
    as
    select * 
	from genie_music@chaesamServer;
    
    select * 
	from genie_music;
    
    desc genie_music;
        
create table sistuser.genie_music
(NO        NUMBER  NOT NULL      
,CNO       NUMBER        
,RANK      NUMBER  NOT NULL      
,TITLE     VARCHAR2(200) NOT NULL 
,SINGER    VARCHAR2(100) NOT NULL 
,ALBUM     VARCHAR2(200) NOT NULL 
,POSTER    VARCHAR2(260) NOT NULL 
,STATE     CHAR(6)       
,IDCREMENT NUMBER        
,KEY       VARCHAR2(100) 
,HIT       NUMBER        
,LIKECOUNT NUMBER
);
    

insert into genie_music@sixclassServer
select * 
from genie_music;
-- 699개 행 이(가) 삽입되었습니다.

commit;

select * 
from sistuser.genie_music;


    
    ---- *** 데이터베이스 링크 삭제하기 *** ----
     drop database link TEACHERSERVER;
  -- Database link TEACHERSERVER이(가) 삭제되었습니다.
    
    