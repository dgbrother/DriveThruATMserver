### JSP 파일 위치
```
$WEBDIR
```

### JAR 파일 추가 위치
```
/usr/share/tomcat8/lib
```
### 현재 추가된 JAR
+ json_simple-1.1.jar
+ gcm.server.jar

### 인터페이스

Server URL : http://35.200.117.1:8080


---

### Table Schema

##### Customer

```
create table customer (
id varchar(20) not null,
password varchar(20) not null,
name varchar(10) not null,
carnumber varchar(20),
email varchar(45),
account varchar(20) not null,
nfc varchar(20)
);
```
```
insert into customer values('ID1234','PW1234!!','hellozin','CAR0012','paul@gmail.com','00-000-00-0','nfc1234');
```
##### Reservation

```
create table reservation (
id varchar(20) not null,
carnumber varchar(20) not null,
src_account varchar(20),
dst_account varchar(20),
amount varchar(20),
isdone varchar(2)
);
```

```
insert into reservation values('ID1111','CAR0012','00-000-00-0','22-222-22-2','30000','F');
```