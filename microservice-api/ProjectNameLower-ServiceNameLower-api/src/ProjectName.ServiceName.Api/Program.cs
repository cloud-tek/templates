using Ion;
using Ion.MicroServices;
using Ion.MicroServices.Api;

namespace ProjectName.ServiceName.Api;

var service = new MicroService("ion-microservices-api-demo")
    .ConfigureServices(services => { })
    .ConfigureApiControllerPipeline();

await service.RunAsync();