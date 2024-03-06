package com.graphqljava.tutorial.bookDetails;

record Book(String id,
	    String name,
	    int pageCount,
	    String authorId) {}
