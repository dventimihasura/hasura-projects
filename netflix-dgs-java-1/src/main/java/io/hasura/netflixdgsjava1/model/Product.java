package io.hasura.netflixdgsjava1.model;

import jakarta.persistence.*;
import java.time.*;
import java.util.*;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Entity
public class Product {
    @Id @GeneratedValue
    public UUID id;
    public UUID accountId;
    public String name;
    public int price;
    @Column(name = "created_at") @CreationTimestamp
    public LocalDateTime createdAt;
    @Column(name = "updated_at") @UpdateTimestamp
    public LocalDateTime updatedAt;
    @OneToMany
    public OrderDetail orderDetail;
}
