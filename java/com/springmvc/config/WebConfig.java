package com.springmvc.config;

import com.springmvc.interceptor.AdminInterceptor;
import com.springmvc.interceptor.LoginCheckInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginCheckInterceptor())
                .addPathPatterns(
                        "/post/add",
                        "/post/update",
                        "/post/delete",
                        "/product/add",
                        "/product/update",
                        "/product/delete",
                        "/vote/add",
                        "/vote/update",
                        "/vote/delete",
                        "/comment/**",
                        "/member/mypage",
                        "/chat/**"
                );

        registry.addInterceptor(new AdminInterceptor())
                .addPathPatterns("/admin/**");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:/home/admin/uploads/");
    }


}
