package io.hasura.netflixdgsjava1;

import io.hasura.netflixdgsjava1.model.*;
import io.hasura.netflixdgsjava1.model.Order;
import jakarta.persistence.*;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import jakarta.transaction.Transactional;

import java.util.*;
import org.hibernate.*;
import org.hibernate.boot.registry.*;
import org.hibernate.cfg.*;
import org.junit.jupiter.api.*;
import org.testcontainers.containers.*;

class TestContainersTest {
    private SessionFactory sessionFactory;
    
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine")
	.withDatabaseName("postgres")
	.withUsername("postgres")
	.withPassword("postgres")
	.withInitScript("01_init_model.sql");

    @BeforeAll
    static void beforeAll() {
	postgres.start();
    }

    @AfterAll
    static void afterAll() {
	postgres.stop();
    }

    @BeforeEach
    void setUp() {
	Configuration cfg = new Configuration()
	    .setProperty("hibernate.show_sql", "True")
	    .setProperty("hibernate.format_sql", "True")
	    .setProperty("hibernate.highlight_sql", "True")
	    .setProperty("hibernate.connection.driver_class", "org.postgresql.Driver")
	    .setProperty("hibernate.connection.url", postgres.getJdbcUrl())
	    .setProperty("hibernate.connection.username", postgres.getUsername())
	    .setProperty("hibernate.connection.password", postgres.getPassword())
	    .addAnnotatedClass(Account.class)
	    .addAnnotatedClass(Order.class)
	    .addAnnotatedClass(OrderDetail.class)
	    .addAnnotatedClass(Product.class);

	final StandardServiceRegistry registry = new StandardServiceRegistryBuilder()
	    .build();
	try {
	    sessionFactory = cfg.buildSessionFactory();
	}
	catch (Exception e) {
	    e.printStackTrace(System.err);
	    StandardServiceRegistryBuilder.destroy(registry);
	}
    }

    @Test
    @Transactional
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
    @Transactional
    @Disabled
    void hql_fetch_users() {
	EntityManager em = sessionFactory.createEntityManager();
	em.getTransaction().begin();
	for (int i = 0; i<10; i++) {
	    Account account = new Account();
	    account.name = String.format("Lisa %s", i);
	    em.persist(account);
	}
	em.getTransaction().commit();
	List<Account> accounts = em.createQuery("select u from Account u", Account.class).getResultList();
	accounts.forEach(System.out::println);
    }

    @Test
    @Transactional
    @Disabled
    void criteria_api() {
	EntityManager em = sessionFactory.createEntityManager();
	em.getTransaction().begin();
	for (int i = 0; i<10; i++) {
	    Account account = new Account();
	    account.name = String.format("James %s", i);
	    em.persist(account);
	}
	em.getTransaction().commit();
	CriteriaBuilder cb = em.getCriteriaBuilder();
	CriteriaQuery<Account> criteriaQuery = cb.createQuery(Account.class);
	Root<Account> root = criteriaQuery.from(Account.class);
	criteriaQuery.select(root).where(cb.like(root.get(Account_.name), "James %"));
	TypedQuery<Account> query = em.createQuery(criteriaQuery);
	List<Account> accounts = query.getResultList();
	accounts.forEach(System.out::println);
    }
}
