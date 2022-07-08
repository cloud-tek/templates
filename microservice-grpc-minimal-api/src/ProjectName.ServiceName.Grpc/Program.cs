using Hive;
using Hive.MicroServices;
using Hive.MicroServices.Grpc;
using Microsoft.Extensions.Logging.Abstractions;
using ProjectName.ServiceName.Grpc.Services;
using ProjectName.ServiceName.Grpc.Weather;

var service = new MicroService("ProjectNameLower-ServiceNameLower-grpc-api", new NullLogger<IMicroService>())
    .ConfigureServices((services, configuration) =>
    {
        services.AddSingleton<IWeatherForecastService, WeatherForecastService>();
    })
    .ConfigureCodeFirstGrpcPipeline(endpoints => {
        endpoints.MapGrpcService<WeatherForecastingService>();
    });

await service.RunAsync();