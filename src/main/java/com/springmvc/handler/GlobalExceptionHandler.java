package com.springmvc.handler;

import org.springframework.dao.DataAccessException;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.NoHandlerFoundException;

@ControllerAdvice
public class GlobalExceptionHandler {
	
	@ExceptionHandler
	public String handleException(Exception e, Model model) {
		model.addAttribute("errorMessage", e.getMessage());
		return "error/commonError";
	}
	
	@ExceptionHandler(NoHandlerFoundException.class)
    public String handle404(NoHandlerFoundException e) {
        return "error/404";
    }

    @ExceptionHandler(DataAccessException.class)
    public String handleDatabaseError(Exception e, Model model) {
        model.addAttribute("errorMessage", "데이터베이스 처리 중 오류가 발생했습니다.");
        return "error/dbError";
    }
}
