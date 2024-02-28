package io.hasura.netflixdgsjava1.model;

import jakarta.persistence.*;
import java.time.*;
import java.util.*;

@Entity
public class Product {
    @Id @GeneratedValue
    public UUID id;
    public UUID accountId;
    public String name;
    public int price;
    public LocalDateTime createdAt;
    public LocalDateTime updatedAt;
}
