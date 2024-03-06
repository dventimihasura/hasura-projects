package com.graphqljava.tutorial.bookDetails;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class BookRowMapper implements RowMapper<Book> {
    public Book mapRow(ResultSet rs, int rowNum) throws SQLException {
	Book book = new Book(rs.getString("ID"), rs.getString("NAME"), rs.getInt("PAGECOUNT"), rs.getString("AUTHORID"));
	return book;
    }
}
