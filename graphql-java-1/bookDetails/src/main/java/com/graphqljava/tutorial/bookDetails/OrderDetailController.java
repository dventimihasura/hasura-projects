package com.graphqljava.tutorial.bookDetails;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.ArgumentValue;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.jdbc.core.simple.JdbcClient.StatementSpec;
import org.springframework.stereotype.Controller;

@Controller class OrderDetailController {
    static
	record order_detail
	(UUID id,
	 Integer units,
	 String created_at,
	 String updated_at) {}

    @Autowired JdbcClient jdbcClient;

    RowMapper<OrderDetailController.order_detail>
	orderDetailMapper = new RowMapper<OrderDetailController.order_detail>() {
		public OrderDetailController.order_detail mapRow (ResultSet rs, int rowNum) throws SQLException {
		    return
		    new OrderDetailController.order_detail
		    (UUID.fromString(rs.getString("id")),
		     rs.getInt("units"),
		     rs.getString("created_at"),
		     rs.getString("updated_at"));}};

    @QueryMapping List<OrderDetailController.order_detail>
	order_details (ArgumentValue<Integer> limit) {
	StatementSpec
	    spec = limit.isOmitted() ?
	    jdbcClient.sql("select * from order_detail") :
	    jdbcClient.sql("select * from order_detail limit ?").param(limit.value());
	return
	    spec
	    .query(orderDetailMapper)
	    .list();}

    @QueryMapping OrderDetailController.order_detail
	order_detail_by_pk (@Argument String id) {
	return
	    jdbcClient
	    .sql("select * from order_detail where id = ? limit 1")
	    .param(UUID.fromString(id))
	    .query(orderDetailMapper)
	    .optional()
	    .get();}}
