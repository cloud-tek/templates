using System.ComponentModel;
using ModelContextProtocol.Server;
using ProjectName.ServiceName.Mcp.Weather;

namespace ProjectName.ServiceName.Mcp.Tools;

[McpServerToolType]
public class WeatherForecastTool
{
    [McpServerTool(Name = "get_weather_forecast")]
    [Description("Gets the weather forecast for the next few days")]
    public static IEnumerable<WeatherForecast> GetWeatherForecast(IWeatherForecastService service)
        => service.GetWeatherForecast();
}
