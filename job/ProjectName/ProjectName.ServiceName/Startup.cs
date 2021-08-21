using Demo.Job.Services;
using Ion;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace ProjectName.ServiceName
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