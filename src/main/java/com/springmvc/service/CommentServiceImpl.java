package com.springmvc.service;

import com.springmvc.domain.Comment;
import com.springmvc.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CommentServiceImpl implements CommentService {

    @Autowired
    private CommentRepository commentRepository;


    @Override
    public void addComment(Comment comment) {
        commentRepository.save(comment);
    }

    @Override
    public List<Comment> getComments(String refType, Long refId) {
        return commentRepository.findByRef(refType, refId);
    }

    @Override
    public List<Comment> getReplies(Long parentId) {
        return commentRepository.findReplies(parentId);
    }

    @Override
    public void updateComment(Comment comment) {
        commentRepository.update(comment);
    }

    @Override
    public void deleteComment(Long id, String refType, Long refId) {
        commentRepository.deleteComment(id, refType, refId);
    }

    @Override
    public Comment getCommentById(Long id) {
        return commentRepository.findById(id);
    }

    @Override
    public int getReplyCount(Long commentId) {
        return commentRepository.getReplyCount(commentId);
    }
}
