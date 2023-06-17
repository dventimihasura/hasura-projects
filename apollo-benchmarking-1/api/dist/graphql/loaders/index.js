import { BatchedSQLDataSource, } from "@nic-jennings/sql-datasource";
export class EventsLoader extends BatchedSQLDataSource {
    constructor(config) {
        super(config);
        this.getEventsAttributesBatched = this.db.query
            .select("*")
            .from({ ea: "event_attribute" })
            .batch(async (query, keys) => {
            const result = await query.whereIn("ea.event_id", keys);
            return keys.map((x) => result?.filter((y) => y.event_id === x));
        });
    }
    getEvents() {
        return this.db.query.select("*").from("event");
    }
    getEventAttributes(id) {
        return this.db.query
            .select("*")
            .from({ ea: "event_attribute" })
            .where("event_id", id);
    }
}
