package io.hasura.netflixdgsjava1.model;

import jakarta.persistence.*;
import java.util.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Entity
@Table(name = "`order`")
public class Order extends AbstractModel {
    @Id @GeneratedValue
    public UUID id;
    @OneToMany
    @JoinColumn(name = "order_id")
    public Set<OrderDetail> orderDetails = new HashSet<>();
    @Column(name = "created_at") @CreationTimestamp
    public Date createdAt;
    @Column(name = "updated_at") @UpdateTimestamp
    public Date updatedAt;
}
