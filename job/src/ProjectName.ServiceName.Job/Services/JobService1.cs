using Hive.MicroServices.Job;
using Microsoft.Extensions.Logging;

namespace ProjectName.ServiceName.Job.Services;

public class JobService1 : IHostedJobService
{
  private readonly ILogger<JobService1> _logger;

  public JobService1(ILogger<JobService1> logger)
  {
    this._logger = logger;
  }

  public Task StartAsync(CancellationToken cancellationToken)
  {
    _logger.LogInformation("{Service} started", nameof(JobService1));
    return Task.CompletedTask;
  }
}
