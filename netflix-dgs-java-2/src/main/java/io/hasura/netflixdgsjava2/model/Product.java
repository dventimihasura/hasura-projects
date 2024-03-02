package io.hasura.netflixdgsjava2.model;

import java.util.UUID;

public class Product {
    private final UUID id;
    private final String name;
    private final int price;

    public Product(UUID id, String name, int price) {
	this.id = id;
	this.name = name;
	this.price = price;
    }

    public UUID getId() {
	return id;
    }

    public String getName() {
	return name;
    }

    public int getPrice() {
	return price;
    }
}
