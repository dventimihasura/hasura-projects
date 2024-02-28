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

import io.hasura.netflixdgsjava1.model.Account;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;

@SpringBootTest
class JPATests {
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
    void save_my_first_object_to_the_db() {
	Account account = new Account();
	account.name = "Lisa";
	EntityManager session = sessionFactory.createEntityManager();
	session.getTransaction().begin();
	session.persist(account);
	session.getTransaction().commit();
    }

    @Test
    void hql_fetch_users() {
	EntityManager em = sessionFactory.createEntityManager();
	em.getTransaction().begin();
	em.getTransaction().commit();
	List<Account> accounts = em.createQuery("select u from Account u", Account.class).getResultList();
	accounts.forEach(System.out::println);
    }
}
