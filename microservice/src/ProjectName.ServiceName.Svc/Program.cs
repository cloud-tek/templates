using Hive.MicroServices;

var service = new MicroService("ProjectNameLower-ServiceNameLower-svc")
    .ConfigureServices((services, configuration) =>
    {
        // services
        //     .AddSingleton<IHostedJobService, JobService1>();
    })
    .ConfigureDefaultServicePipeline();

await service.RunAsync();