package io.hasura.hibernatejava1;

import io.hasura.hibernatejava1.model.*;
import org.hibernate.*;
import org.hibernate.boot.*;
import org.hibernate.boot.registry.*;
import org.hibernate.cfg.*;
import static org.hibernate.cfg.AvailableSettings.*;

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
