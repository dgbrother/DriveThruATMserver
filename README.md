## JSP 파일 위치
```
$WEBDIR
```

## JAR 파일 추가 위치
```
/usr/share/tomcat8/lib
```
## 현재 추가된 JAR
+ json_simple-1.1.jar
+ gcm.server.jar

## 인터페이스

> Base URL : http://35.200.117.1:8080/control.jsp

### 구현 된 기능

+ [유저 정보 조회](#유저-정보-조회)  
+ [유저 정보 수정]()

### 유저 정보 조회

**parameter**

+ type : "user"
+ action : "select"  
+ userId : "현재 유저 아이디"

**예시**

```
String BASE_URL = "http://35.200.117.1:8080/control.jsp"

ContentValues params = new ContentValues();
        params.put("type",      "user");
        params.put("action",    "select");
        params.put("userId",    currentUserId);

NetworkTask getUserInfoTask = new NetworkTask(BASE_URL, params);
getUserInfoTask.execute();
```

**결과**
```
JSON Object
{
    "password": "PW1234!!",
    "carnumber": "12GK 1234",
    "name": "Ana Jo",
    "nfc": "nfc1234",
    "id": "ID1234",
    "email": "Ana@Joo.com",
    "account": "00-000-00-0"
}
```
#### [목록으로](#구현-된-기능)
---

### 유저 정보 수정

**parameter**

+ type : "user"
+ action : "update"  
+ userId : "현재 유저 아이디"
+ id | password | name | email | account | carNumber | nfcId

**예시**

```
String BASE_URL = http://35.200.117.1:8080/control.jsp?

ContentValues params = new ContentValues();
        params.put("type",      "user");
        params.put("action",    "update");
        params.put("userId",    currentUserId);
        params.put("id",        eUserID         .getText().toString());
        params.put("password",  eUserPassword   .getText().toString());
        params.put("name",      eUserName       .getText().toString());
        params.put("email",     eUserEmail      .getText().toString());
        params.put("account",   eUserAccount    .getText().toString());
        params.put("carNumber", eUserCarNumber  .getText().toString());
        params.put("nfcId",     eUserNFCID      .getText().toString());

NetworkTask updateUserInfoTask = new NetworkTask(BASE_URL, params);
updateUserInfoTask.execute();
```

**결과**
```
JSON Object (수정 된 UserInfo)
{
    "password": "PW1234!!",
    "carnumber": "12GK 1234",
    "name": "Ana Jo",
    "nfc": "nfc1234",
    "id": "ID1234",
    "email": "Ana@Joo.com",
    "account": "00-000-00-0"
}
```
#### [목록으로](#구현-된-기능)
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

입력 샘플

```
insert into customer values('ID1234','PW1234!!','hellozin','CAR0012','paul@gmail.com','00-000-00-0','nfc1234');
```
##### Reservation

```
create table reservation (
no int(10) not null auto_increment primary key,
id varchar(20) not null,
carnumber varchar(20) not null,
src_account varchar(20),
dst_account varchar(20),
amount varchar(20),
isdone varchar(2),
type varchar(10)
);
```

* type : 'send'(송금), 'withdraw'(출금), 'deposit'(입금)
  
입력 샘플

```
no 값은 auto increment

insert into reservation(type,id,carnumber,src_account,dst_account,amount,isdone) values('send','ID1111','CAR0012','00-000-00-0','11-111-11-1','50000','F');

```
