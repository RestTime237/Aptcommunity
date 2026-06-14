# 🏠 AptCommunity

아파트 입주민을 위한 커뮤니티 웹 애플리케이션

![Spring Boot](https://img.shields.io/badge/Spring_Boot-6DB33F?style=flat&logo=springboot&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)

👉 **[배포 사이트 바로가기](https://aptcommu.vps.webdock.cloud/)**

---

개발 기간 : 2025.03 ~ 2025.05

개발 인원 : 1명

담당 역할 : 기획 / 백엔드 / DB 설계 / 배포

---

## 📌 프로젝트 소개

아파트 입주민들이 공지사항 확인, 자유게시판 소통,
중고 거래, 입주민 투표 등을 할 수 있는 커뮤니티 플랫폼입니다.

---

## ⚙️ 기술 스택

| 분류 | 기술 |
|---|---|
| Backend | Java 17, Spring Boot, JDBC Template, MySQL 8.0 |
| Frontend | JSP, JavaScript, Bootstrap |
| DevOps | Docker, Nginx, VPS |

---

## 🏗️ 아키텍처
- Browser (JSP View)
- ↓ HTTPS
- Nginx (리버스 프록시)
- ↓
- Spring Boot (MVC) 
- Controller ←→ Service ←→ Repository
- ↓
- **MySQL (Persistent Volume)**

---

## ✨ 주요 기능

- 👥 회원가입/로그인 (세션 기반)
- 📢 공지사항 · 자유게시판 (CRUD)
- 🗳️ 주민 투표 시스템
- 📅 아파트 일정 관리
- ⚙️ 관리자 대시보드

---

## 🔧 트러블슈팅

### 1. EL태그 + JS 충돌
+ ❌ 문제: JSP 파일 내에서 EL 태그와 JS 변수 간의 간섭 발생
+ ✅ 해결: JS 변수를 \${변수} 형태로 변경

### 2. 서버가 재배포 될 때 DB가 사라지는 현상
+ ❌ 문제: 컨테이너 재생성 시 DB 데이터가 유지되지 않음
+ ✅ 해결: 로컬에서 사용하던 SQL 파일을 서버로 전송하여 DB 생성 후 기존 파일 대체

### 3. 이미지 파일 미노출
+ ❌ 문제: 업로드 된 이미지가 정상적으로 표시되지 않음
+ ✅ 해결: docker-compose.yml 파일에서 누락된 업로드 경로를 추가함
