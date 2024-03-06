package com.graphqljava.tutorial.bookDetails;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class AuthorRowMapper implements RowMapper<Author> {
    public Author mapRow(ResultSet rs, int rowNum) throws SQLException {
	Author author = new Author(rs.getString("ID"), rs.getString("FIRSTNAME"), rs.getString("LASTNAME"));
	return author;
    }
}
