package io.hasura.netflixdgsjava1.model;

import java.lang.reflect.Field;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;

@Entity
public class Order {
    @Id @GeneratedValue
    public UUID id;
    public UUID accountId;
    public String status;
    public String value;
    @Column(name = "created_at") @CreationTimestamp
    public LocalDateTime createdAt;
    @Column(name = "updated_at") @UpdateTimestamp
    public LocalDateTime updatedAt;
    @ManyToOne @JoinColumn(name = "account_id")
    public Account account;
    @OneToMany
    public Set<OrderDetail> orderDetails = new HashSet<>();
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
