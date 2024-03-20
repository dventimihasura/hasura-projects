package io.hasura.controllers;

import java.util.Optional;
import java.util.Set;
import java.util.UUID;

import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
// import org.springframework.graphql.data.method.annotation.Argument;
// import org.springframework.graphql.data.method.annotation.QueryMapping;
// import org.springframework.graphql.data.method.annotation.SchemaMapping;
// import org.springframework.stereotype.Controller;

import io.hasura.netflixdgsjava1.model.Account;
import io.hasura.netflixdgsjava1.model.Order;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;

// @Controller
public class AccountController {
    private EntityManagerFactory sessionFactory;

    public AccountController () {
	final StandardServiceRegistry registry = new StandardServiceRegistryBuilder().build();
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

    // @QueryMapping
    public Optional<Account> account_by_pk (UUID id) {
	EntityManager session = sessionFactory.createEntityManager();
	Optional<Account> opt = Optional.empty();
	for (Account a : session.createQuery("select u from Account u", Account.class).setMaxResults(1).getResultList()) return Optional.of(a);
	return opt;
    }

    // @SchemaMapping
    public Set<Order> orders (Account account) {
	return account.orders;
    }
}
