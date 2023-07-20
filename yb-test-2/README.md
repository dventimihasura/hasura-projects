# Abstract #

Hasura Load Testing with YugaByte

# What #

This project sets up a very basic 4-node Yugabyte database cluster in
a local environment and configures it with Hasura and a simple
illustrative data model for load testing purposes.

# Why #

We wish to benchmark Hasura performance on YugaByte.

# How #

Yugabyte has a variety of provisioning choices (local install, Docker
container, cloud-managed).  This project uses Docker containers
orchestrated with Docker Compose.  It has a `docker-compose.yaml` file
that launches these services:

1. Yugabyte master node x 1
2. Yugabyte worker ("tablet") nodes x 3
3. Hasura graphql-engine node

# Steps #

1. Clone this repository.

```bash
git clone https://github.com/dventimihasura/hasura-projects
```

2. Change to the `yb-test-2` sub-directory.

```bash
cd yb-test-2
```

3. Launch the services using Docker Compose.
   
```bash
docker-compose up -d
```

4. Run a Locust load test.

```bash
docker run \
  -v ./:/mnt/locust \
  --network yb-test-2_default \
  --ulimit nofile=15000:15000 \
  locustio/locust:2.15.1 \
  --headless \
  --only-summary \
  -t 60s \
  -f /mnt/locust/locustfile.py \
  -H http://graphql-engine:8080 \
  -u 10 \
  FastPerfTest
```

# Examples #

```bash
lscpu
```

```bash
Architecture:            x86_64
  CPU op-mode(s):        32-bit, 64-bit
  Address sizes:         39 bits physical, 48 bits virtual
  Byte Order:            Little Endian
CPU(s):                  12
  On-line CPU(s) list:   0-11
Vendor ID:               GenuineIntel
  Model name:            Intel(R) Xeon(R) W-11855M CPU @ 3.20GHz
    CPU family:          6
    Model:               141
    Thread(s) per core:  2
    Core(s) per socket:  6
    Socket(s):           1
    Stepping:            1
    CPU max MHz:         4900.0000
    CPU min MHz:         800.0000
    BogoMIPS:            6374.40
    Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall n
                         x pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf tsc_known_freq pn
                         i pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadli
                         ne_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault epb cat_l2 invpcid_single cdp_l2 ssbd ibrs ibpb stibp ib
                         rs_enhanced tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid rdt_a avx512f avx51
                         2dq rdseed adx smap avx512ifma clflushopt clwb intel_pt avx512cd sha_ni avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves split_lo
                         ck_detect dtherm ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp hwp_pkg_req avx512vbmi umip pku ospke avx512_vbmi2 gfni v
                         aes vpclmulqdq avx512_vnni avx512_bitalg tme avx512_vpopcntdq rdpid movdiri movdir64b fsrm avx512_vp2intersect md_clear ibt flush
                         _l1d arch_capabilities
Virtualization features: 
  Virtualization:        VT-x
Caches (sum of all):     
  L1d:                   288 KiB (6 instances)
  L1i:                   192 KiB (6 instances)
  L2:                    7.5 MiB (6 instances)
  L3:                    18 MiB (1 instance)
NUMA:                    
  NUMA node(s):          1
  NUMA node0 CPU(s):     0-11
Vulnerabilities:         
  Itlb multihit:         Not affected
  L1tf:                  Not affected
  Mds:                   Not affected
  Meltdown:              Not affected
  Mmio stale data:       Not affected
  Retbleed:              Not affected
  Spec store bypass:     Mitigation; Speculative Store Bypass disabled via prctl
  Spectre v1:            Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  Spectre v2:            Mitigation; Enhanced IBRS, IBPB conditional, RSB filling, PBRSB-eIBRS SW sequence
  Srbds:                 Not affected
  Tsx async abort:       Not affected
```

```bash
docker run \
  -v ./:/mnt/locust \
  --network yb-test-2_default \
  --ulimit nofile=15000:15000 \
  locustio/locust:2.15.1 \
  --headless \
  --only-summary \
  -t 60s \
  -f /mnt/locust/locustfile.py \
  -H http://graphql-engine:8080 \
  -u 10 \
  FastPerfTest
```

```bash
[2023-07-20 16:43:48,806] e6b6a6fecfb3/INFO/locust.main: Run time limit set to 60 seconds
[2023-07-20 16:43:48,806] e6b6a6fecfb3/INFO/locust.main: Starting Locust 2.15.1
[2023-07-20 16:43:48,807] e6b6a6fecfb3/INFO/locust.runners: Ramping to 10 users at a rate of 1.00 per second
[2023-07-20 16:43:57,809] e6b6a6fecfb3/INFO/locust.runners: All users spawned: {"FastPerfTest": 10} (10 total users)
[2023-07-20 16:43:58,808] e6b6a6fecfb3/WARNING/root: CPU usage above 90%! This may constrain your throughput and may even give inconsistent response time measurements! See https://docs.locust.io/en/stable/running-distributed.html for how to distribute the load over multiple CPU cores or machines
[2023-07-20 16:44:48,617] e6b6a6fecfb3/INFO/locust.main: --run-time limit reached, shutting down
[2023-07-20 16:44:48,620] e6b6a6fecfb3/WARNING/locust.runners: CPU usage was too high at some point during the test! See https://docs.locust.io/en/stable/running-distributed.html for how to distribute the load over multiple CPU cores or machines
[2023-07-20 16:44:48,620] e6b6a6fecfb3/INFO/locust.main: Shutting down (exit code 0)
Type     Name                                                                          # reqs      # fails |    Avg     Min     Max    Med |   req/s  failures/s
--------|----------------------------------------------------------------------------|-------|-------------|-------|-------|-------|-------|--------|-----------
POST     /api/rest/perftest                                                            220290     0(0.00%) |      0       0      11      1 | 3683.06        0.00
GET      /healthz                                                                      220654     0(0.00%) |      0       0       8      0 | 3689.15        0.00
--------|----------------------------------------------------------------------------|-------|-------------|-------|-------|-------|-------|--------|-----------
         Aggregated                                                                    440944     0(0.00%) |      0       0      11      0 | 7372.21        0.00

Response time percentiles (approximated)
Type     Name                                                                                  50%    66%    75%    80%    90%    95%    98%    99%  99.9% 99.99%   100% # reqs
--------|--------------------------------------------------------------------------------|--------|------|------|------|------|------|------|------|------|------|------|------
POST     /api/rest/perftest                                                                      1      1      1      1      1      1      1      2      2      5     11 220290
GET      /healthz                                                                                0      0      1      1      1      1      1      1      2      3      8 220654
--------|--------------------------------------------------------------------------------|--------|------|------|------|------|------|------|------|------|------|------|------
         Aggregated                                                                              0      1      1      1      1      1      1      1      2      4     11 440944
```
