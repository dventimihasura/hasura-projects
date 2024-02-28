package io.hasura.netflixdgsjava1.model;

import jakarta.persistence.*;

import java.lang.reflect.Field;
import java.time.*;
import java.util.*;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Entity
public class Account {
    @Id @GeneratedValue
    public UUID id;
    public String name;
    @Column(name = "created_at") @CreationTimestamp
    public LocalDateTime createdAt;
    @Column(name = "updated_at") @UpdateTimestamp
    public LocalDateTime updatedAt;
    public String toString() {
	Class<Account> aClass = Account.class;
	Properties props = new Properties();
	for (Field f : Arrays.asList(aClass.getFields())) {
	    try {
		props.put(f.getName(), f.get(this));
	    }
	    catch (Exception e) {
		return "" + this;
	    }
	}
	return props.toString();
    }
}
