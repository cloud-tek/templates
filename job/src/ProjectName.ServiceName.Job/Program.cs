using Hive.MicroServices;
using Hive.MicroServices.Job;

var service = new MicroService("hive-microservices-job-demo")
    .ConfigureServices((services, configuration) =>
    {
        // services
        //     .AddSingleton<IHostedJobService, JobService1>();
    })
    .ConfigureJob();

await service.RunAsync();