const Hapi = require('@hapi/hapi');
const HapiPostgresConnection = require('hapi-postgres-connection');

const init = async () =>{ 
    const server = new Hapi.Server({
        port: 3000,
        host: 'localhost'
    })
    await server.register({
        plugin: HapiPostgresConnection
    });
    server.route({
        method: 'GET',
        path: '/restaurants/statistics',
        handler: async (request, h) => {
            let lng= request.query.longitude;
            let lat= request.query.latitude;
            let radius= request.query.radius;
            let fun= `SELECT * FROM area('${lng}', '${lat}', ${radius})`
            try{
                const result = await request.pg.client.query(fun);
                console.log(result);
                return h.response(result.rows[0]);
            }catch(err){
                console.log(err);
            }
        }
    })

    await server.start();
    console.log(`Server running on ${server.info.uri}`);
};


init();