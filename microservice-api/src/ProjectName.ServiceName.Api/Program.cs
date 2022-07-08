using Hive;
using Hive.MicroServices;
using Hive.MicroServices.Api;

var service = new MicroService("ProjectNameLower-ServiceNameLower-api")
    .ConfigureServices((services, configuration) =>
    {
        // services
        //   .AddSingleton<IHostedJobService, JobService1>();
    })
    .ConfigureApiControllerPipeline();

await service.RunAsync();