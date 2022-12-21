using Hive.MicroServices;
using Hive.MicroServices.Job;

var service = new MicroService("ProjectNameLower-ServiceNameLower-svc")
    .ConfigureServices((services, configuration) =>
    {
        // services
        //     .AddSingleton<IHostedJobService, JobService1>();
    })
    .ConfigureJob();

await service.RunAsync();