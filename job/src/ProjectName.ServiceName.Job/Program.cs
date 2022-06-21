using Ion.MicroServices;
using Ion.MicroServices.Job;

var service = new MicroService("ion-microservices-job-demo")
    .ConfigureServices((services, configuration) =>
    {
        // services
        //     .AddSingleton<IHostedJobService, JobService1>();
    })
    .ConfigureJob();

await service.RunAsync();