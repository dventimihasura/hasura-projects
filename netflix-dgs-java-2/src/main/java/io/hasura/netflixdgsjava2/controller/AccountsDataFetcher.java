package io.hasura.netflixdgsjava2.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import com.fasterxml.jackson.annotation.ObjectIdGenerators.UUIDGenerator;

import io.hasura.netflixdgsjava2.model.Account;

public class AccountsDataFetcher {
    private UUIDGenerator generator = new UUIDGenerator();
    private final List<Account> accounts = List.of(
						   new Account(generator.generateId(Account.class), "Scott")
						   );
    
    public List<Account> accounts() {
	return accounts.stream().filter(s -> true).collect(Collectors.toList());
    }
}
