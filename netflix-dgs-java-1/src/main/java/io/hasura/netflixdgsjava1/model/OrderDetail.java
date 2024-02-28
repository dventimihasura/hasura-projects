package io.hasura.netflixdgsjava1.model;

import jakarta.persistence.*;
import java.time.*;
import java.util.*;

@Entity
public class OrderDetail {
    @Id @GeneratedValue
    public UUID id;
    public UUID orderId;
    public UUID productId;
    public int units;
    public LocalDateTime createdAt;
    public LocalDateTime updatedAt;
    public Order order;
    public Product product;
}
