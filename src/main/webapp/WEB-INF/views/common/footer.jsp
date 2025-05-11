<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<head>
	<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
	<style>
		/* 푸터 스타일 */
        footer {
            background-color: #fff;
            border-top: 1px solid #e9ecef;
            padding: 3rem 0;
        }
        
        footer a {
            color: #333;
            transition: color 0.3s ease;
        }
        
        footer a:hover {
            color: #0D6EFD !important;
            transition: color 0.3s ease;
        }
        
        .footer-heading {
            font-weight: 600;
            margin-bottom: 1.25rem;
            color: #212529;
        }
        
        .footer-link {
            display: block;
            margin-bottom: 0.75rem;
            color: #6c757d;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        
        .footer-link:hover {
            color: #0d6efd;
            transform: translateX(5px);
        }
        
        .social-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            background-color: #e9ecef;
            color: #495057;
            border-radius: 50%;
            margin-right: 0.5rem;
            transition: all 0.3s ease;
        }
        
        .social-icon:hover {
            background-color: #0d6efd;
            color: white;
            transform: translateY(-3px);
        }
        
        .social-icon:hover .bi{
            color: white;
        }
	</style>
</head>

<footer class="mt-5">
        <div class="container">
            <div class="row">
                <div class="col-lg-4 mb-4 mb-lg-0">
                    <h5 class="footer-heading">아파트 커뮤니티</h5>
                    <p class="text-muted">이웃과 함께하는 편안한 아파트 생활을 위한 커뮤니티 서비스입니다.</p>
                    <div class="mt-4">
                        <a href="#" class="social-icon"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="social-icon"><i class="bi bi-instagram"></i></a>
                        <a href="#" class="social-icon"><i class="bi bi-twitter"></i></a>
                        <a href="#" class="social-icon"><i class="bi bi-youtube"></i></a>
                    </div>
                </div>
                <div class="col-lg-2 col-md-4 mb-4 mb-md-0">
                    <h5 class="footer-heading">서비스</h5>
                    <a href="/AptCommunity/post/list" class="footer-link">커뮤니티</a>
                    <a href="/AptCommunity/product/list" class="footer-link">중고마켓</a>
                    <a href="/AptCommunity/schedule/calendar" class="footer-link">아파트 일정</a>
                    <a href="/AptCommunity/vote/list" class="footer-link">주민투표</a>
                </div>
                <div class="col-lg-2 col-md-4 mb-4 mb-md-0">
                    <h5 class="footer-heading">고객지원</h5>
                    <a href="#" class="footer-link">공지사항</a>
                    <a href="#" class="footer-link">자주 묻는 질문</a>
                    <a href="#" class="footer-link">문의하기</a>
                    <a href="#" class="footer-link">이용약관</a>
                </div>
                <div class="col-lg-4 col-md-4">
                    <h5 class="footer-heading">관리사무소</h5>
                    <p class="text-muted mb-1">주소: 서울특별시 강남구 아파트로 123</p>
                    <p class="text-muted mb-1">전화: 02-123-4567</p>
                    <p class="text-muted mb-1">이메일: info@aptcommunity.com</p>
                    <p class="text-muted">운영시간: 평일 09:00 - 18:00</p>
                </div>
            </div>
            <hr class="my-4">
            <div class="row">
                <div class="col-md-6 text-center text-md-start">
                    <p class="text-muted mb-0">&copy; 2025 아파트 커뮤니티. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-center text-md-end">
                    <a href="#" class="text-muted me-3">개인정보처리방침</a>
                    <a href="#" class="text-muted">이용약관</a>
                </div>
            </div>
        </div>
    </footer>