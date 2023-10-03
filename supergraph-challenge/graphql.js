import http from "k6/http";
import { check, fail, sleep } from "k6";

export const options = {
  vus: 100,
  duration: '60s',
};

export default function() {
  let query = `
query {
 threads(limit:1) {
   id
   posts(limit:10,orderBy:CREATED_DESC){
     id
   }
 } 
}
`;
  let graphqlEndpoint = `http://localhost:8080/graphql`;

  let headers = {
    "Content-Type": "application/json"
  };

  let res = http.post(graphqlEndpoint,
    JSON.stringify({ query: query }),
    {headers: headers}
  );

  if (
    check(res, {
      'graphql errors': (res) => res.json().data.errors !== undefined,
    })
  ) {
    fail('graphql response error');
  }
}
