package com.springmvc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springmvc.domain.Post;
import com.springmvc.repository.PostRepository;

@Service
public class PostServiceImpl implements PostService{
	
	@Autowired
	PostRepository postRepository;

	
	// CREATE
	
	@Override
	public void addPost(Post post) {
		postRepository.addPost(post);
		
	}

	// UPDATE
	
	@Override
	public void updatePost(Post post) {
		postRepository.updatePost(post);
		
	}
	
	// DELETE
	
	@Override
	public void deletePost(Long id) {
		postRepository.deletePost(id);
		
	}
	
	// READ
	
	@Override
	public Post getPostById(Long id) {
		return postRepository.getPostById(id);
	}

	@Override
	public List<Post> getPagedPosts(int offset, int limit) {
		return postRepository.getPagedPosts(offset, limit);
	}

	@Override
	public int countAllposts() {
		return postRepository.countAllposts();
	}

	@Override
	public List<Post> getPostByUserId(String userId, int offset, int limit) {
		return postRepository.getPostByUserId(userId, offset, limit);
	}

	@Override
	public int getPostCount(String userId) {
		return postRepository.getPostCount(userId);
	}

	@Override
	public List<Post> searchPosts(String category, String choice, String keyword, String sort, int limit, int offset) {
		return postRepository.searchPosts(category, choice, keyword, sort, limit, offset);
	}

	@Override
	public int getSearchResultCount(String category, String choice, String keyword) {
		return postRepository.getSearchResultCount(category, choice, keyword);
	}

	@Override
	public List<Post> getPopularPosts() {
	    return postRepository.findTop4ByLikeCount();
	}
	
	//UTIL
	@Override
	public void incrementViews(Long id) {
		postRepository.incrementViews(id);
		
	}
	
	
}


