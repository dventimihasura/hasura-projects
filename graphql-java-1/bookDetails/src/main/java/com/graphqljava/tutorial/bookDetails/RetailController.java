package com.graphqljava.tutorial.bookDetails;

import java.sql.*;
import java.util.*;

import org.springframework.beans.factory.annotation.*;
import org.springframework.graphql.data.ArgumentValue;
import org.springframework.graphql.data.method.annotation.*;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.core.simple.*;
import org.springframework.jdbc.core.simple.JdbcClient.StatementSpec;
import org.springframework.stereotype.*;

@Controller class RetailController {
    static
	record account
	(UUID id,
	 String name,
	 String created_at,
	 String updated_at) {}

    static
	record order
	(UUID id,
	 String status,
	 String created_at,
	 String updated_at) {}
    static
	record order_detail
	(UUID id,
	 Integer units,
	 String created_at,
	 String updated_at) {}

    static
	record product
	(UUID id,
	 String name,
	 String created_at,
	 String updated_at) {}

    @Autowired JdbcClient jdbcClient;

    RowMapper<RetailController.account>
	accountMapper = new RowMapper<>() {
	    public RetailController.account mapRow (ResultSet rs, int rowNum) throws SQLException {
		return
		    new RetailController.account
		    (UUID.fromString(rs.getString("ID")),
		     rs.getString("name"),
		     rs.getString("created_at"),
		     rs.getString("updated_at"));}};

    RowMapper<RetailController.order>
	orderMapper = new RowMapper<RetailController.order>() {
		public RetailController.order mapRow (ResultSet rs, int rowNum) throws SQLException {
		    return
		    new RetailController.order
		    (UUID.fromString(rs.getString("id")),
		     rs.getString("status"),
		     rs.getString("created_at"),
		     rs.getString("updated_at"));}};

    RowMapper<RetailController.order_detail>
	orderDetailMapper = new RowMapper<RetailController.order_detail>() {
		public RetailController.order_detail mapRow (ResultSet rs, int rowNum) throws SQLException {
		    return
		    new RetailController.order_detail
		    (UUID.fromString(rs.getString("id")),
		     rs.getInt("units"),
		     rs.getString("created_at"),
		     rs.getString("updated_at"));}};

    RowMapper<RetailController.product>
	productMapper = new RowMapper<RetailController.product>() {
		public RetailController.product mapRow (ResultSet rs, int rowNum) throws SQLException {
		    return
		    new RetailController.product
		    (UUID.fromString(rs.getString("id")),
		     rs.getString("name"),
		     rs.getString("created_at"),
		     rs.getString("updated_at"));}};

    @QueryMapping List<RetailController.account>
	accounts (ArgumentValue<Integer> limit) {
	StatementSpec
	    spec = limit.isOmitted() ?
	    jdbcClient.sql("select * from account") :
	    jdbcClient.sql("select * from account limit ?").param(limit.value());
	return
	    spec
	    .query(accountMapper)
	    .list();}

    @QueryMapping RetailController.account
	account_by_pk (@Argument String id) {
	return
	    jdbcClient
	    .sql("select * from account where id = ? limit 1")
	    .param(UUID.fromString(id))
	    .query(accountMapper)
	    .optional()
	    .get();}

    @SchemaMapping List<RetailController.order>
	orders (RetailController.account account, ArgumentValue<Integer> limit) {
	StatementSpec
	    spec = limit.isOmitted() ?
	    jdbcClient.sql("select * from \"order\" where account_id = ?").param(account.id) :
	    jdbcClient.sql("select * from \"order\" where account_id = ? limit ?").param(account.id).param(limit.value());
	return
	    spec
	    .query(orderMapper)
	    .list();}

    @QueryMapping List<RetailController.order>
	orders (ArgumentValue<Integer> limit) {
	StatementSpec
	    spec = limit.isOmitted() ?
	    jdbcClient.sql("select * from \"order\"") :
	    jdbcClient.sql("select * from \"order\" limit ?").param(limit.value());
	return
	    spec
	    .query(orderMapper)
	    .list();}

    @QueryMapping RetailController.order
	order_by_pk (@Argument String id) {
	return
	    jdbcClient
	    .sql("select * from \"order\" where id = ? limit 1")
	    .param(UUID.fromString(id))
	    .query(new RowMapper<RetailController.order>() {
		    public RetailController.order mapRow (ResultSet rs, int rowNum) throws SQLException {
			return
			    new RetailController.order
			    (UUID.fromString(rs.getString("ID")),
			     rs.getString("name"),
			     rs.getString("created_at"),
			     rs.getString("updated_at"));}})
	    .optional()
	    .get();}

    @QueryMapping List<RetailController.order_detail>
	order_details (ArgumentValue<Integer> limit) {
	StatementSpec
	    spec = limit.isOmitted() ?
	    jdbcClient.sql("select * from order_detail") :
	    jdbcClient.sql("select * from order_detail limit ?").param(limit.value());
	return
	    spec
	    .query(orderDetailMapper)
	    .list();}

    @QueryMapping RetailController.order_detail
	order_detail_by_pk (@Argument String id) {
	return
	    jdbcClient
	    .sql("select * from order_detail where id = ? limit 1")
	    .param(UUID.fromString(id))
	    .query(orderDetailMapper)
	    .optional()
	    .get();}

    @QueryMapping List<RetailController.product>
	products (ArgumentValue<Integer> limit) {
	StatementSpec
	    spec = limit.isOmitted() ?
	    jdbcClient.sql("select * from product") :
	    jdbcClient.sql("select * from product limit ?").param(limit.value());
	return
	    spec
	    .query(productMapper)
	    .list();}

    @QueryMapping RetailController.product
	product_by_pk (@Argument String id) {
	return
	    jdbcClient
	    .sql("select * from product where id = ? limit 1")
	    .param(UUID.fromString(id))
	    .query(productMapper)
	    .optional()
	    .get();}}
