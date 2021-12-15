namespace ProjectName.ServiceName.GraphQL.WeatherForecasting;

public interface IWeatherForecastService
{
    IEnumerable<WeatherForecast> GetWeatherForecast();
}

