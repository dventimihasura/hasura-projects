package io.hasura.hibernatejava1.model;

import jakarta.persistence.*;

@Entity
public class Region {
    @Id
    public String value;
    public String description;
}
