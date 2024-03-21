package io.hasura.hibernatejava1;

import org.stringtemplate.v4.*;

import graphql.language.Document;
import graphql.language.Field;
import graphql.language.Node;
import graphql.language.NodeTraverser;
import graphql.language.NodeVisitorStub;
import graphql.language.OperationDefinition;
import graphql.parser.Parser;
import graphql.util.TraversalControl;
import graphql.util.TraverserContext;
import graphql.validation.TraversalContext;
import io.hasura.hibernatejava1.model.*;
import io.hasura.hibernatejava1.model.Order;
import jakarta.persistence.EntityGraph;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Subgraph;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import jakarta.transaction.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

class HibernateTests {
    public static class FunVisitor extends NodeVisitorStub {
	@Override
	protected TraversalControl visitNode (Node node, TraverserContext<Node> context) {
	    return super.visitNode(node, context);
	}
    }


    private EntityManagerFactory emFactory;

    private SessionFactory sessionFactory;
    
    @BeforeEach
    protected void setUp() throws Exception {
	try {
	    emFactory = Persistence.createEntityManagerFactory("example");
	}
	catch (Exception e) {
	    e.printStackTrace(System.err);
	}
    }

    @Transactional
    @Test
    @Disabled
    void save_my_first_object_to_the_db () {
	Account account = new Account();
	account.name = "Lisa";
	EntityManager em = emFactory.createEntityManager();
	em.persist(account);
    }

    @Test
    @Disabled
    public void hql_fetch_accounts () {
	EntityManager em = emFactory.createEntityManager();
	em.createQuery("select u from Account u", Account.class).setMaxResults(5).getResultList().forEach(System.out::println);
    }

    @Test
    @Disabled
    public void hql_fetch_orders () {
	EntityManager em = emFactory.createEntityManager();
	em.createQuery("select u from Order u", Order.class).setMaxResults(5).getResultList().forEach(System.out::println);
    }

    @Test
    @Disabled
    public void entitygraph_test () {
	EntityManager em = emFactory.createEntityManager();
	EntityGraph<Account> graph = em.createEntityGraph(Account.class);
	Subgraph<Order> orderSubgraph = graph.addSubgraph("orders");
	Subgraph<OrderDetail> orderSubgraph2 = orderSubgraph.addSubgraph("orderDetails");
	orderSubgraph2.addSubgraph("product");
	Map<String, Object> hints = new HashMap<>();
	hints.put("javax.persistence.fetchgraph", graph);
	System.out.println(em.find(Account.class, UUID.fromString("d087c9af-b6c9-43a4-83f9-35ad6899b8dd"), hints));
    }

    @Test
    public void sessiongraph_test () {
	var em = emFactory.createEntityManager();
	var session = em.unwrap(Session.class);
	var graph = session.createEntityGraph(Account.class);
	var orderSubgraph = graph.addSubgraph("orders");
	var orderSubgraph2 = orderSubgraph.addSubgraph("orderDetails");
	orderSubgraph2.addSubgraph("product");
	var hints = new HashMap<>();
	hints.put("javax.persistence.fetchgraph", graph);
	var accounts = session.byMultipleIds(Account.class)
	    .withFetchGraph(graph)
	    .multiLoad(UUID.fromString("d087c9af-b6c9-43a4-83f9-35ad6899b8dd"),
		       UUID.fromString("d087c9af-b6c9-43a4-83f9-35ad6899b8dd"));
	accounts.forEach(System.out::println);
    }

    @Test
    @Disabled
    void st_test () {
        ST hello = new ST("Hello, <name>");
        hello.add("name", "World");
        System.out.println(hello.render());
    }

    @Test
    @Disabled
    void graphql_test () {
	Parser parser = new Parser();
	Document document = parser.parseDocument("query{products(limit:10){id order_details{id order_id order{id account{id}}}}}");
	System.out.println(document.getDefinitionsOfType(OperationDefinition.class).getFirst().getSelectionSet().getSelectionsOfType(Field.class).getFirst().getName());
    }

    @Test
    @Disabled
    void graphql_visit () {
	Parser parser = new Parser();
	Document document = parser.parseDocument("query{products(limit:10){id order_details{id order_id order{id account{id}}}}}");
	new NodeTraverser().preOrder(new NodeVisitorStub() {
		@Override
		protected TraversalControl visitNode (Node node, TraverserContext<Node> data) {
		    System.out.println(node);
		    return super.visitNode(node, data);}}, document);
    }
}
