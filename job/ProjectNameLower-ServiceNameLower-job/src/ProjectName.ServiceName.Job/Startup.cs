using Ion;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using ProjectName.ServiceName.Job.Services;

namespace ProjectName.ServiceName.Job
{
    public class Startup : MicroServiceStartup
    {
        public Startup(IConfiguration configuration) : base(configuration)
        {
        }

        public override IServiceCollection OnConfigureServices(IServiceCollection services, IConfiguration configuration,
            IMicroService microservice)
        {
            return services
                .AddHostedService<JobHostedService>();
        }
    }
}