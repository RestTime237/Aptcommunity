package com.springmvc.repository;

import com.springmvc.domain.Post;
import com.springmvc.rowmapper.PostRowMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

@Repository
public class PostRepositoryImpl implements PostRepository {


    private final JdbcTemplate jdbcTemplate;


    @Autowired
    public PostRepositoryImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // CREATE

    @Override
    public void addPost(Post post) {
        String SQL = "INSERT INTO post(title, content, category, userId, apartmentCode, dong) VALUES (?, ?, ?, ?, ?, ?)";

        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, post.getTitle());
            ps.setString(2, post.getContent());
            ps.setString(3, post.getCategory());
            ps.setString(4, post.getUserId());
            ps.setString(5, post.getApartmentCode());
            ps.setString(6, post.getDong());
            return ps;
        }, keyHolder);

        // 생성된 키(post.id)를 다시 객체에 저장
        post.setId(keyHolder.getKey().longValue());
    }


    // UPDATE

    @Override
    public void updatePost(Post post) {
        String SQL = "update post set title = ?, content = ?, category = ? where id = ?";
        jdbcTemplate.update(SQL, post.getTitle(), post.getContent(), post.getCategory(), post.getId());

    }

    // DELETE

    @Override
    public void deletePost(Long id) {
        String SQL = "delete from post where id = ?";
        jdbcTemplate.update(SQL, id);
    }

    // READ
    @Override
    public Post getPostById(Long id) {
        String SQL = "select * from post where id = ?";
        try {
            return jdbcTemplate.queryForObject(SQL, new PostRowMapper(), id);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public List<Post> getPagedPosts(int offset, int limit) {
        String SQL = "SELECT * FROM post ORDER BY CASE WHEN category = '공지' THEN 0 ELSE 1 END, createdAt DESC, id DESC LIMIT ? OFFSET ?";
        return jdbcTemplate.query(SQL, new PostRowMapper(), limit, offset);
    }

    @Override
    public int countAllposts() {
        String SQL = "select count(*) from post";
        return jdbcTemplate.queryForObject(SQL, Integer.class);
    }

    @Override
    public List<Post> getPostByUserId(String userId, int offset, int limit) {
        String SQL = "select * from post where userId = ? order by createdAt desc limit ? offset ?";
        return jdbcTemplate.query(SQL, new PostRowMapper(), userId, limit, offset);
    }


    @Override
    public int getPostCount(String userId) {
        String SQL = "select count(*) from post where userId = ?";
        return jdbcTemplate.queryForObject(SQL, new Object[]{userId}, Integer.class);
    }

    @Override
    public List<Post> searchPosts(String category, String choice, String keyword, String sort, int limit, int offset) {
        StringBuilder SQL = new StringBuilder("SELECT * FROM post WHERE 1=1");
        List<Object> params = new ArrayList<>();


        if (category != null && !category.isEmpty()) {
            SQL.append(" AND category = ?");
            params.add(category);
        }

        if (keyword != null && !keyword.isEmpty()) {
            if ("titleAndContent".equals(choice)) {
                SQL.append(" AND (title LIKE ? OR content LIKE ?)");
                String likeKeyword = "%" + keyword + "%";
                params.add(likeKeyword);
                params.add(likeKeyword);
            } else if ("writer".equals(choice)) {
                SQL.append(" AND userId LIKE ?");
                params.add("%" + keyword + "%");
            } else {
                SQL.append(" and (title like ? or content like ? or userId like ?)");
                String likeKeyword = "%" + keyword + "%";
                params.add(likeKeyword);
                params.add(likeKeyword);
                params.add(likeKeyword);
            }
        }

        SQL.append(" ORDER BY CASE WHEN category = '공지' THEN 0 ELSE 1 END");

        switch (sort) {
            case "views":
                SQL.append(", views DESC");
                break;
            case "likeCount":
                SQL.append(", likeCount DESC");
                break;
            case "latest":
            default:
                SQL.append(", createdAt DESC");
                break;
        }

        SQL.append(", id DESC");

        SQL.append(" limit ? offset ?");

        params.add(limit);
        params.add(offset);

        return jdbcTemplate.query(SQL.toString(), params.toArray(), new PostRowMapper());
    }

    @Override
    public int getSearchResultCount(String category, String choice, String keyword) {
        StringBuilder SQL = new StringBuilder("select count(*) from post where 1=1");
        List<Object> params = new ArrayList<>();

        if (category != null && !category.isEmpty()) {
            SQL.append(" AND category = ?");
            params.add(category);
        }


        if (keyword != null && !keyword.isEmpty()) {
            if ("titleAndContent".equals(choice)) {
                SQL.append(" AND (title LIKE ? OR content LIKE ?)");
                String likeKeyword = "%" + keyword + "%";
                params.add(likeKeyword);
                params.add(likeKeyword);
            } else if ("writer".equals(choice)) {
                SQL.append(" AND userId LIKE ?");
                params.add("%" + keyword + "%");
            } else {
                SQL.append(" and (title like ? or content like ? or userId like ?)");
                String likeKeyword = "%" + keyword + "%";
                params.add(likeKeyword);
                params.add(likeKeyword);
                params.add(likeKeyword);
            }
        }


        return jdbcTemplate.queryForObject(SQL.toString(), params.toArray(), Integer.class);
    }


    @Override
    public void incrementViews(Long id) {
        String SQL = "update post set views = views + 1 where id = ?";
        jdbcTemplate.update(SQL, id);
    }

    @Override
    public List<Post> findTop4ByLikeCount() {
        String SQL = "select * from post order by likeCount desc limit 4";
        return jdbcTemplate.query(SQL, new PostRowMapper());
    }


}
