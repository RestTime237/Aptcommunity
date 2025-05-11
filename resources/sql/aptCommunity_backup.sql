-- ✅ 아파트 커뮤니티 DB 스키마 및 초기 데이터

-- 데이터베이스 생성 및 선택
CREATE DATABASE IF NOT EXISTS aptCommunitydb;
USE aptCommunitydb;

-- 회원 테이블
CREATE TABLE member (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    userId VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    nickname VARCHAR(50),
    apartmentCode VARCHAR(50),
    roadAddress VARCHAR(50),
    dong VARCHAR(20),
    role INT DEFAULT 0,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    profileImage VARCHAR(255)
);

-- 게시글 테이블
CREATE TABLE post (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    content TEXT,
    category VARCHAR(50),
    userId VARCHAR(50),
    apartmentCode VARCHAR(20),
    dong VARCHAR(50),
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    fileName VARCHAR(50),
    views INT DEFAULT 0,
    likeCount INT DEFAULT 0,
    FOREIGN KEY (userId) REFERENCES member(userId)
);

-- 댓글 테이블 (통합)
CREATE TABLE comment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    refType VARCHAR(20) NOT NULL,
    refId INT NOT NULL,
    parentId INT DEFAULT NULL,
    userId VARCHAR(50) NOT NULL,
    content TEXT NOT NULL,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    isDeleted BOOLEAN DEFAULT FALSE
);

-- 상품 테이블
CREATE TABLE product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status VARCHAR(20) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price INT NOT NULL,
    quantity INT NOT NULL,
    category VARCHAR(50) NOT NULL DEFAULT '기타',
    image VARCHAR(255),
    userId VARCHAR(50),
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    views INT DEFAULT 0,
    FOREIGN KEY (userId) REFERENCES member(userId)
);

-- 찜 테이블
CREATE TABLE wishlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userId VARCHAR(50) NOT NULL,
    productId INT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES member(userId),
    FOREIGN KEY (productId) REFERENCES product(id)
);

-- 이미지 테이블
CREATE TABLE image (
    id INT AUTO_INCREMENT PRIMARY KEY,
    refType VARCHAR(20),
    refId INT,
    fileName VARCHAR(255) NOT NULL,
    uploadedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 일정 테이블
CREATE TABLE eventSchedule (
    id INT AUTO_INCREMENT PRIMARY KEY,
    apartmentCode VARCHAR(20),
    title VARCHAR(100),
    description TEXT,
    startDate DATE,
    endDate DATE,
    category VARCHAR(30),
    publicFlag BOOLEAN DEFAULT TRUE
);

-- 채팅 테이블
CREATE TABLE chatRoom (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user1 VARCHAR(50) NOT NULL,
    user2 VARCHAR(50) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP
);

CREATE TABLE chatMessage (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roomId INT NOT NULL,
    senderId VARCHAR(50) NOT NULL,
    receiverId VARCHAR(50) NOT NULL,
    content TEXT CHARACTER SET utf8mb4 NOT NULL,
    isRead BOOLEAN DEFAULT FALSE,
    sentAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    readAt TIMESTAMP,
    FOREIGN KEY (roomId) REFERENCES chatRoom(id) ON DELETE CASCADE
);

-- 투표 테이블
CREATE TABLE vote (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    creatorId VARCHAR(50) NOT NULL,
    apartmentCode VARCHAR(20),
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    deadline DATETIME NOT NULL
);

CREATE TABLE voteOption (
    id INT AUTO_INCREMENT PRIMARY KEY,
    voteId INT NOT NULL,
    optionText VARCHAR(255) NOT NULL,
    FOREIGN KEY (voteId) REFERENCES vote(id) ON DELETE CASCADE
);

CREATE TABLE voteResult (
    id INT AUTO_INCREMENT PRIMARY KEY,
    voteId INT NOT NULL,
    optionId INT NOT NULL,
    memberId VARCHAR(50) NOT NULL,
    votedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (voteId) REFERENCES vote(id) ON DELETE CASCADE,
    FOREIGN KEY (optionId) REFERENCES voteOption(id) ON DELETE CASCADE
);

ALTER TABLE voteResult ADD CONSTRAINT unique_vote_per_user UNIQUE (voteId, memberId);

-- 추천 테이블
CREATE TABLE recommend (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userId VARCHAR(50) NOT NULL,
    refType VARCHAR(20) NOT NULL,
    refId BIGINT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(userId, refType, refId)
);

-- 관리자 설정
UPDATE member SET role = 3 WHERE userId = 'admin';

-- 테스트 유저
INSERT INTO member (username, userId, password, nickname, role)
VALUES ('테스트유저', 'testuser', '1234', 'tester', 0);

-- 테스트 게시글
INSERT INTO post (title, content, category, userId) VALUES
('아파트 주차장 이용 규칙 개선에 관한 제안', '테스트', '자유', 'test1'),
('이번 주말 단지 내 벼룩시장 개최 안내', '테스트', '행사', 'test2'),
('아파트 헬스장 이용 시간 변경 안내', '테스트', '정보', 'test3'),
('층간 소음 문제 해결을 위한 제안', '테스트', '자유', 'test4');

-- 테스트 이벤트
INSERT INTO eventSchedule (apartmentCode, title, description, startDate, endDate, category, publicFlag) VALUES 
('APT12345', '분리수거일', '1층 앞에 배치된 재활용품 분리수거함 이용', '2025-04-17', '2025-04-17', '환경', TRUE),
('APT12345', '방역 소독일', '해충 방제 작업이 오전 9시에 진행됩니다', '2025-04-20', '2025-04-20', '소독', TRUE),
('APT12345', '주민 회의', '관리사무소에서 주민 회의가 있습니다', '2025-04-21', '2025-04-21', '회의', TRUE);

-- 테스트 투표
INSERT INTO vote (title, content, creatorId, apartmentCode, createdAt, deadline) VALUES
('엘리베이터 리모델링 찬반 투표', '우리 아파트 엘리베이터를 교체하는 것에 대해 어떻게 생각하시나요?', 'testuser', 'APT1234', NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY)),
('주차장 확장 공사', '주차장 부족 문제 해결을 위해 공사를 추진하려고 합니다. 동의하십니까?', 'testuser', 'APT1234', NOW(), DATE_ADD(NOW(), INTERVAL 10 DAY)),
('경비실 냉난방기 교체', '노후된 냉난방기를 교체하기 위한 투표입니다.', 'testuser', 'APT5678', NOW(), DATE_ADD(NOW(), INTERVAL 5 DAY)),
('우리동 조경 리뉴얼', '정원 및 산책로 개선 공사 의견을 묻습니다.', 'testuser', NULL, NOW(), DATE_ADD(NOW(), INTERVAL 14 DAY)),
('커뮤니티 룸 리모델링', '노후된 커뮤니티 공간을 새롭게 리모델링하는 안건입니다.', 'testuser', NULL, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY));

-- 회원 테이블 조회
SELECT * FROM member;

-- 게시글 테이블 조회
SELECT * FROM post;

-- 댓글 테이블 조회
SELECT * FROM comment;

-- 상품 테이블 조회
SELECT * FROM product;

-- 찜 목록 테이블 조회
SELECT * FROM wishlist;

-- 이미지 테이블 조회
SELECT * FROM image;

-- 일정 스케줄 테이블 조회
SELECT * FROM eventSchedule;

-- 채팅방 테이블 조회
SELECT * FROM chatRoom;

-- 채팅 메시지 테이블 조회
SELECT * FROM chatMessage;

-- 투표 테이블 조회
SELECT * FROM vote;

-- 투표 옵션 테이블 조회
SELECT * FROM voteOption;

-- 투표 결과 테이블 조회
SELECT * FROM voteResult;

-- 추천 테이블 조회
SELECT * FROM recommend;
