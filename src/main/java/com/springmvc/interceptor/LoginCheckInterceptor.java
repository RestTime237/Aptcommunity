package com.springmvc.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

public class LoginCheckInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        System.out.println("로그인 체크 인터셉터 작동");
        HttpSession session = request.getSession();
        Object loginMember = session.getAttribute("mb");

        if (loginMember == null) {
            String requestURI = request.getRequestURI().substring(request.getContextPath().length());
            String queryString = request.getQueryString();
            if (queryString != null) {
                requestURI += "?" + queryString;
            }

            session.setAttribute("previousUrl", requestURI);
            response.sendRedirect(request.getContextPath() + "/member/login");

            return false;
        }

        return true;
    }
}
