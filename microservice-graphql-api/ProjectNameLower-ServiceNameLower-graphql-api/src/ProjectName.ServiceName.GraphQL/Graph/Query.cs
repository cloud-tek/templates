using HotChocolate.Types;
using ProjectName.ServiceName.GraphQL.WeatherForecasting;

namespace ProjectName.ServiceName.GraphQL.Graph;

public class Query
{
}

public class QueryType : ObjectType<Query>
{
    protected override void Configure(IObjectTypeDescriptor<Query> descriptor)
    {
        descriptor
            .Field("weatherForecast")
            .Type<ListType<WeatherForecastType>>()
            .Resolve(ctx => ctx.Service<IWeatherForecastService>().GetWeatherForecast());
    }
}
