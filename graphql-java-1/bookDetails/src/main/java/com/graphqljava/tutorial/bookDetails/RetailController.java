package com.graphqljava.tutorial.bookDetails;

import java.sql.*;
import java.util.*;

import org.springframework.beans.factory.annotation.*;
import org.springframework.graphql.data.method.annotation.*;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.core.simple.*;
import org.springframework.stereotype.*;

@Controller class RetailController {
    static
	record account (UUID id,
			String name,
			String created_at,
			String updated_at) {}

    @Autowired JdbcClient jdbcClient;

    @QueryMapping List<RetailController.account>
	accounts () {
	return
	    jdbcClient
	    .sql("select * from account limit 5")
	    .query(new RowMapper<RetailController.account>() {
		    public RetailController.account mapRow (ResultSet rs, int rowNum) throws SQLException {
			return
			    new RetailController.account(UUID.fromString(rs.getString("id")),
							 rs.getString("name"),
							 rs.getString("created_at"),
							 rs.getString("updated_at"));}})

	    .list();}

    @QueryMapping RetailController.account
	account_by_pk (@Argument String id) {
	return
	    jdbcClient
	    .sql("select * from account where id = ? limit 1")
	    .param(UUID.fromString(id))
	    .query(new RowMapper<RetailController.account>() {
		    public RetailController.account mapRow (ResultSet rs, int rowNum) throws SQLException {
			return
			    new RetailController.account(UUID.fromString(rs.getString("ID")),
							 rs.getString("name"),
							 rs.getString("created_at"),
							 rs.getString("updated_at"));}})

	    .optional()
	    .get();}}
