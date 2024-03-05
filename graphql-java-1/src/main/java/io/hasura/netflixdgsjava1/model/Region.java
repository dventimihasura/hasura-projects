package io.hasura.netflixdgsjava1.model;

import jakarta.persistence.*;
import java.util.*;

@Entity
public class Region {
    @Id
    public String value;
    public String description;
}
