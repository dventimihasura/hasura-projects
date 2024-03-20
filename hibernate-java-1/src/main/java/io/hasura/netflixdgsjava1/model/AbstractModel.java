package io.hasura.netflixdgsjava1.model;

import com.google.gson.*;

public abstract class AbstractModel {
    public String toString() {
	return new Gson().toJson(this);
    }
}
