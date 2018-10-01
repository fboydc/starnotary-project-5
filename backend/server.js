'use strict';

const Hapi = require('hapi');
const starNotary = require("./starNotary");



const server = Hapi.server({
    port: 3000,
    host: 'localhost'
});

server.route({
    method: 'GET',
    path: '/',
    handler: (request, h) => {
        return 'Hello, World!';
    }
});

server.route({
    method: 'GET',
    path: '/{name}',
    handler: (request, h) => {
        return 'Hello, ' + encodeURIComponent(request.params.name) + '!';
    }
})

server.route({
    method: 'GET',
    path: '/star/{id}',
    handler: (request, h) => {
        
        return starNotary.getStarById( encodeURIComponent(request.params.id)).then(result=>{
            console.log("result", result);
            return result;
        })
    }
})

server.route({
    method: 'POST',
    path: '/newstar',
    handler: (request, h) => {
        //console.log(getStar);
        const {name, id, dec, mag, cent, story} = request.payload;

        return starNotary.createNewStar(name, id, dec, mag, cent, story).then(result=>{
            console.log("result", result);
            return result;
        })
    }
})

const init = async () =>{
    await server.start();
    console.log(`Server running at : ${server.info.uri}`);
};

process.on('unhandledRejection', (err)=>{
    console.log(err);
    process.exit(1);
});


init(); 

