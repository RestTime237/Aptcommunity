package com.springmvc.repository;

import java.util.List;

import com.springmvc.domain.Comment;
import com.springmvc.domain.Product;

public interface CommentRepository {
	
	void save(Comment comment);                               // 댓글 추가
    List<Comment> findByRef(String refType, Long refId);       // 대상별 댓글 목록
    List<Comment> findReplies(Long parentId);                  // 대댓글 조회
    void update(Comment comment);                             // 댓글 수정
    void deleteComment(Long id, String refType, Long refId);                                      // 댓글 삭제 (소프트 삭제)
    Comment findById(Long id);
    int getReplyCount(Long commentId);
}
