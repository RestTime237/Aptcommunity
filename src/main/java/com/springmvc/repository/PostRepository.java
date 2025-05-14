package com.springmvc.repository;

import com.springmvc.domain.Post;

import java.util.List;

public interface PostRepository {
    void addPost(Post post);

    void updatePost(Post post);

    void deletePost(Long id);

    Post getPostById(Long id);

    List<Post> getPagedPosts(int offset, int limit);

    int countAllposts();

    List<Post> getPostByUserId(String userId, int offset, int limit);

    int getPostCount(String userId);

    List<Post> searchPosts(String category, String choice, String keyword, String sort, int limit, int offset);

    int getSearchResultCount(String category, String choice, String keyword);

    List<Post> findTop4ByLikeCount();

    //UTIL
    void incrementViews(Long id);

}
