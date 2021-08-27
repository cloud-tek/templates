using Ion;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace ProjectName.ServiceName.Svc
{
    public class Startup : MicroServiceApiStartup
    {
        public Startup(IConfiguration configuration) : base(configuration)
        {
        }

        public override IServiceCollection OnConfigureServices(IServiceCollection services, IConfiguration configuration,
            IMicroService microservice)
        {
            return services;
        }
    }
}