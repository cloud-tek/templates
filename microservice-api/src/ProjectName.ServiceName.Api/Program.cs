using Hive;
using Hive.MicroServices;
using Hive.MicroServices.Api;
using Hive.MicroServices.Extensions;

var service = new MicroService("ProjectNameLower-ServiceNameLower-api")
    .ConfigureServices((services, configuration) =>
    {
        // services
        //   .AddSingleton<IHostedJobService, JobService1>();
    })
    .ConfigureApiControllerPipeline();

await service.RunAsync();