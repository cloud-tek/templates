namespace ProjectName.ServiceName.Grpc.Weather;

public interface IWeatherForecastService
{
    IEnumerable<WeatherForecast> GetWeatherForecast();
}

