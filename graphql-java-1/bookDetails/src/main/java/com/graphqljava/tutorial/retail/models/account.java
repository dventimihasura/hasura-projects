package com.graphqljava.tutorial.retail.models;

import java.util.UUID;

public
    record account
    (UUID id,
     String name,
     String created_at,
     String updated_at) {}
