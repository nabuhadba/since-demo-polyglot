using ReportsWorker;

IHost host = Host.CreateDefaultBuilder(args)
    .ConfigureServices(services =>
    {
        services.AddHttpClient();
        services.AddHostedService<NightlyReport>();
    })
    .Build();

await host.RunAsync();
