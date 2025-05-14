package com.springmvc.interceptor;

import com.springmvc.domain.Member;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

public class AdminInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        Member user = (session != null) ? (Member) session.getAttribute("mb") : null;

        if (session == null || user == null || user.getRole() < 3) {
            response.sendRedirect("/AptCommunity/");
            return false;
        }
        return true;
    }

}
