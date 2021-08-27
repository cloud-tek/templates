using Ion;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace ProjectName.ServiceName.Api
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

        public override void OnConfigureEndpoints(IEndpointRouteBuilder endpoints)
        {
        }
    }
}