using Hive.MicroServices;
using Hive.MicroServices.Extensions;
using Hive.MicroServices.Job;
using ProjectName.ServiceName.Job.Services;

var service = new MicroService("ProjectNameLower-ServiceNameLower-svc")
    .ConfigureServices((services, configuration) =>
    {
        services.AddSingleton<IHostedJobService, JobService1>();
    })
    .ConfigureJob();

await service.RunAsync();