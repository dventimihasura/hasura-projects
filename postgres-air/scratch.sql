-- -*- sql-product; postgres; -*-

set search_path to "$user", public, postgres_air;

set max_parallel_workers_per_gather = 0;

set max_parallel_workers_per_gather = 2;

explain
select
  count(*)
  from
    boarding_pass
    left join booking_leg using (booking_leg_id)
    left join flight using (flight_id)
 where
   precheck is not null
   and (
     seat = '0B' or aircraft_code = '330');

explain
select
  count(*)
  from
    boarding_pass
 where true
   and precheck is not null
   and (
     false
     or seat = '0B'
     or exists (
     select
       *
       from
	 booking_leg
      where true
	and booking_leg_id = boarding_pass.booking_leg_id
	and exists (
	  select
	    *
	    from
	      flight
	   where true
	     and flight_id = booking_leg.flight_id
	     and aircraft_code = '330')));

explain
SELECT
  json_build_object(
    'aggregate',
    json_build_object('count', COUNT(*))
  ) AS "root"
FROM
  (
    SELECT
      1
    FROM
      (
        SELECT
          *
        FROM
          "postgres_air"."boarding_pass"
        WHERE
          (
            (
              (
                EXISTS (
                  SELECT
                    1
                  FROM
                    "postgres_air"."booking_leg" AS "__be_0_postgres_air_booking_leg"
                  WHERE
                    (
                      (
                        (
                          (
                            "__be_0_postgres_air_booking_leg"."booking_leg_id"
                          ) = ("postgres_air"."boarding_pass"."booking_leg_id")
                        )
                        AND ('true')
                      )
                      AND (
                        ('true')
                        AND (
                          (
                            EXISTS (
                              SELECT
                                1
                              FROM
                                "postgres_air"."flight" AS "__be_1_postgres_air_flight"
                              WHERE
                                (
                                  (
                                    (
                                      ("__be_1_postgres_air_flight"."flight_id") = ("__be_0_postgres_air_booking_leg"."flight_id")
                                    )
                                    AND ('true')
                                  )
                                  AND (
                                    ('true')
                                    AND (
                                      (
                                        (
                                          ("__be_1_postgres_air_flight"."aircraft_code") = (('330') :: bpchar)
                                        )
                                        AND ('true')
                                      )
                                      AND ('true')
                                    )
                                  )
                                )
                            )
                          )
                          AND ('true')
                        )
                      )
                    )
                )
              )
              OR (
                ("postgres_air"."boarding_pass"."seat") = (('0B') :: text)
              )
            )
            AND (
              ("postgres_air"."boarding_pass"."precheck") IS NOT NULL
            )
          )
      ) AS "_root.base"
  ) AS "_root";

explain
SELECT
  json_build_object(
    'aggregate',
    json_build_object('count', COUNT(*))
  ) AS "root"
FROM
  (
    SELECT
      1
    FROM
      (
        SELECT
          *
        FROM
          "postgres_air"."boarding_pass"
        WHERE
          (
            EXISTS (
              SELECT
                1
              FROM
                "postgres_air"."booking_leg" AS "__be_0_postgres_air_booking_leg"
              WHERE
                (
                  (
                    (
                      (
                        "__be_0_postgres_air_booking_leg"."booking_leg_id"
                      ) = ("postgres_air"."boarding_pass"."booking_leg_id")
                    )
                    AND ('true')
                  )
                  AND (
                    ('true')
                    AND (
                      (
                        EXISTS (
                          SELECT
                            1
                          FROM
                            "postgres_air"."flight" AS "__be_1_postgres_air_flight"
                          WHERE
                            (
                              (
                                (
                                  ("__be_1_postgres_air_flight"."flight_id") = ("__be_0_postgres_air_booking_leg"."flight_id")
                                )
                                AND ('true')
                              )
                              AND (
                                ('true')
                                AND (
                                  (
                                    (
                                      ("__be_1_postgres_air_flight"."aircraft_code") = (('330') :: bpchar)
                                    )
                                    AND ('true')
                                  )
                                  AND ('true')
                                )
                              )
                            )
                        )
                      )
                      AND ('true')
                    )
                  )
                )
            )
          )
      ) AS "_root.base"
  ) AS "_root";

explain
SELECT
  json_build_object(
    'aggregate',
    json_build_object('count', COUNT(*))
  ) AS "root"
FROM
  (
    SELECT
      1
    FROM
      (
        SELECT
          *
        FROM
          "postgres_air"."boarding_pass"
        WHERE
          (
            (
              ("postgres_air"."boarding_pass"."precheck") IS NOT NULL
            )
            AND (
              EXISTS (
                SELECT
                  1
                FROM
                  "postgres_air"."booking_leg" AS "__be_0_postgres_air_booking_leg"
                WHERE
                  (
                    (
                      (
                        (
                          "__be_0_postgres_air_booking_leg"."booking_leg_id"
                        ) = ("postgres_air"."boarding_pass"."booking_leg_id")
                      )
                      AND ('true')
                    )
                    AND (
                      ('true')
                      AND (
                        (
                          EXISTS (
                            SELECT
                              1
                            FROM
                              "postgres_air"."flight" AS "__be_1_postgres_air_flight"
                            WHERE
                              (
                                (
                                  (
                                    ("__be_1_postgres_air_flight"."flight_id") = ("__be_0_postgres_air_booking_leg"."flight_id")
                                  )
                                  AND ('true')
                                )
                                AND (
                                  ('true')
                                  AND (
                                    (
                                      (
                                        ("__be_1_postgres_air_flight"."aircraft_code") = (('330') :: bpchar)
                                      )
                                      AND ('true')
                                    )
                                    AND ('true')
                                  )
                                )
                              )
                          )
                        )
                        AND ('true')
                      )
                    )
                  )
              )
            )
          )
      ) AS "_root.base"
  ) AS "_root";
