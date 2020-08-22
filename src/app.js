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
            if(typeof lng === "undefined" || typeof lat === "undefined" || typeof radius === "undefined"){
                return h.response("Error! Information missing, try again with longitude, latitude and radius like this:\n/restaurants/statistics?latitude=x&longitude=y&radius=z");
            }else{
                let fun= `SELECT * FROM area('${lng}', '${lat}', ${radius})`
                try{
                    const result = await request.pg.client.query(fun);
                    console.log(result);
                    return h.response(result.rows[0]);
                }catch(err){
                    console.log(err);
                }
            }
        }
    });
    server.route({
        method: 'GET',
        path: '/restaurants/statistics/states',
        handler: async (request, h) => {
            let fun= `SELECT state, count(*), avg(rating) FROM "Restaurants" GROUP BY state ORDER BY avg(rating) DESC`
            try{
                const result = await request.pg.client.query(fun);
                console.log(result);
                return h.response(result.rows);
            }catch(err){
                console.log(err);
            }
        }
    });
    server.route({
        method: 'POST',
        path: '/restaurants/update',
        handler: async (request, h) => {
            
        }
    })

    await server.start();
    console.log(`Server running on ${server.info.uri}`);
};


init();