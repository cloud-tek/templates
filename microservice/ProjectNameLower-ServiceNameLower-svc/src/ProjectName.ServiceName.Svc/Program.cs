using Ion.MicroServices;
using Ion.MicroServices;

namespace ProjectName.ServiceName.Job;

var service = new MicroService("ProjectNameLower-ServiceNameLower-svc")
    .ConfigureServices(services =>
    {
    })
    .ConfigureDefaultServicePipeline();

await service.RunAsync();