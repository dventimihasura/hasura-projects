package io.hasura.netflixdgsjava1.model;

import jakarta.persistence.*;
import java.time.*;
import java.util.*;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Entity
public class OrderDetail {
    @Id @GeneratedValue
    public UUID id;
    public UUID orderId;
    public UUID productId;
    public int units;
    @Column(name = "created_at") @CreationTimestamp
    public LocalDateTime createdAt;
    @Column(name = "update_at") @UpdateTimestamp
    public LocalDateTime updatedAt;
    @ManyToOne
    public Product product;
}
