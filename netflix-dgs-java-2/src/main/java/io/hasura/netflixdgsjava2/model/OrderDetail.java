package io.hasura.netflixdgsjava2.model;

import java.util.UUID;

public class OrderDetail {
    private final UUID id;
    private int units;

    public OrderDetail(UUID id, int units) {
	this.id = id;
	this.units = units;
    }

    public UUID getId() {
	return id;
    }

    public int getUnits() {
	return units;
    }
}
