﻿using ProjectName.ServiceName.Grpc.Weather;
using ProtoBuf.Grpc;

namespace ProjectName.ServiceName.Grpc.Services;

public class WeatherForecastingService : IWeatherForecastingService
{
    private readonly IWeatherForecastService service;
    public WeatherForecastingService(IWeatherForecastService service)
    {
        this.service = service ?? throw new ArgumentNullException(nameof(service));
    }
    public Task<WeatherForecastResponse[]> GetWeatherForecast(CallContext context = default)
    {        
        return Task.FromResult(service.GetWeatherForecast().Select(x => new WeatherForecastResponse()
        {
            Date = x.Date,
            TemperatureC = x.TemperatureC,
            TemperatureF = x.TemperatureF,
            Summary = x.Summary
        }).ToArray());
    }
}

