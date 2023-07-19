import time
from locust import HttpUser, task, between

class PerfTest(HttpUser):
    # @task
    # def nginx(self):
    #     self.client.get(
    #         "/")

    @task
    def hasura_healthcheck(self):
        self.client.get(
            "/healthz")

    # @task
    # def hasura_rest(self):
    #     with self.client.post(
    #             "/api/rest/perftest",
    #             catch_response=True, verify=False, headers={"x-hasura-admin-secret": "fake-one"}) as response:
    #         try:
    #             if response.elapsed.total_seconds() > 1:
    #                 response.failure(f"[{dt.now()}, x-requiest-id is {response.headers['x-request-id']}, status_code: {response.status_code}] Response took too long: {response.elapsed.total_seconds()}")
    #             elif response.status_code != 200:
    #                 response.failure(f"Bad status code {response.status_code}")
    #         except Exception as e:
    #             response.failure("{e}")

    
    
