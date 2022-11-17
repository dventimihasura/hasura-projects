```shell
pgbench -h localhost -p 5433 -U postgres -d postgres -f scratch.sql -T 60 2>/dev/null 
Password: 
pgbench (14.5 (Ubuntu 14.5-0ubuntu0.22.04.1))
transaction type: scratch.sql
scaling factor: 1
query mode: simple
number of clients: 1
number of threads: 1
duration: 60 s
number of transactions actually processed: 17972
latency average = 3.338 ms
initial connection time = 6.343 ms
tps = 299.553418 (without initial connection time)

```


```shell
ab -t 60 -p scratch.json -T application/json -H 'x-hasura-admin-secret: ijawqhgVtsykcSJxCRYpAEYnmM475uGbATuyyG5kGHt83M8BUMNhkPH2IH6o4WL9' -H 'x-hasura-user-id: 530df8ec-8fa4-4a9a-8c18-2eb6715d2e08' http://localhost:8080/v1/graphql
This is ApacheBench, Version 2.3 <$Revision: 1879490 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient)
Completed 5000 requests
Completed 10000 requests
Finished 13517 requests


Server Software:        Warp/3.3.19
Server Hostname:        localhost
Server Port:            8080

Document Path:          /v1/graphql
Document Length:        77 bytes

Concurrency Level:      1
Time taken for tests:   60.000 seconds
Complete requests:      13517
Failed requests:        0
Total transferred:      3419801 bytes
Total body sent:        7758758
HTML transferred:       1040809 bytes
Requests per second:    225.28 [#/sec] (mean)
Time per request:       4.439 [ms] (mean)
Time per request:       4.439 [ms] (mean, across all concurrent requests)
Transfer rate:          55.66 [Kbytes/sec] received
                        126.28 kb/s sent
                        181.94 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:     4    4   0.7      4      28
Waiting:        4    4   0.7      4      28
Total:          4    4   0.7      4      28

Percentage of the requests served within a certain time (ms)
  50%      4
  66%      4
  75%      4
  80%      5
  90%      5
  95%      6
  98%      6
  99%      7
 100%     28 (longest request)
```
