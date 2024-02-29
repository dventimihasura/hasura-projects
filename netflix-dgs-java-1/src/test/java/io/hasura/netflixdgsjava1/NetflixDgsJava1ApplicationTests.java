package io.hasura.netflixdgsjava1;

import io.hasura.netflixdgsjava1.model.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.transaction.Transactional;

import java.util.*;
import org.hibernate.*;
import org.hibernate.boot.*;
import org.hibernate.boot.registry.*;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.*;

@SpringBootTest
class NetflixDgsJava1ApplicationTests {
    private EntityManagerFactory sessionFactory;
    
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
    @Transactional
    void save_my_first_object_to_the_db() {
	Account account = new Account();
	account.name = "Lisa";
	EntityManager session = sessionFactory.createEntityManager();
	session.persist(account);
    }

    @Test
    @Transactional
    void hql_fetch_users() {
	EntityManager session = sessionFactory.createEntityManager();
	List<Account> accounts = session.createQuery("select u from Account u ", Account.class).getResultList();
	accounts.forEach(System.out::println);
    }
}
