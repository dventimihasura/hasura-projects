[Demo](https://drive.google.com/file/d/1R5j8xA8fI32_Y7Nqk1YiqKAYFEmZ_QcW/view?usp=sharing)

# Abstract #

This is a Proof-Of-Concept (POC) demonstrating how to use multiple
instances of Hasura along with its support for Remote Schema to get
around some limitations on custom Actions.

# What #

This POC creates an instance of Hasura that solely accesses the
Algolia search service using custom Actions, then creates another
instance of Hasura to consume the first as a Remote Schema, and then
join that to data pulled from its database.

# Why #

Hasura custom Actions are used to query remote web services like the
Algolia search service, and that works pretty well.  Actions can have
relationships established to other elements in the API.
Unfortunately, that does not work all that well.  Custom Action
relationships have limitations in joining to database data.  That's
why we're working around those limitations by taking advantage of the
superior relationship support in Hasura Remote Schema.

# How #

There are two Hasura instances:  `search` and `graphql`.  The `search`
service uses custom Actions to access the Algolia search service and
expose it as a GraphQL API.  In this demo, we are setting up a toy
online retail grocery data model, and so the data we are searching
with Algolia are grocery products.  I.e., we are searching for grocery
products by name.

To get the data *into* Algolia we use Hasura custom Events in the
`graphql` instance.  I.e., as products are added to that service's
`product` table, custom events make sure to insert the relevant data
(mainly, the `id` and `name`) into Algolia to be search.  Moreover, we
take care that the `id` which becomes the Algolia `objectId` is *the
same* as the `product.id` primary key.  That is, we take care that
this is a related field.  That way we can set up a join relationship
on that field.

Where *set up* that join relationship is in Hasura Remote Schema
relationships.  Again, Remote Schema relationships are more robust
than custom Action relationships and support the kind of join that we
need to perform in order to merge the Algolia search results with the
actual `product` data to which they relate.

# Steps #

1. Clone this repository.

```shell
git clone https://github.com/dventimihasura/hasura-projects
```

2. Change to the `algolia-search-1` project sub-directory.

```shell
cd algolia-search-1
```

3. Go to https://www.algolia.com/ and create an account and obtain
   these data.
   
   - `ALGOLIA_APPLICATION_ID`
   - `ALGOLIA_INDEX_NAME`
   - `ALGOLIA_API_KEY`
   
4. Create a `.env` file in the root `algolia-search-1` project
   sub-directory with these data as name=value pairs.  **DO NOT ADD
   THIS FILE TO SOURCE CONTROL**

5. Use Docker Compose to launch the services.

```shell
docker-compose up -d
```

6. Change to the `search` directory and initialize its corresponding
   `search` Hasura instance.
   
```shell
cd search
hasura metadata apply
hasura migrate apply --database-name default
hasura metadata reload
hasura seed apply --database-name default
```

7. Change to the `graphql` directory and initialize its corresponding
   `graphql` Hasura instance.
   
   
```shell
cd graphql
hasura metadata apply
hasura migrate apply --database-name default
hasura metadata reload
hasura seed apply --database-name default
```

8. Access the `graphql` instance Console via http://localhost:8080 and
   try out GraphQL queries like the following.
   
   
```graphql
query MyQuery {
  search_remote(query: "apple") {
    nbHits
    nbPages
    hits {
      name
      objectID
      product {
        id
        name
        price
        order_details {
          units
          order {
            account {
              name
            }
          }
        }
      }
    }
  }
}
```

<!--  LocalWords:  objectId algolia cd env nbHits nbPages objectID
 -->
