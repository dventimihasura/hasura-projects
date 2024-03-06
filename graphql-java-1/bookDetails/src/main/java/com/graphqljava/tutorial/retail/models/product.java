package com.graphqljava.tutorial.retail.models;

import java.util.UUID;

public
    record product
    (UUID id,
     String name,
     Integer price,
     String created_at,
     String updated_at) {}
