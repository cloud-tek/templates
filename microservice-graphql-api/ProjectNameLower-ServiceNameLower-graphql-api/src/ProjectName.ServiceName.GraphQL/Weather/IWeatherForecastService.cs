namespace ProjectName.ServiceName.GraphQL.Weather;

public interface IWeatherForecastService
{
    IEnumerable<WeatherForecast> GetWeatherForecast();
}

