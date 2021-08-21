using Microsoft.Extensions.Hosting;
using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;

namespace ProjectName.ServiceName.Services
{
    public class JobHostedService : IHostedService
    {
        private readonly ILogger<JobHostedService> logger;

        public JobHostedService(ILogger<JobHostedService> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public async Task StartAsync(CancellationToken cancellationToken)
        {
            logger.LogInformation($"{nameof(JobHostedService)} started");

            await Task.Delay(10000);
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            return Task.FromResult(0);
        }
    }
}