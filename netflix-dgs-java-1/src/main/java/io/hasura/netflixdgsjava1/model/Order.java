package io.hasura.netflixdgsjava1.model;

import jakarta.persistence.*;
import java.time.*;
import java.util.*;

@Entity
public class Order {
    @Id @GeneratedValue
    public UUID id;
    public UUID accountId;
    public String status;
    public String value;
    public LocalDateTime createdAt;
    public LocalDateTime updatedAt;
    public List<OrderDetail> orderDetails;
    public Region region;
}
