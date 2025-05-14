package com.springmvc.service;

import com.springmvc.domain.Post;

import java.util.List;

public interface PostService {

    // CREATE

    void addPost(Post post);

    // UPDATE

    void updatePost(Post post);

    // DELETE

    void deletePost(Long id);

    //READ

    Post getPostById(Long id);

    List<Post> getPostByUserId(String userId, int offset, int limit);

    List<Post> getPagedPosts(int offset, int limit);

    int countAllposts();

    int getPostCount(String userId);

    List<Post> searchPosts(String category, String choice, String keyword, String sort, int limit, int offset);

    int getSearchResultCount(String category, String choice, String keyword);

    List<Post> getPopularPosts();

    //UTIL
    void incrementViews(Long id);

}
