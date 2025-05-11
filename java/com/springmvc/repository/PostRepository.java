package com.springmvc.repository;

import java.util.List;

import com.springmvc.domain.Post;

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
	
	public List<Post> findTop4ByLikeCount();
	
	//UTIL
	void incrementViews(Long id);

}
