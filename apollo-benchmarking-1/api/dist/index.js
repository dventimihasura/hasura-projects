import { ApolloServer } from "@apollo/server";
import { EventsLoader } from "./graphql/loaders";
import { resolvers } from "./graphql/resolvers";
import { startStandaloneServer } from "@apollo/server/standalone";
import { typeDefs } from "./graphql/schema";
const { HOST } = process.env;
const knexConfig = {
    client: "pg",
    connection: "postgresql://postgres:postgres@postgres/postgres",
};
const server = new ApolloServer({
    typeDefs,
    resolvers,
});
startStandaloneServer(server, {
    context: async () => {
        const { cache } = server;
        return {
            dataSources: {
                events: new EventsLoader({ knexConfig, cache }),
            },
        };
    },
}).then(({ url }) => console.log(`🚀 Server ready at ${url}`));
