using Ion.MicroServices;

var service = new MicroService("ProjectNameLower-ServiceNameLower-svc")
    .ConfigureServices(services =>
    {
    })
    .ConfigureDefaultServicePipeline();

await service.RunAsync();