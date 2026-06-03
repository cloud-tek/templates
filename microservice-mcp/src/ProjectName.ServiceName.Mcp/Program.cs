using Hive.MicroServices;
using Hive.MicroServices.Extensions;
using Hive.MicroServices.Mcp;
using ProjectName.ServiceName.Mcp.Tools;
using ProjectName.ServiceName.Mcp.Weather;

var service = new MicroService("ProjectNameLower-ServiceNameLower-mcp")
    .ConfigureServices((services, configuration) =>
    {
        services.AddSingleton<IWeatherForecastService, WeatherForecastService>();
    })
    .ConfigureMcpPipeline(mcp =>
    {
        mcp.WithTools<WeatherForecastTool>();
    });

await service.RunAsync();
