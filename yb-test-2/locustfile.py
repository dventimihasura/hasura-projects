import time
from locust import HttpUser, task, between

class QuickstartUser(HttpUser):
    # @task
    # def healthcheck(self):
    #     self.client.get("/healthz")

    @task
    def product(self):
        with self.client.post("/v1/graphql",
                         json={"query": '''
query MyQuery {
  product(limit: 1) {
    id
  }
}
'''},
                         catch_response=True) as response:
            if response.elapsed.total_seconds() > 2:
                response.failure("Request took too long")

#     @task
#     def product(self):
#         body = '''
# query MyQuery {
#   account(limit: 10) {
#     id
#     name
#   }
# }
# '''
#         # self.client.post("/v1/graphql",
#         #                  json={"query": body},
#         #                  catch_response=True) as response:
#         with self.client.post("/v1/graphql",
#                               json={"query": body},
#                               catch_response=True) as response:
#             if response.elapsed.total_seconds() > 2:
#                 response.failure("Request took too long")


    
    
