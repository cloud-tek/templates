using Ion;
using Ion.MicroServices;
using Ion.MicroServices.Api;

var service = new MicroService("ProjectNameLower-ServiceNameLower-api")
    .ConfigureServices((services, configuration) =>
    {
        // services
        //   .AddSingleton<IHostedJobService, JobService1>();
    })
    .ConfigureApiControllerPipeline();

await service.RunAsync();