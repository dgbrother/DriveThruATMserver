## 해결해야 될 내용

+ DB
    + 실제 NFC, 차량번호 입력하기

+ 유저 정보
    + 수정할 수 있는 정보 제한

+ 예약 업무 실행
    + 현재 입금 시 처리하는 부분 없음
    + NFC 정보 입력으로(Rasp 요청) 업무 실행 시작하는 부분 추가
    + 업무 실행 후 ATM에 종료 알림 추가

## JSP 파일 위치
```
cd $WEBDIR
```

## JAR 파일 추가 위치
```
/usr/share/tomcat8/lib
```
## 현재 추가된 JAR

+ json_simple-1.1.jar
+ gcm.server.jar

## DB 접속 방법

```
sudo mysql -pghqkrth
use jspdb
show tables;
```

## 인터페이스

> Base URL : http://35.200.117.1:8080/control.jsp

### 구현 된 기능

+ [유저 정보 조회](#유저-정보-조회)  
+ [유저 정보 수정](#유저-정보-수정)
+ [예약 정보 조회](#예약-정보-조회)
+ [예약 정보 추가](#예약-정보-추가)
+ [예약 정보 삭제](#예약-정보-삭제)

### 유저 정보 조회

**parameter**

+ type : "user"
+ action : "select"  
+ userId : "현재 유저 아이디"

**예시**

```
String BASE_URL = "http://35.200.117.1:8080/control.jsp";

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
String BASE_URL = "http://35.200.117.1:8080/control.jsp";

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

### 예약 정보 조회

**parameter**

+ type : "reservation"
+ action : "select"  
+ from : "mobile" or "machine"
+ userId(from이 mobile 일 경우) : "현재 유저 아이디"
+ carNumber(from이 machine 일 경우) : "차량 번호"

**예시**

```
String BASE_URL = "http://35.200.117.1:8080/control.jsp";

ContentValues params = new ContentValues();
        params.put("type",      "reservation");
        params.put("action",    "select");
        
        // 모바일 일 경우
        params.put("from",      "mobile");
        params.put("userId",    "ID1234");

        // ATM 일 경우
        params.put("from",      "machine");
        params.put("carNumber", "CAR0012");

NetworkTask getReservationInfoTask = new NetworkTask(BASE_URL, params);
getReservationInfoTask.execute();

/*
모바일
http://35.200.117.1:8080/control.jsp?
type=reservation&action=select&from=mobile&userId=ID1234
ATM
http://35.200.117.1:8080/control.jsp?
type=reservation&action=select&from=machine&carNumber=CAR0012
*/
```

**결과**
```
{
    "data": [
        {
            "no": 1,
            "amount": "50000",
            "carnumber": "CAR0012",
            "src_account": "00-000-00-0",
            "dst_account": "11-111-11-1",
            "id": "ID1111",
            "type": "send",
            "isdone": "F"
        },
       ...
        {
            "no": 4,
            "amount": "10000",
            "carnumber": "CAR0012",
            "src_account": "11-111-00-0",
            "dst_account": "11-111-11-1",
            "id": "ID1111",
            "type": "withdraw",
            "isdone": "F"
        }
    ]
}
```
#### [목록으로](#구현-된-기능)

---

### 예약 정보 추가

**parameter**

+ type : "reservation"
+ action : "insert"  
+ id | bankingType | carNumber | src_account | dst_account | amount

**예시**

```
String BASE_URL = "http://35.200.117.1:8080/control.jsp";

ContentValues params = new ContentValues();
        params.put("type",          "reservation");
        params.put("action",        "insert");
        params.put("bankingType",   "send"); // or "deposit", "withdraw"
        params.put("id",            "ID1234");
        params.put("carNumber",     "CAR0012");
        params.put("src_account",   "00-000-00-0");
        params.put("dst_account",   "11-111-11-1");
        params.put("amount",        "10000");

NetworkTask insertReservationTask = new NetworkTask(BASE_URL, params);
insertReservationTask.execute();
```

**결과**
```
JSON Object-Array-Object 순 (새로운 예약 업무가 추가 된 ReserveInfo)
{
    "data": [
        {
            "no": 1,
            "amount": "50000",
            "carnumber": "CAR0012",
            "src_account": "00-000-00-0",
            "dst_account": "11-111-11-1",
            "id": "ID1111",
            "type": "send",
            "isdone": "F"
        },
       ...
        {
            "no": 4,
            "amount": "10000",
            "carnumber": "CAR0012",
            "src_account": "11-111-00-0",
            "dst_account": "11-111-11-1",
            "id": "ID1111",
            "type": "withdraw",
            "isdone": "F"
        }
    ]
}
```

#### [목록으로](#구현-된-기능)

---

### 예약 정보 삭제

**parameter**

+ type : "reservation"
+ action : "update"
+ from : "mobile" or "machine"
+ no : "1"(삭제할 예약 업무의 번호 : key)
+ userId(from이 mobile 일 경우) : "현재 유저 아이디"
+ carNumber(from이 machine 일 경우) : "차량 번호"

**예시**

```
String BASE_URL = "http://35.200.117.1:8080/control.jsp";

ContentValues params = new ContentValues();
        params.put("type",      "reservation");
        params.put("action",    "update");
        params.put("no",        "2");
        
        // 모바일 일 경우
        params.put("from",      "mobile");
        params.put("userId",    "ID1234");

        // ATM 일 경우
        params.put("from",      "machine");
        params.put("carNumber", "CAR0012");

NetworkTask deleteReservationInfoTask = new NetworkTask(BASE_URL, params);
deleteReservationInfoTask.execute();

/*
모바일
http://35.200.117.1:8080/control.jsp?
type=reservation&action=update&no=1&from=mobile&userId=ID1234
ATM
http://35.200.117.1:8080/control.jsp?
type=reservation&action=update&no=1&from=machine&carNumber=CAR0012
*/
```

**결과**
```
JSON Object-Array-Object 순 (삭제한 예약업무가 제외 된 ReserveInfo)
{
    "data": [
        {
            "no": 1,
            "amount": "50000",
            "carnumber": "CAR0012",
            "src_account": "00-000-00-0",
            "dst_account": "11-111-11-1",
            "id": "ID1111",
            "type": "send",
            "isdone": "F"
        },
       ...
        {
            "no": 4,
            "amount": "10000",
            "carnumber": "CAR0012",
            "src_account": "11-111-00-0",
            "dst_account": "11-111-11-1",
            "id": "ID1111",
            "type": "withdraw",
            "isdone": "F"
        }
    ]
}
```
#### [목록으로](#구현-된-기능)

### 예약 업무 실행

**parameter**

+ type : "reservation"
+ action : "execute"
+ carNumber : "차량번호"

**예시**

```
String BASE_URL = "http://35.200.117.1:8080/control.jsp?type=reservation&action=execute&carNumber=Car1234";

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
