package io.hasura.netflixdgsjava1;

import com.netflix.graphql.dgs.*;
import graphql.schema.*;
import graphql.schema.idl.*;
import java.util.*;

@DgsComponent
public class DynamicDataFetcher {
    @DgsCodeRegistry
    public GraphQLCodeRegistry.Builder registry(GraphQLCodeRegistry.Builder codeRegistryBuilder, TypeDefinitionRegistry registry) {
	DataFetcher<Integer> df = (dfe) -> new Random().nextInt();
	FieldCoordinates coordinates = FieldCoordinates.coordinates("Query", "randomNumber");
        return codeRegistryBuilder.dataFetcher(coordinates, df);
    }
}
