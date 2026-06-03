namespace ProjectName.ServiceName.Mcp.Weather;

public interface IWeatherForecastService
{
    IEnumerable<WeatherForecast> GetWeatherForecast();
}

