package io.hasura.netflixdgsjava1.model;

import jakarta.persistence.*;
import java.time.*;
import java.util.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Entity
@Table(name = "product")
public class Product extends AbstractModel {
    @Id @GeneratedValue
    public UUID id;
    public String name;
    public int price;
    @Column(name = "created_at") @CreationTimestamp
    public Date createdAt;
    @Column(name = "updated_at") @UpdateTimestamp
    public Date updatedAt;
}
