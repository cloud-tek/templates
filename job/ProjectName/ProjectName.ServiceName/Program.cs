using System;

namespace ProjectName.ServiceName
{
    public class Program
    {
        public const string ServiceName = "demo-job";

        public static async Task Main(string[] args)
        {
            var service = new Ion.Job<Startup>(ServiceName)
                .WithMetrics()
                .WithLogging(log =>
                    log
                        .ToConsole()
                        .ToElasticsearch());
            await service.RunAsync(null, args);
        }
    }
}