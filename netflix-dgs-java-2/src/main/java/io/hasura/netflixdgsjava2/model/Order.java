package io.hasura.netflixdgsjava2.model;

import java.util.UUID;

public class Order {
    private final UUID id;
    private final String status;
    private final String region;

    public Order(UUID id, String status, String region) {
	this.id = id;
	this.status = status;
	this.region = region;
    }

    public UUID getId() {
	return id;
    }

    public String getStatus() {
	return status;
    }

    public String getRegion() {
	return region;
    }
}
