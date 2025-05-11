package com.springmvc.service;

import java.util.List;

import com.springmvc.domain.Comment;
import com.springmvc.domain.Product;

public interface CommentService {

	void addComment(Comment comment);                            // 댓글 추가
    List<Comment> getComments(String refType, Long refId);        // 대상 댓글 목록
    List<Comment> getReplies(Long parentId);                      // 대댓글 목록
    void updateComment(Comment comment);                         // 댓글 수정
    void deleteComment(Long id, String refType, Long refId);                                  // 댓글 삭제
    Comment getCommentById(Long id);                              // 댓글 단건 조회
    int getReplyCount(Long commentId);
}
