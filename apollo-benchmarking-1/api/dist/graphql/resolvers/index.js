export const resolvers = {
    Query: {
        events(_, __, { dataSources }) {
            return dataSources.events.getEvents();
        },
        eventsBatched(_, __, { dataSources }) {
            return dataSources.events.getEvents();
        },
    },
    Event: {
        attributes({ id }, _, { dataSources }) {
            return dataSources.events.getEventAttributes(id);
        },
    },
    EventBatched: {
        attributes({ id }, _, { dataSources }) {
            return dataSources.events.getEventsAttributesBatched.load(id);
        },
    },
};
