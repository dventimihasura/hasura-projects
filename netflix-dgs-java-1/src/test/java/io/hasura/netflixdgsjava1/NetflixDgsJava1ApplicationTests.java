package io.hasura.netflixdgsjava1;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import com.fasterxml.jackson.databind.ObjectMapper;

import io.hasura.netflixdgsjava1.model.Account;

@SpringBootTest
class NetflixDgsJava1ApplicationTests {
    private SessionFactory sessionFactory;
    
    @BeforeEach
    protected void setUp() throws Exception {
	final StandardServiceRegistry registry = new StandardServiceRegistryBuilder()
	    .build();
	try {
	    sessionFactory = new MetadataSources(registry)
		.addAnnotatedClass(Account.class)
		.buildMetadata()
		.buildSessionFactory();
	}
	catch (Exception e) {
	    e.printStackTrace(System.err);
	    StandardServiceRegistryBuilder.destroy(registry);
	}
    }

    @Test
    void save_my_first_object_to_the_db() {
	Account account = new Account();
	account.name = "Lisa";
	try (Session session = sessionFactory.openSession()) {
	    session.beginTransaction();
	    session.persist(account);
	    session.getTransaction().commit();
	}
    }

    @Test
    void hql_fetch_users() {
	try (Session session = sessionFactory.openSession()) {
	    session.beginTransaction();
	    List<Account> accounts = session.createQuery("select u from Account u ", Account.class).list();
	    accounts.forEach(System.out::println);
	    session.getTransaction().commit();
	}
    }

    @Test
    @Disabled
    void how_does_hibernate_work() {
    }
}
