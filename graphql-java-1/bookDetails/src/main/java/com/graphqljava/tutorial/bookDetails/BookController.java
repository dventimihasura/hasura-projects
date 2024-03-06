package com.graphqljava.tutorial.bookDetails;

import java.sql.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.graphql.data.method.annotation.*;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.core.simple.*;
import org.springframework.stereotype.*;

@Controller
class BookController {

    static record Author(String id,
		  String firstName,
		  String lastName) {}

    static record Book(String id,
		String name,
		int pageCount,
		String authorId) {}

    @SuppressWarnings("unused")
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private JdbcClient jdbcClient;

    @QueryMapping
    public BookController.Book bookById(@Argument String id) {
	return
	    jdbcClient
	    .sql("select * from book limit 1")
	    .query(new RowMapper<BookController.Book>() {
		    public BookController.Book mapRow(ResultSet rs, int rowNum) throws SQLException {
			return
			    new BookController.Book(rs.getString("ID"),
						    rs.getString("NAME"),
						    rs.getInt("PAGECOUNT"),
						    rs.getString("AUTHORID"));}})
	    .optional()
	    .get();}

    @SchemaMapping
    public BookController.Author author(BookController.Book book) {
	return
	    jdbcClient
	    .sql("select * from author limit 1")
	    .query(new RowMapper<BookController.Author>() {
		    public BookController.Author mapRow(ResultSet rs, int rowNum) throws SQLException {
			return
			    new BookController.Author(rs.getString("ID"),
						      rs.getString("FIRSTNAME"),
						      rs.getString("LASTNAME"));}})
	    .optional()
	    .get();}}
