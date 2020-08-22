const Hapi = require('@hapi/hapi');

const init = async () =>{ 
    const server = new Hapi.Server({
        port: 3000,
        host: 'localhost'
    })

    server.route({
        method: 'GET',
        path: '/restaurants/statistics',
        handler: (request, h) =>{
            console.log(request.query.radius);
            return 'Hello World'
        }
    })

    await server.start();
    console.log(`Server running on ${server.info.uri}`);
};


init();