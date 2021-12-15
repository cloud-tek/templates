using Ion.MicroServices;
using Ion.MicroServices.Job;

namespace ProjectName.ServiceName.Job;

var service = new MicroService("ion-microservices-job-demo")
    .ConfigureServices(services =>
    {
        // services
        //     .AddSingleton<IHostedJobService, JobService1>();
    })
    .ConfigureJob();

await service.RunAsync();