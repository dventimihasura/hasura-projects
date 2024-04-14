package io.hasura.hibernatejava1;

import org.hibernate.SessionFactory;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;

import io.hasura.hibernatejava1.model.Account;

public class Main {
    public static void main(String[] args) {
	SessionFactory sessionFactory;
	final StandardServiceRegistry registry =
            new StandardServiceRegistryBuilder()
	    .build();     
	try {
	    sessionFactory =
                new MetadataSources(registry)             
		.addAnnotatedClass(Account.class)   
		.buildMetadata()                  
		.buildSessionFactory();           
	}
	catch (Exception e) {
	    StandardServiceRegistryBuilder.destroy(registry);
	}
    }
}
