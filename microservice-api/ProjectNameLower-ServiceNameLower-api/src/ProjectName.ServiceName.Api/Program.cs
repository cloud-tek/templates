using Ion;
using Ion.MicroServices;
using Ion.MicroServices.Api;

var service = new MicroService("ProjectNameLower-ServiceNameLower-api")
    .ConfigureServices(services => { })
    .ConfigureApiControllerPipeline();

await service.RunAsync();