db = db.getSiblingDB('sample_db');

db.createCollection('sample_collection');

db.sample_collection.insertMany([
    {
	org: 'helpdev',
	filter: 'EVENT_A',
	addrs: 'http://rest_client_1:8080/wh'
    },
    {
	org: 'helpdev',
	filter: 'EVENT_B',
	addrs: 'http://rest_client_2:8081/wh'
    },
    {
	org: 'github',
	filter: 'EVENT_C',
	addrs: 'http://rest_client_3:8082/wh'
    }
]);

db.createCollection('approvals');

db.approvals.insertMany([
    {
	design_id: 1,
	approved: true
    },
    {
	design_id: 2,
	approved: true
    },
    {
	design_id: 3,
	approved: true
    },
    {
	design_id: 4,
	approved: true
    },
    {
	design_id: 5,
	approved: true
    },
    {
	design_id: 6,
	approved: true
    }
]);
