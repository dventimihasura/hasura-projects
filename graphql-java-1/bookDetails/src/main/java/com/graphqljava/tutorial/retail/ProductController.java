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

@Controller class ProductController {
    public static
	record product
	(UUID id,
	 String name,
	 String created_at,
	 String updated_at) {}

    @Autowired JdbcClient jdbcClient;

    RowMapper<ProductController.product>
	productMapper = new RowMapper<ProductController.product>() {
		public ProductController.product mapRow (ResultSet rs, int rowNum) throws SQLException {
		    return
		    new ProductController.product
		    (UUID.fromString(rs.getString("id")),
		     rs.getString("name"),
		     rs.getString("created_at"),
		     rs.getString("updated_at"));}};

    @SchemaMapping ProductController.product
	product (OrderDetailController.order_detail order_detail, @Argument String id) {
	return
	    jdbcClient
	    .sql("select * from product where id = ? limit 1")
	    .param(UUID.fromString(id))
	    .query(productMapper)
	    .optional()
	    .get();}

    @QueryMapping List<ProductController.product>
	products (ArgumentValue<Integer> limit) {
	StatementSpec
	    spec = limit.isOmitted() ?
	    jdbcClient.sql("select * from product") :
	    jdbcClient.sql("select * from product limit ?").param(limit.value());
	return
	    spec
	    .query(productMapper)
	    .list();}

    @QueryMapping ProductController.product
	product_by_pk (@Argument String id) {
	return
	    jdbcClient
	    .sql("select * from product where id = ? limit 1")
	    .param(UUID.fromString(id))
	    .query(productMapper)
	    .optional()
	    .get();}}
