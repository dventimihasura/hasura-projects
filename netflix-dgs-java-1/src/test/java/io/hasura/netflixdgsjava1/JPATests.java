package io.hasura.netflixdgsjava1;

import io.hasura.netflixdgsjava1.model.*;
import jakarta.persistence.*;
import java.util.List;
import org.hibernate.boot.*;
import org.hibernate.boot.registry.*;
import org.junit.jupiter.api.*;
import org.springframework.boot.test.context.*;

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
    @Disabled
    void save_my_first_object_to_the_db() {
	Account account = new Account();
	account.name = "Lisa";
	EntityManager session = sessionFactory.createEntityManager();
	session.getTransaction().begin();
	session.persist(account);
	session.getTransaction().commit();
    }

    @Test
    @Disabled
    void hql_fetch_users() {
	EntityManager em = sessionFactory.createEntityManager();
	em.getTransaction().begin();
	em.getTransaction().commit();
	List<Account> accounts = em.createQuery("select u from Account u", Account.class).getResultList();
	accounts.forEach(System.out::println);
    }
}
