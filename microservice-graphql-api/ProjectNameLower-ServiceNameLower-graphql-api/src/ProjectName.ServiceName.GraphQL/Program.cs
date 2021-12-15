using Ion;
using Ion.MicroServices;
using Ion.MicroServices.GraphQL;
using Microsoft.Extensions.Logging.Abstractions;
using ProjectName.ServiceName.GraphQL.Graph;
using ProjectName.ServiceName.GraphQL.WeatherForecasting;

var service = new MicroService("ProjectNameLower-ServiceNameLower-graphql-api", new NullLogger<IMicroService>())
    .ConfigureServices(services => 
    {
        services.AddSingleton<IWeatherForecastService, WeatherForecastService>();
    })
    .ConfigureGraphQLPipeline(schema =>
    {
        schema.AddQueryType<QueryType>();
    });

await service.RunAsync();