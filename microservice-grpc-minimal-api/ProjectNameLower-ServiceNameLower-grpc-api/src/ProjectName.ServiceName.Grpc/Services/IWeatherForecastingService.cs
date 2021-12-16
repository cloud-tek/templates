using ProtoBuf.Grpc;
using System.ServiceModel;

namespace ProjectName.ServiceName.Grpc.Services;

[ServiceContract]
public interface IWeatherForecastingService
{
    [OperationContract]
    Task<WeatherForecastResponse[]> GetWeatherForecast(CallContext context = default);
}

