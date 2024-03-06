package com.graphqljava.tutorial.retail.models;

import java.util.UUID;

public
    record order
    (UUID id,
     UUID account_id,
     String status,
     String created_at,
     String updated_at) {}
