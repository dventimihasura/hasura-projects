package io.hasura.netflixdgsjava1;

import io.hasura.netflixdgsjava1.model.*;
import io.hasura.netflixdgsjava1.model.Order;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.transaction.Transactional;

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
    void save_my_first_object_to_the_db() {
	Account account = new Account();
	account.name = "Lisa";
	EntityManager session = sessionFactory.createEntityManager();
	session.persist(account);
    }

    @Test
    public void hql_fetch_users() {
	EntityManager session = sessionFactory.createEntityManager();
	session.createQuery("select u from Account u", Account.class).setMaxResults(5).getResultList().forEach(System.out::println);
	session.createQuery("select u from Order u", Order.class).setMaxResults(5).getResultList().forEach(System.out::println);
    }
}
