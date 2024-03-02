package io.hasura.netflixdgsjava2.model;

import java.util.UUID;

public class Account {
    private final UUID id;
    private final String name;

    public Account(UUID id, String name) {
	this.id = id;
	this.name = name;
    }

    public UUID getId() {
	return id;
    }

    public String getName() {
	return name;
    }
}
