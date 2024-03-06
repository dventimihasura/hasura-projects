package com.graphqljava.tutorial.retail;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.ArgumentValue;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.jdbc.core.simple.JdbcClient.StatementSpec;
import org.springframework.stereotype.Controller;

@Controller class OrderController {
    public static
	record order
	(UUID id,
	 String status,
	 String created_at,
	 String updated_at) {}

    @Autowired JdbcClient jdbcClient;

    RowMapper<OrderController.order>
	orderMapper = new RowMapper<OrderController.order>() {
		public OrderController.order mapRow (ResultSet rs, int rowNum) throws SQLException {
		    return
		    new OrderController.order
		    (UUID.fromString(rs.getString("id")),
		     rs.getString("status"),
		     rs.getString("created_at"),
		     rs.getString("updated_at"));}};

    @SchemaMapping List<OrderController.order>
	orders (AccountController.account account, ArgumentValue<Integer> limit) {
	StatementSpec
	    spec = limit.isOmitted() ?
	    jdbcClient.sql("select * from \"order\" where account_id = ?").param(account.id()) :
	    jdbcClient.sql("select * from \"order\" where account_id = ? limit ?").param(account.id()).param(limit.value());
	return
	    spec
	    .query(orderMapper)
	    .list();}

    @QueryMapping List<OrderController.order>
	orders (ArgumentValue<Integer> limit) {
	StatementSpec
	    spec = limit.isOmitted() ?
	    jdbcClient.sql("select * from \"order\"") :
	    jdbcClient.sql("select * from \"order\" limit ?").param(limit.value());
	return
	    spec
	    .query(orderMapper)
	    .list();}

    @QueryMapping OrderController.order
	order_by_pk (@Argument String id) {
	return
	    jdbcClient
	    .sql("select * from \"order\" where id = ? limit 1")
	    .param(UUID.fromString(id))
	    .query(new RowMapper<OrderController.order>() {
		    public OrderController.order mapRow (ResultSet rs, int rowNum) throws SQLException {
			return
			    new OrderController.order
			    (UUID.fromString(rs.getString("ID")),
			     rs.getString("name"),
			     rs.getString("created_at"),
			     rs.getString("updated_at"));}})
	    .optional()
	    .get();}}
