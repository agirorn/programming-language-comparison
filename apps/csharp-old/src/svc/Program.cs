// This runtime does not load the REST API endpoints and only loads the services

using ChrlsChn.Momo.Services;
using ChrlsChn.MoMo.Setup;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var builder = Host.CreateApplicationBuilder(args);

builder.Services.Configure<MoMoConfig>(
  builder.Configuration.GetSection(nameof(MoMoConfig))
);

var role = Environment.GetEnvironmentVariable("SVC_ROLE");

switch (role) {
  case nameof(WorkItemMonitorService):
    // Only run WorkItemMonitorService
    Console.WriteLine("Only loading WorkItemMonitorService service");
    builder.Services.AddHostedService<WorkItemMonitorService>();
    break;

  case nameof(WorkItemStatusMonitorService):
    // Only run WorkItemStatusMonitorService
    Console.WriteLine("Only loading WorkItemStatusMonitorService service");
    builder.Services.AddHostedService<WorkItemStatusMonitorService>();
    break;

  default:
    // Run both services
    Console.WriteLine("Loading both services");
    builder.Services.AddHostedService<WorkItemMonitorService>();
    builder.Services.AddHostedService<WorkItemStatusMonitorService>();
    break;
}

builder.Services.AddDataStore();

var host = builder.Build();
host.Run();
