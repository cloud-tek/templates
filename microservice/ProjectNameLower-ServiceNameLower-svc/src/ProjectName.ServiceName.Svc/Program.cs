using System.Threading.Tasks;
using Ion;
using Ion.Logging;
using Ion.Logging.Elasticsearch;
using Ion.Metrics;

namespace ProjectName.ServiceName.Svc
{
    public class Program
    {
        public const string Name = "ProjectNameLower-ServiceNameLower-svc";

        public static async Task Main(string[] args)
        {
            var service = new MicroService<Startup>(Name)
                .WithMetrics()
                .WithLogging(log =>
                    log
                        .ToConsole()
                        .ToElasticsearch());
            await service.RunAsync(null, args);
        }
    }
}