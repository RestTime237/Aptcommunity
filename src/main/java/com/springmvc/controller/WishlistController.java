package com.springmvc.controller;

import com.springmvc.service.wishlistService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Controller
@RequestMapping("/wishlist")
public class WishlistController {

    @Autowired
    private wishlistService wishlistService;

    @PostMapping("/toggle")
    public String toggleWishlist(@RequestParam("productId") Long productId, HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        if (userId != null) {
            wishlistService.toggleWishlist(userId, productId);
        }
        return "redirect:/product/detail?id=" + productId;
    }

    @PostMapping("/toggle-ajax")
    @ResponseBody
    public String toggleWishlistAjax(@RequestBody Map<String, Object> body, HttpSession session) {
        Long productId = Long.parseLong(body.get("productId").toString());
        String userId = (String) session.getAttribute("userId");

        System.out.println("아작스 요청 - 세션 userId :" + userId);

        if (userId != null) {
            boolean isNowishlisted;
            if (wishlistService.isWishlisted(userId, productId)) {
                wishlistService.removeWishlist(userId, productId);
                System.out.println("찜 상태 변경 - 찜 해제");
                isNowishlisted = false;
            } else {
                wishlistService.addWishlist(userId, productId);
                System.out.println("찜 상태 변경 - 찜");
                isNowishlisted = true;
            }
            return isNowishlisted ? "added" : "removed";
        }
        return "unauthorized";
    }
}
