import time
from locust import HttpUser, FastHttpUser, task, between

class PerfTest(HttpUser):
    @task
    def hasura_healthcheck(self):
        self.client.get(
            "/healthz")
    @task
    def hasura_rest(self):
        response = self.client.post(
            "/api/rest/perftest")

class FastPerfTest(FastHttpUser):
    @task
    def hasura_healthcheck(self):
        self.client.get(
            "/healthz")
    @task
    def hasura_rest(self):
        response = self.client.post(
            "/api/rest/perftest")
