# Introduction

The maintainers of the [Netflix DGS](https://netflix.github.io/dgs/) library [strongly recommend](https://netflix.github.io/dgs/advanced/dynamic-schemas/) what is commonly-referred to as "schema-first" development of GraphQL servers. So do the maintainers of the core [graphql-java](https://www.graphql-java.com/) library who write in [their book](https://leanpub.com/graphql-java)

<div class="TEXTBOX" id="org9f82318">
<blockquote>
<p>
“Schema-first” refers to the idea that the design of a GraphQL schema
should be done on its own, and should not be generated or inferred
from something else. The schema should not be generated from a
database schema, Java domain classes, nor a REST API.
</p>

<p>
Schemas ought to be schema-first because they should be created in a
deliberate way and not merely generated. Although a GraphQL API will
have much in common with the database schema or REST API being used to
fetch data, the schema should still be deliberately constructed.
</p>

<p>
We strongly believe that this is the only viable approach for any
real-life GraphQL API and we will only focus on this approach. Both
Spring for GraphQL and GraphQL Java only support “schema-first”.
</p>
</blockquote>

</div>

[Other's](https://graphql.org/conf/sessions/118f99976647d953d6554bac33dbf3bf/) [are](https://www.apollographql.com/blog/schema-first-vs-code-only-graphql#conclusion) [not](https://xuorig.medium.com/sdl-or-code-first-graphql-schemas-16e7dbdab2f5) [so](https://2022.stateofgraphql.com/en-US/usage/#code_generation_type) [sure](https://lo-victoria.com/graphql-for-beginners-schema-first-vs-code-first), however, including [the maintainers](https://www.graphql-java.com/documentation/schema) of the *documentation* for graphql-java who write that their library "offers two different ways of defining the schema *[code-first and schema-first]*."

As advocates of a third way of [low-code](https://hasura.io/blog/hasura-for-the-low-code-ecosystem/) and [*data*-first](https://hasura.io/docs/latest/schema/postgres/using-existing-database/) development, we at [Hasura](https://hasura.io/) in this article follow the trail of orthodox schema-first development of a demo GraphQL server with the state-of-the-art [Netflix DGS](https://netflix.github.io/dgs/) library in Java, see where it leads, report on the experience, and compare it to the alternatives.


# Netflix DGS

> Build a full-featured GraphQL server with Java or Kotlin in record time.

[Netflix DGS](https://netflix.github.io/dgs/) is a framework for building GraphQL servers with Java or Kotlin, but what is a "GraphQL server" and what are its features? In our experience a GraphQL server *must* have these features?


## Functional Concerns

Primary software functionality that satisfies use-cases for end-users:

-   **queries:** flexible, general-purpose language for getting data from a data model, part of the GraphQL specification

-   **mutations:** flexible, general-purpose language for changing data in a data model, part of the GraphQL specification

-   **subscriptions:** flexible, general-purpose language for getting real-time or soft real-time data from a data model, part of the GraphQL specification

-   **business logic:** a model for expressing the most common forms of application logic: authorization, validation, and side-effects

-   **integration:** an ability to merge in data and functionality from other services


## Non-Functional Concerns

Secondary software functionality that supports the **functional concerns** with Quality-of-Service (QoS) guarantees for operators:

-   **caching:** configurable time-vs-space trade-off for obtaining better performance for certain classes of operations

-   **security:** protections from attacks and threat vectors

-   **observability:** the emission of diagnostic information such as metrics, logs, and traces to aid in operations and troubleshooting

-   **reliability:** high-quality engineering that promotes efficient and correct operation


# Netflix DGS In-Action

Take those features as our definition of a "GraphQL server" such that they comprise our ideal end-state. That's our goal. How do we get there with Netflix DGS? It's a tall order with many features, so take baby steps. How do we get to get to the goal of having a more modest version of the very first feature?

-   **queries:** ~~flexible, general-purpose~~ language for getting data from a data model, part of the GraphQL specification

How do we implement a Netflix DGS GraphQL server to get *some* data from a data model? To make this more "concrete", take "a data model" to be a database. As one handy reference point, make it a relational database with a SQL API. How do we [get started](https://netflix.github.io/dgs/getting-started/)?


## Get Spring Boot

The Netflix DGS framework is "based on Spring Boot 3.0", so choosing DGS means choosing [Spring Boot](https://spring.io/projects/spring-boot) over alternatives like [Quarkus](https://quarkus.io/) or [Vert.x](https://vertx.io/), two popular alternatives to [Spring](https://spring.io/), the Java application framework foundation for Spring Boot. Absent an existing Spring Boot application to build upon, [create a new Spring Boot application](https://netflix.github.io/dgs/getting-started/#create-a-new-spring-boot-application) with the web-based [spring initializr](https://start.spring.io/). Mature Java and Spring Boot shops likely substitute their own optimized inception process, but the initializr is the best way to fulfill the [promise](https://netflix.github.io/dgs/) of moving fast.

![img](initializr.png "springboot initialzr")


## Get Netflix DGS

Being ["opinionated"](https://spring.io/projects/spring-boot), Spring Boot includes some but not all "batteries." Naturally, one battery we must add either to the Gradle build file or to the Maven [POM](https://maven.apache.org/pom.html) file is [DGS itself](https://netflix.github.io/dgs/getting-started/#adding-the-dgs-framework-dependency).

```xml
<dependencyManagement>
    <dependencies>
      ...
        <dependency>
            <groupId>com.netflix.graphql.dgs</groupId>
            <artifactId>graphql-dgs-platform-dependencies</artifactId>
            <version>4.9.16</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
      ...
    </dependencies>
</dependencyManagement>

<dependencies>
  ...
    <dependency>
        <groupId>com.netflix.graphql.dgs</groupId>
        <artifactId>graphql-dgs-spring-boot-starter</artifactId>
    </dependency>
  ...
</dependencies>
```


## Get a GraphQL Schema

Being ["opinionated"](https://netflix.github.io/dgs/advanced/dynamic-schemas/), the DGS framework "is designed for schema first development" and so it is necessary first to [create a schema](https://netflix.github.io/dgs/getting-started/#creating-a-schema) file. This is for the GraphQL API, but that API is over a data model so the schema essentially is a data model. While it might be tempting to [generate the schema](https://github.com/taviroquai/db2graphql) from the fundamental data model&#x2013;the database&#x2013;choosing DGS means choosing to write a new data model from scratch. Note that if this new GraphQL data model strongly resembles the foundational database data model, this step may feel like repetition. Ignore that feeling.

```graphql
type Query {
    shows(titleFilter: String): [Show]
    secureNone: String
    secureUser: String
    secureAdmin: String
}

type Mutation {
    addReview(review: SubmittedReview): [Review]
    addReviews(reviews: [SubmittedReview]): [Review]
    addArtwork(showId: Int!, upload: Upload!): [Image]! @skipcodegen
}

type Subscription {
    reviewAdded(showId: Int!): Review
}

type Show {
    id: Int
    title: String @uppercase
    releaseYear: Int
    reviews(minScore:Int): [Review]
    artwork: [Image]
}

type Review {
    username: String
    starScore: Int
    submittedDate: DateTime
}

input SubmittedReview {
    showId: Int!
    username: String!
    starScore: Int!
}

type Image {
    url: String
}

scalar DateTime
scalar Upload
directive @skipcodegen on FIELD_DEFINITION
directive @uppercase on FIELD_DEFINITION
```


## Get Data Fetchers

The [DataFetcher](https://netflix.github.io/dgs/datafetching/) is the fundamental abstraction within DGS. It plays the role of a [Controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller#Controller) in a [Model-View-Controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) (MVC) architecture. A DataFetcher is a Java or Kotlin method adorned with the `@DgsQuery` or `@DgsData` annotations, in a class adorned with the `@DgsComponent` annotation. The function of the annotations is to instruct the DGS run-time to treat the method as a [resolver](https://graphql.org/learn/execution/) for a field on a type in the GraphQL schema, to invoke the method when executing queries that involve that field, and to include that field's data as it marshals the response payload for the query. Typically, there will be a DataFetcher for every Type and top-level Query field in the schema. Given that the types and fields were already [defined in the schema](#orgd0455e9), this step may also feel like repetition. Ignore that feeling as well.

```java
package com.example.demo.datafetchers;

import com.example.demo.generated.types.*;
import com.example.demo.services.*;
import com.netflix.graphql.dgs.*;
import java.util.*;
import java.util.stream.*;

@DgsComponent			// Mark this class as DGS Component
public class ShowsDataFetcher {
    private final ShowsService showsService;

    public ShowsDataFetcher(ShowsService showsService) {
        this.showsService = showsService;
    }

    @DgsQuery			// Mark this class as a DGS DataFetcher
    public List<Show> shows(@InputArgument("titleFilter") String titleFilter) {
        if (titleFilter == null) return showsService.shows();
        return showsService.shows().stream().filter(s -> s.getTitle().contains(titleFilter)).collect(Collectors.toList());
    }
}
```


## Get POJOs (Optional)

If the DataFetchers play the role of Controllers in an MVC architecture, typically there will be corresponding components for the [Models](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller#Model). DGS does not require them so they can be regarded as "optional", though the DGS examples have them as do typical Spring applications. They can be Java [Records](https://docs.oracle.com/en/java/javase/17/language/records.html#GUID-6699E26F-4A9B-4393-A08B-1E47D4B2D263) or even Java [Maps](https://docs.oracle.com/javase/8/docs/api/java/util/Map.html) (more on this later), but typically they are [Plain Old Java Objects](https://en.wikipedia.org/wiki/Plain_old_Java_object) (POJOs) and are the fundamental units of the in-memory application-layer data model, which often mirrors the foundational persistent database data model. The one-to-one correspondence between database tables, GraphQL schema types, GraphQL schema top-level Query fields, DGS DataFetchers, and POJOs may feel like yet more repetition. Continue to ignore these feelings.

```java
public class Show {
    private final UUID id;
    private final String title;
    private final Integer releaseYear;

    public Show(UUID id, String title, Integer releaseYear) {
        this.id = id;
        this.title = title;
        this.releaseYear = releaseYear;
    }

    public UUID getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public Integer getReleaseYear() {
        return releaseYear;
    }
}  
```


## Get Real Data (Not Optional)

The road laid out by the DGS [Getting Started](https://netflix.github.io/dgs/getting-started/) guide unfortunately turns to gravel at this point in the journey, with its [examples](https://github.com/Netflix/dgs-examples-java/blob/d25df806c587402d3d8ac3fa93385f0a6fe34276/src/main/java/com/example/demo/services/ShowsServiceImpl.java) merely returning hard-coded in-memory data. This is not an option for a real application whose data is persisted in a relational database with a SQL API, as was stipulated above.

Of course, the Model and Controller layers of a multi-layered MVC architecture being independent of the View layer, they need not be GraphQL or DGS specific and so it is appropriate that the opinionated DGS guide withhold opinions on how exactly to map data between model objects and a relational database. Without that luxury real applications typically will use Object Relational Mapping ([ORM](https://blog.codinghorror.com/object-relational-mapping-is-the-vietnam-of-computer-science/)) frameworks like [Hibernate](https://hibernate.org/) or [JOOQ](https://www.jooq.org/), but those tools have *their own* "Getting Started" guides:

-   [Getting Started with Hibernate](https://docs.jboss.org/hibernate/orm/6.4/quickstart/html_single/)
-   [Getting Started with JOOQ](https://www.jooq.org/doc/3.19/manual/getting-started/)

Consider choosing Hibernate if its greater popularity, broader industry support, larger volume of learning resources, and slightly greater integration with the Spring ecosystem are important. In that case, here are some of the remaining steps.


## Get Hibernate

As it is time to add another "battery" to the application, like with Spring and DGS, Hibernate is added either to the Gradle build file or to the Maven POM file.

```xml
<dependencyManagement>
  <dependencies>
    ...
    <dependency>
      <groupId>org.hibernate.orm</groupId>
      <artifactId>hibernate-platform</artifactId>
      <version>6.4.4.Final</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
    ...
  </dependencies>
</dependencyManagement>

<dependencies>
  ...
  <dependency>
    <groupId>org.hibernate.orm</groupId>
    <artifactId>hibernate-core</artifactId>
  </dependency>
  ...
</dependencies>
```


## Get Access to the Database

Naturally, the application needs access to the database, which can be [configured](https://docs.jboss.org/hibernate/orm/6.4/quickstart/html_single/#hibernate-gsg-tutorial-annotations-config) into Hibernate via a simple `hibernate.properties` file in the `${project.basedir}/src/main/resources` directory.

```text
hibernate.connection.url=<JDBC url>
hibernate.connection.username=<DB role name>
hibernate.connection.password=<DB credential secret>
```


## Get Mappings between POJOs and Tables

Hibernate can [map](https://docs.jboss.org/hibernate/orm/6.4/quickstart/html_single/#hibernate-gsg-tutorial-annotations-entity) the tables to POJOs&#x2013;which again are the Models in the MVC architecture&#x2013;to database tables (or views) by annotating those classes with `@Entity`, `@Table`, `@Id`, and other annotations that the Hibernate framework defines. The function of these annotations is to instruct the Hibernate run-time to treat the classes as targets for [fetching](https://docs.jboss.org/hibernate/orm/6.4/userguide/html_single/Hibernate_User_Guide.html#fetching) corresponding data from the database (as well as [flushing](https://docs.jboss.org/hibernate/orm/6.4/userguide/html_single/Hibernate_User_Guide.html#flushing) changes back to the database).

```java
@Entity				// Mark this as a persistent Entity
@Table(name = "shows")		// Name its table if different
public class Show {
    @Id				// Mark the field as a primary key
    @GeneratedValue		// Specify that the db generates this
    private final UUID id;
    private final String title;
    private final Integer releaseYear;

    public Show(UUID id, String title, Integer releaseYear) {
        this.id = id;
        this.title = title;
        this.releaseYear = releaseYear;
    }

    public UUID getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public Integer getReleaseYear() {
        return releaseYear;
    }
}  
```

Hibernate can also [map](https://docs.jboss.org/hibernate/orm/6.4/userguide/html_single/Hibernate_User_Guide.html#dynamic-model) the tables Java [Map](https://docs.oracle.com/javase/8/docs/api/java/util/Map.html) instances ([hash tables](https://en.wikipedia.org/wiki/Hash_table)) in lieu of POJOs, as mentioned above. This is done via [dynamic mapping](https://docs.jboss.org/hibernate/orm/6.4/userguide/html_single/Hibernate_User_Guide.html#mapping-model-dynamic) in what are called [mapping files](https://docs.jboss.org/hibernate/orm/3.6/quickstart/en-US/html/hibernate-gsg-tutorial-basic.html#hibernate-gsg-tutorial-basic-mapping). Typically there will be an XML mapping file for every Model in the application, with the naming convention `modelname.hbm.xml`, in the `${project.basedir}/main/resources` directory. This substitutes the labor of writing Java POJO files for the Models and annotating them with Hibernate annotations, with the labor of writing XML mapping files for the Models and embedding the equivalent metadata there. It may feel like little was gained in the bargain, but ignoring those feelings should be second nature by now.

```xml
<!DOCTYPE hibernate-mapping PUBLIC
    "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
    "http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
<hibernate-mapping>
    <class entity-name="Show">
      <id name="id" column="id" length="32" type="string"/> <!--no native UUID type in Hibernate mapping-->
      <property name="title" not-null="true" length="50" type="string"/>
      <property name="releaseYear" not-null="true" length="50" type="integer"/>
    </class>
</hibernate-mapping>
```


## Get Fetching

As described above, the DGS demo [example](https://raw.githubusercontent.com/Netflix/dgs-examples-java/d25df806c587402d3d8ac3fa93385f0a6fe34276/src/main/java/com/example/demo/services/ShowsServiceImpl.java) Controller class fetches hard-coded in-memory data. To fetch data from the database in a real application, replace this implementation with one that establishes the crucial link between the three key frameworks: DGS, Spring, and Hibernate.

```java
package com.example.demo.services;

import com.example.demo.generated.types.*;
import java.util.*;
import org.hibernate.cfg.*;
import org.springframework.stereotype.*;
import static org.hibernate.cfg.AvailableSettings.*;

@Service
public class ShowsServiceImpl implements ShowsService {
    private StandardServiceRegistry registry;
    private SessionFactory sessionFactory;

    public ShowsServiceImpl() {
        try {
            this.registry = new StandardServiceRegistryBuilder().build();
            this.sessionFactory = 
                new MetadataSources(this.registry)             
                .addAnnotatedClass(Show.class) // Add every Model class to the Hibernate metadata
                .buildMetadata()                  
                .buildSessionFactory();           
        }
        catch (Exception e) {
            StandardServiceRegistryBuilder.destroy(this.registry);
        }
    }

    @Override
    public List<Show> shows() {
        List<Show> shows = new ArrayList<>();
        sessionFactory.inTransaction(session -> {
                session.createSelectionQuery("from Show", Show.class) // 'Show' is mentioned twice
                    .getResultList()   
                    .forEach(show -> shows.add(show));
            });
        return shows;
    }
}
```


## Get Iterating

At this point there already is a fair amount of code and other software artifacts

-   GraphQL schema files (`*.sdl`)
-   Project build files (`build.gradle` or `pom.xml`)
-   Configuration files (`hibernate.properties`)
-   DGS DataFetcher files (`*.java`)
-   POJO files (`*.java`)
-   Additional Controller files (`*.java`)

along with packages, symbols, and annotations from three frameworks

-   DGS
-   Spring
-   Hibernate

and yet it would be a stroke of luck if it even compiled let alone functioned properly at first. In order to iterate on the project rapidly and with confidence until it builds and functions properly, repeatable unit tests-as-code are needed. Fortunately, the spring initialzr will already have added the [JUnit](https://junit.org/junit4/) and [SpringBoot](https://docs.spring.io/spring-boot/docs/2.0.4.RELEASE/reference/html/boot-features-testing.html) testing components to the project build files. To use mock data with a framework such as [mockito](https://site.mockito.org/), however, its components must be added to the project build file.

```xml
<dependencies>
  ...
  <dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-inline</artifactId>
    <version>{mockitoversion}</version>
  </dependency>
  <dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-junit-jupiter</artifactId>
    <version>{mockitoversion}</version>
    <scope>test</scope>
  </dependency>
  ...
</dependencies>
```

All that is needed now is to create unit test class files for every DataFetcher, taking care to set up mock data as needed.

```java
import com.netflix.graphql.dgs.*;
import com.netflix.graphql.dgs.autoconfig.*;
import java.util.*;
import org.junit.jupiter.api.*;
import org.mockito.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.boot.test.context.*;
import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(classes = {DgsAutoConfiguration.class, ShowsDataFetcher.class})
public class ShowsDataFetcherTests {
    @Autowired
    DgsQueryExecutor dgsQueryExecutor;

    @MockBean
    ShowsService showsService;

    @BeforeEach
    public void before() {
        Mockito.when(showsService.shows()).thenAnswer(invocation -> List.of(new Show("mock title", 2020)));
    }

    @Test
    public void showsWithQueryApi() {
        GraphQLQueryRequest graphQLQueryRequest = new GraphQLQueryRequest(
                new ShowsGraphQLQuery.Builder().build(),
                new ShowsProjectionRoot().title()
        );
        List<String> titles = dgsQueryExecutor.executeAndExtractJsonPath(graphQLQueryRequest.serialize(), "data.shows[*].title");
        assertThat(titles).containsExactly("mock title");
    }
}
```


## Get to a Milestone

After iterating on the implementation by writing test cases in tandem, eventually a milestone is reached. There is a functioning Netflix DGS GraphQL server to get *some* data from a foundational data model in a relational database. Building on this success, take stock of what has been accomplished so far so that planning can begin for what still needs to be done.

Recall our definition of a "GraphQL Server" as one which has the [Functional](#orgda4be4c) and [Non-Functional](#org7ba8aa4) concerns listed above, and note which features have and have not yet been implemented.

-   [X] queries
-   [ ] flexible, general-purpose queries
-   [ ] mutations
-   [ ] subscriptions
-   [ ] business logic
-   [ ] integration
-   [ ] caching
-   [ ] security
-   [ ] reliability & error handling

Clearly, there still is a long way to go. Granted, the providers of frameworks like [Spring](https://spring.io/projects/spring-framework), [Hibernate](https://hibernate.org/), and [Netflix DGS](https://netflix.github.io/dgs/) *have* thought of this. A benefit of frameworks like these is that they *are frameworks*: they organize the code, they furnish mental models for reasoning about it, they offer guidance in the form of opinions derived from experience, *and* they provide "lighted pathways" for adding these other features and fulfilling the promise of a "full-featured GraphQL server."

For instance, some of the flexibility we seek can be recovered within Hibernate by switching to [JPA entity graph](https://docs.jboss.org/hibernate/orm/6.4/userguide/html_single/Hibernate_User_Guide.html#fetching-strategies-dynamic-fetching-entity-graph) fetching. Alternatively, instead of fetching the data "directly" through Hibernate, the DGS DataFetchers could compose [Hibernate Query Language](https://docs.jboss.org/hibernate/orm/6.4/userguide/html_single/Hibernate_User_Guide.html#query-language) (HQL) queries, which are then executed by Hibernate in order to retrieve the data. This bears a strong resemblance to compiling SQL (perhaps even from GraphQL), but it has the virtue of being abstracted away from the details of the underlying database SQL dialect.

Likewise, caching can be configured in [Hibernate](https://docs.jboss.org/hibernate/orm/6.4/userguide/html_single/Hibernate_User_Guide.html#caching) (or in [JOOQ](https://www.jooq.org/doc/3.19/manual/coming-from-jpa/from-jpa-caches/) if that is the ORM). It can also be configured in [Spring Boot](https://docs.spring.io/spring-boot/docs/2.1.6.RELEASE/reference/html/boot-features-caching.html). Other features such as security can be added into Spring with tools like [Bucket4j](https://www.baeldung.com/spring-bucket4j). As for business logic, the code itself (Java or Kotlin) in the DataFetchers, the Controllers, and the Model POJOs provides obvious sites for installing business logic. Naturally, Spring has affordances to help with some of this, such as for [authorization](https://docs.spring.io/spring-security/reference/servlet/authorization/index.html), data [validation](https://docs.spring.io/spring-framework/docs/4.1.x/spring-framework-reference/html/validation.html).

Consequently, a "full-featured GraphQL server" probably *can* be built in Java or Kotlin by cobbling together Netflix DGS, Spring Boot, an ORM, and other frameworks and libraries. But, several questions leap out.

-   Can this be accomplished *"in record time"*?
-   *Should* a "full-featured GraphQL server" be attempted this way?
-   *Is there* a better way?


## Get Back to Basics

Remembering that the goal never was to write Java or Kotlin code, juggle frameworks, endure relentless context switching, or generate boilerplate. The goal was

> Build a full-featured GraphQL server ~~with Java or Kotlin in record time~~

Getting back to basics, it is possible to answer the third question above, "*Is there* a better way?" There is.


# GraphQL

What is GraphQL? One way to answer that is by listing its features. *Some* of those features are:

-   GraphQL is a flexible, general-purpose query language over types.
-   Types have fields.
-   Fields can relate to other Types.

If that sounds familiar, it should, because other ways of organizing data have these same features. SQL is one of them. It is not the *only* one, but it is a very common one. On the other hand, GraphQL has several secondary, related features.

-   GraphQL has very simple semantics.
-   GraphQL has a highly-regular machine-readable input format.
-   GraphQL has a highly-regular machine-readable output format.

If SQL is more powerful than GraphQL, GraphQL is more uniform and is easier to work with than SQL. They *seem* like a match made in Heaven and this raises some obvious questions.

-   Can GraphQL be compiled to SQL (and other query languages)?
-   *Should* GraphQL be compiled to SQL?
-   What would be the trade-offs involved?


## GraphQL to SQL:  Compilers over Resolvers

The answer to the first question is a categorical "yes." [Hasura](https://hasura.io/) does it. [PostGraphile](https://www.graphile.org/postgraphile/) does it. [Prisma](https://www.prisma.io/) does it. [supabase](https://supabase.com/blog/pg-graphql) does it. [PostgREST](https://postgrest.org/) even does something similar, albeit not for GraphQL.

The answer to the second question surely must depend on the answers to the third question.

So what are the trade-offs of adopting a compiler approach over a resolver approach? First, what are some of the benefits?

| Benefit    | Comment                                                                         |
| Fast       | Truly deliver in "record time".                                                 |
| Uniform    | Solve the data-fetching problem once and for all.                               |
| Features   | Build functional and non-functional concerns around that core.                  |
| Efficiency | Avoid the [N+1 problem](https://netflix.github.io/dgs/data-loaders/) naturally. |
| Leverage   | Exploit all of the power of the underlying database.                            |
| Operate    | Easily deploy, monitor, and maintain the application.                           |

Second, what are some of the drawbacks, but also how can they be mitigated?

| Drawback       | Comment                                             | Mitigation Strategy                                                                                                                                                                                                                  |
| Coupling       | API tied to Data Model                              | Database views other forms of [indirection](https://hasura.io/docs/latest/schema/postgres/native-queries/)                                                                                                                           |
| Business Logic | Code is a natural place to implement business logic | Database views, functions, and [other](https://hasura.io/docs/latest/actions/overview/) [escape](https://hasura.io/docs/latest/event-triggers/overview/) [hatches](https://hasura.io/docs/latest/schema/postgres/input-validations/) |
| Heterodoxy     | difficulty of defying conventional wisdom           | Truly "build a full-featured GraphQL server" in record time.                                                                                                                                                                         |


# Summary

The *current* conventional wisdom in the GraphQL community is to adopt a schema-first approach, hand-writing resolvers over in-memory data models in code, typically with Java, Kotlin, Python, Ruby, or Javascript. Stacked against this wisdom is the experience of lengthy development cycles, shallow APIs, superficial implementations, tight coupling to the data model, brittleness and unreliability, and operational inefficiency. This is arguably a very naive approach.

As the *current* conventional wisdom relaxes to allow for a more diverse set of strategies for building full-featured GraphQL servers, a more sophisticated data-first approach *will* adopted. It has to. The volume, velocity, and variety of data are only growing. It is not uncommon for enterprises to have hundreds of data sources and thousands of tables. Manually curating GraphQL schema which nominally are independent of those elements but practically are mirrors of them, and then manually repeating that work in multiple layers of the architecture, manually writing code to marshal data between representations, while neglecting non-functional concerns like security and observability is simply a non-starter in that setting.

We don't build database servers from scratch every time we enter a business domain that demands solving problems using data. Instead, we reach for full-featured general-purpose purpose-built database products and adapt them to our needs in order to solve these problems quickly and confidently so that we can move onto the next problems.

Likewise we shouldn't build API servers from scratch every time we enter a business domain that demands solving problems using APIs. Instead, we should reach for a [full-featured general-purpose purpose-built API product](https://hasura.io/) and adapt it to our needs in order to solve these problems quickly and confidently, and get on with our lives.