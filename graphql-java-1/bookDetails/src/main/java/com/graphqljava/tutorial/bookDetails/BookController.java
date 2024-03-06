package com.graphqljava.tutorial.bookDetails;

import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Controller;

@Controller
class BookController {
    @Autowired
    private DataSource dataSource;
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private JdbcClient jdbcClient;

    @QueryMapping
    public Book bookById(@Argument String id) {
	Optional<Book> bookOptional = jdbcClient.sql("select * from book limit 1")
	    .query(new BookRowMapper())
	    .optional();
	return bookOptional.get();
        // return Book.getById(id);
    }

    @SchemaMapping
    public Author author(Book book) {
	Optional<Author> authorOptional = jdbcClient.sql("select * from author limit 1")
	    .query(new AuthorRowMapper())
	    .optional();
	return authorOptional.get();
        // return Author.getById(book.authorId());
    }

}
