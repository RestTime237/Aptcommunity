# 🏠 AptCommunity

아파트 입주민을 위한 커뮤니티 웹 애플리케이션

![Spring Boot](https://img.shields.io/badge/Spring_Boot-6DB33F?style=flat&logo=springboot&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)

👉 **[배포 사이트 바로가기](https://your-domain.com)**

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
| DevOps | Docker, Docker Compose, Nginx, VPS |

---

## 🏗️ 아키텍처
Client (React)
↓ HTTPS
Nginx (리버스 프록시)
↓
Spring Boot API
↓
MySQL (Named Volume)

---

## ✨ 주요 기능

- 회원가입 / 로그인 (Spring Security)
- 공지사항 · 자유게시판 CRUD
- 민원 접수 및 관리
- 관리자 페이지

---

## 🔧 트러블슈팅

### Docker init.sql 마운트 문제
- **문제**: init.sql이 디렉토리로 마운트되어 DB 초기화 실패
- **해결**: 폴더 단위 볼륨 마운트로 변경 + `SET FOREIGN_KEY_CHECKS=0` 추가

### MySQL 볼륨 데이터 관리
- **문제**: 컨테이너 재시작 시 데이터 초기화
- **해결**: Named Volume(`mysql_data`)으로 컨테이너와 데이터 분리

---

## 📬 Contact

- GitHub: [github.com/your-username](https://github.com/your-username)
- Email: your@email.com
