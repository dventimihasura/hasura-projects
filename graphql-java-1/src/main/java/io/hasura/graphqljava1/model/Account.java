package io.hasura.netflixdgsjava1.model;

import jakarta.persistence.*;
import java.lang.reflect.*;
import java.util.*;

@Entity
@Table(name = "account")
public class Account extends AbstractModel {
    @Id @GeneratedValue
    public UUID id;
    public String name;
    @OneToMany
    @JoinColumn(name = "account_id")
    public Set<Order> orders = new HashSet<>();
}
