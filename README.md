# 🏠 AptCommunity

아파트 입주민을 위한 커뮤니티 웹 애플리케이션

![Spring Boot](https://img.shields.io/badge/Spring_Boot-6DB33F?style=flat&logo=springboot&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)

👉 **[배포 사이트 바로가기](https://aptcommu.vps.webdock.cloud/)**

---

## 📌 프로젝트 소개

아파트 입주민들이 공지사항 확인, 자유게시판 소통,
민원 접수 등을 할 수 있는 커뮤니티 플랫폼입니다.

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

### 1. Docker init.sql 마운트 실패
+ ❌ 문제: ./init:/docker-entrypoint-initdb.d → 디렉토리로 인식
+ ✅ 해결: ./init.sql:/docker-entrypoint-initdb.d/init.sql
+ SET FOREIGN_KEY_CHECKS=0; 추가

### 2. MySQL 데이터 영속성
+ ❌ 문제: volumes: - .:/var/lib/mysql → 호스트 의존
+ ✅ 해결: volumes: - mysql_data:/var/lib/mysql

### 3. EL태그 + JS 충돌
+ ❌ 문제: JSP 파일 내에서 EL 태그와 JS 변수 간의 간섭 발생
+ ✅ 해결: JS 변수를 \${변수} 형태로 변경
