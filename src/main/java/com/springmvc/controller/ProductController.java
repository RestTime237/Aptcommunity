package com.springmvc.controller;

import com.springmvc.domain.Comment;
import com.springmvc.domain.Image;
import com.springmvc.domain.Member;
import com.springmvc.domain.Product;
import com.springmvc.service.CommentService;
import com.springmvc.service.ImageService;
import com.springmvc.service.ProductService;
import com.springmvc.service.wishlistService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;


@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private wishlistService wishlistService;

    @Autowired
    private CommentService commentService;

    @Autowired
    private ImageService imageService;

    // CREATE

    @GetMapping("/add")
    public String addProductForm(@ModelAttribute("NewProduct") Product product, HttpSession session) {
        Member mb = (Member) session.getAttribute("mb");
        if (mb == null) return "redirect:/member/login";

        return "product/productForm";
    }

    @PostMapping("/add")
    public String addProduct(@ModelAttribute("NewProduct") Product product, HttpSession session, HttpServletRequest req) {
        Member mb = (Member) session.getAttribute("mb");

        if (mb == null) return "redirect:/member/login";        // 로그인 상태 확인

        product.setUserId(mb.getUserId());        // userId 삽입

        String thumbnail = extractFirstImageUrl(product.getDescription());        // html에서 썸네일 이미지 이름 추출
        product.setImage(thumbnail);        // dto에 등록
        System.out.println("썸네일" + thumbnail);


        productService.addProduct(product);        // 게시글 등록


        imageService.updateRefIdForRecent("product", product.getId());        // 이미지에 refId 할당
        System.out.println("이미지 refId 업데이트 실행 : " + product.getId());

        return "redirect:/product/list";
    }

    // UPDATE

    @GetMapping("/update")
    public String updateProductForm(@RequestParam("id") Long id, Model model) {
        Product product = productService.getProductById(id);        // 업데이트 할 판매글 불러오기

        model.addAttribute("updateProduct", product);        // 폼에 현재 데이터 뿌리기용
        return "product/productUpdate";
    }

    @PostMapping("/update")
    public String updateProduct(@ModelAttribute("updateProduct") Product product) {

        String thumbnail = extractFirstImageUrl(product.getDescription());        // html에서 이미지 주소 추출
        product.setImage(thumbnail);        // dto에 등록

        productService.updateProduct(product);        // 판매글 업데이트

        List<Image> images = extractImageObjects(product.getDescription());        // 프로덕트에서 설명을 가져와서 이미지 추출

        imageService.updateImageReferences("product", product.getId(), images);        // 이미지 업데이트 실행

        return "redirect:/product/detail?id=" + product.getId();

    }

    // DELETE

    @GetMapping("/delete")
    @ResponseBody
    public String deleteProduct(@RequestParam("id") Long id, HttpServletRequest req) {
        String path = req.getServletContext().getRealPath("resources/images");        // 이미지 저장 주소
        productService.deleteProduct(id);        // 판매글 삭제 실행
        imageService.deleteImage("product", id, path);        // 이미지 삭제 실행
        return "success";
    }

    // READ

    @GetMapping("/list")
    public String productList(HttpSession session, Model model) {
        // 초기 뷰 로딩용
        return "product/productList";
    }

    @GetMapping("/detail")
    public String productDetail(@RequestParam("id") Long productId, HttpSession session, Model model) {

        Product product = productService.getProductById(productId);
        String userId = (String) session.getAttribute("userId");
        Long id = product.getId();

        boolean isWishlisted = false;        // 초기 찜 상태 설정

        if (userId != null) {
            isWishlisted = wishlistService.isWishlisted(userId, productId);        // 로그인 중이면 찜상태 가져오기
        }

        productService.incrementViews(id);

        List<Comment> comments = commentService.getComments("product", id);        // 판매글에 달린 댓글 가져오기

        List<Product> otherProducts = productService.getOtherProductsByUser(product.getUserId(), product.getId(), 3);
        List<Product> relatedProducts = productService.getRelatedProducts(product.getCategory(), product.getId(), 4);

        model.addAttribute("product", product);
        model.addAttribute("otherProducts", otherProducts);
        model.addAttribute("relatedProducts", relatedProducts);
        model.addAttribute("isWishlisted", isWishlisted);
        model.addAttribute("comments", comments);

        return "product/productDetail";
    }

    @GetMapping("/search")
    @ResponseBody
    public Map<String, Object> searchProducts(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String choice,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String sort,
            @RequestParam(required = false) Long minPrice,
            @RequestParam(required = false) Long maxPrice,
            @RequestParam(defaultValue = "1") int page,
            HttpSession session) {

        int limit = 12;        // 한 페이지당 12개의 게시물 제한
        int offset = (page - 1) * limit;        // 몇번째 글 부터 가져올지 계산

        List<Product> products = productService.searchProducts(category, status, choice, keyword, sort, minPrice, maxPrice, limit, offset);
        int totalCount = productService.getSearchResultCount(category, status, choice, keyword, minPrice, maxPrice);
        int totalPages = (int) Math.ceil((double) totalCount / limit);

        String userId = (String) session.getAttribute("userId");
        List<Long> wishlistedIds = new ArrayList<>();

        if (userId != null) {
            List<Product> wishlist = wishlistService.getWishlistByUser(userId);
            wishlistedIds = wishlist.stream().map(Product::getId).collect(Collectors.toList());
        }

        Map<String, Object> result = new HashMap<>();
        result.put("products", products);
        result.put("wishlistedIds", wishlistedIds);
        result.put("currentPage", page);
        result.put("totalPages", totalPages);


        return result;
    }

    // UTILITY

    private List<Image> extractImageObjects(String content) {
        List<Image> images = new ArrayList<>();
        if (content == null) return images;

        Pattern pattern = Pattern.compile("<img[^>]*src=[\"']([^\"']+)[\"'][^>]*>");
        Matcher matcher = pattern.matcher(content);
        while (matcher.find()) {
            String src = matcher.group(1);
            String saveName = src.substring(src.lastIndexOf("/") + 1);

            Image img = new Image();
            img.setFileName(saveName);
            images.add(img);
        }

        return images;
    }

    public String extractFirstImageUrl(String html) {
        Pattern pattern = Pattern.compile("<img[^>]+src=[\"']?([^\"'>]+)[\"']?");
        Matcher matcher = pattern.matcher(html);
        return matcher.find() ? matcher.group(1) : null;
    }


}
