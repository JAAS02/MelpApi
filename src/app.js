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
        method: 'GET',
        path: '/restaurants/{state}',
        handler: async (request, h) => {
            let state = request.params.state;
            let fun= `SELECT city, name, rating, phone FROM "Restaurants" WHERE state='${state}'`
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
        path: '/restaurants/update/{column}',
        handler: async (request, h) => {
            let info = JSON.parse(request.payload);
            let column = request.params.column;
            if(typeof info.id === "undefined" || typeof info.data === "undefined"){
                return h.response("Error! Information missing, id and data is required");
            }else{
                if(column =="name" || column =="site" || column == "email" || column == "phone" || column == "street" || column == "city" || column == "state"){
                    let query = `UPDATE "Restaurants" SET ${column}='${info.data}' WHERE id='${info.id}'`;
                    try{
                        const result = await request.pg.client.query(query);
                        console.log(result);
                        return h.response({"statusCode":200});
                    }catch(err){
                        console.log(err);
                    }
                }else{
                    return h.response("Error! Column doesn't exist");
                }
            }

        }
    });
    server.route({
        method: 'POST',
        path: '/restaurants/delete',
        handler: async (request, h) => {
            let info = JSON.parse(request.payload);
            if(typeof info.id === "undefined"){
                return h.response("Error! Information missing, id and data is required");
            }else{
                let query = `DELETE FROM "Restaurants" WHERE id='${info.id}'`;
                try{
                    const result = await request.pg.client.query(query);
                    console.log(result);
                    return h.response({"statusCode":200});
                }catch(err){
                    console.log(err);
                }
            }
        }
    });
    server.route({
        method: 'POST',
        path: '/restaurants/insert',
        handler: async (request, h) => {
            let info = JSON.parse(request.payload);
            let query = `INSERT INTO "Restaurants" VALUES ('${info.id}',${info.rating},'${info.name}','${info.site}','${info.email}','${info.phone}','${info.street}','${info.city}','${info.state}',${info.lat},${info.lng})`
            try{
                const result = await request.pg.client.query(query);
                console.log(result);
                return h.response({"statusCode":200});
            }catch(err){
                console.log(err);
            }
        }
    })

    await server.start();
    console.log(`Server running on ${server.info.uri}`);
};


init();