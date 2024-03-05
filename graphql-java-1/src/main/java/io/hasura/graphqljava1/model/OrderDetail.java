package io.hasura.netflixdgsjava1.model;

import jakarta.persistence.*;
import java.time.*;
import java.util.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Entity
@Table(name = "order_detail")
public class OrderDetail extends AbstractModel {
    @Id @GeneratedValue
    public UUID id;
    public int units;
    @ManyToOne(fetch=FetchType.EAGER)
    public Product product;
    @Column(name = "created_at") @CreationTimestamp
    public Date createdAt;
    @Column(name = "updated_at") @UpdateTimestamp
    public Date updatedAt;
}
