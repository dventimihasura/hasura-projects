package io.hasura.hibernatejava1;

import io.hasura.hibernatejava1.model.*;
import io.hasura.hibernatejava1.model.Order;
import jakarta.persistence.EntityGraph;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Subgraph;
import jakarta.transaction.Transactional;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

class HibernateTests {
    private EntityManagerFactory sessionFactory;
    
    @BeforeEach
    protected void setUp() throws Exception {
	try {
	    sessionFactory = Persistence.createEntityManagerFactory("example");
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
	EntityManager em = sessionFactory.createEntityManager();
	em.persist(account);
    }

    @Test
    @Disabled
    public void hql_fetch_accounts () {
	EntityManager em = sessionFactory.createEntityManager();
	em.createQuery("select u from Account u", Account.class).setMaxResults(5).getResultList().forEach(System.out::println);
    }

    @Test
    @Disabled
    public void hql_fetch_orders () {
	EntityManager em = sessionFactory.createEntityManager();
	em.createQuery("select u from Order u", Order.class).setMaxResults(5).getResultList().forEach(System.out::println);
    }

    @Test
    public void entitygraph_test () {
	EntityManager em = sessionFactory.createEntityManager();
	EntityGraph<Account> graph = em.createEntityGraph(Account.class);
	Subgraph<Order> orderSubgraph = graph.addSubgraph("orders");
	Subgraph<OrderDetail> orderSubgraph2 = orderSubgraph.addSubgraph("orderDetails");
	orderSubgraph2.addSubgraph("product");
	Map<String, Object> hints = new HashMap<>();
	hints.put("javax.persistence.fetchgraph", graph);
	System.out.println(em.find(Account.class, UUID.fromString("8522dd95-82ba-40f4-914c-e53de362ebcb"), hints));
    }
}
