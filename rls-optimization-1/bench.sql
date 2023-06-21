-- -*- sql-product: postgres; -*-

set role "User";

set rls.artistID = '116';

explain analyze select * from "Track";

explain analyze select * from "Track" natural join "Album";

reset role;
