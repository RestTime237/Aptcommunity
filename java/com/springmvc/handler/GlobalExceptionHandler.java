package com.springmvc.handler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.NoHandlerFoundException;

@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    // 일반 예외 처리 (500 에러 등)
    @ExceptionHandler(Exception.class)
    public String handleException(Exception e, Model model) {
        logger.info("일반 예외 발생", e);  // <-- 여기 로그 추가
        model.addAttribute("errorMessage", e.getMessage());
        return "error/commonError"; // /WEB-INF/views/error/commonError.jsp
    }

    // 404 예외 처리
    @ExceptionHandler(NoHandlerFoundException.class)
    public String handle404(NoHandlerFoundException e, Model model) {
        logger.info("404 에러 발생: " + e.getRequestURL());  // <-- 여기 로그 추가
        model.addAttribute("errorMessage", e.getMessage());
        return "error/404"; // /WEB-INF/views/error/404.jsp
    }

    // 데이터베이스 오류 처리 (예: DB 연결 문제)
    @ExceptionHandler(DataAccessException.class)
    public String handleDatabaseError(DataAccessException e, Model model) {
        logger.info("데이터베이스 오류 발생", e);  // <-- 여기 로그 추가
        model.addAttribute("errorMessage", e.getMessage());
        return "error/dbError"; // /WEB-INF/views/error/dbError.jsp
    }
}
