package io.hasura.netflixdgsjava1.model;

import jakarta.persistence.*;
import java.time.*;
import java.util.*;

@Entity
public class Account {
    @Id @GeneratedValue
    public UUID id;
    public String name;
    public LocalDateTime createdAt;
    public LocalDateTime updatedAt;
    public List<Order> orders;
}
