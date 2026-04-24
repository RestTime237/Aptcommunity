package com.springmvc.repository;

import com.springmvc.domain.Comment;

import java.util.List;

public interface CommentRepository {

    void save(Comment comment);                               // 댓글 추가

    List<Comment> findByRef(String refType, Long refId);       // 대상별 댓글 목록

    List<Comment> findReplies(Long parentId);                  // 대댓글 조회

    void update(Comment comment);                             // 댓글 수정

    void deleteComment(Long id, String refType, Long refId);                                      // 댓글 삭제 (소프트 삭제)

    Comment findById(Long id);

    int getReplyCount(Long commentId);

    int countComments();
}
