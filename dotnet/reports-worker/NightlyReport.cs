using System.Net.Http.Json;
using System.Text.Json;
using Fleetwise.Reporting.Client;

namespace ReportsWorker;

/// <summary>Builds the nightly receivables report and posts a short summary to the finance channel.</summary>
public sealed class NightlyReport : BackgroundService
{
    private const string SummaryModel = "claude-3-haiku-20240307";

    private readonly IHttpClientFactory _httpFactory;
    private readonly IConfiguration _configuration;
    private readonly ILogger<NightlyReport> _logger;

    public NightlyReport(IHttpClientFactory httpFactory, IConfiguration configuration, ILogger<NightlyReport> logger)
    {
        _httpFactory = httpFactory;
        _configuration = configuration;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var reporting = new ReportingClient(_configuration["Reporting:Endpoint"] ?? "https://reports.fleetwise.internal");
        while (!stoppingToken.IsCancellationRequested)
        {
            var report = await reporting.ReceivablesAsync(DateOnly.FromDateTime(DateTime.UtcNow.AddDays(-1)), stoppingToken);
            var summary = await SummarizeAsync(JsonSerializer.Serialize(report), stoppingToken);
            await reporting.PublishAsync("finance", summary, stoppingToken);
            _logger.LogInformation("Posted the receivables summary for {Day}", report.Day);
            await Task.Delay(TimeSpan.FromHours(24), stoppingToken);
        }
    }

    private async Task<string> SummarizeAsync(string reportJson, CancellationToken cancellationToken)
    {
        var http = _httpFactory.CreateClient();
        http.DefaultRequestHeaders.Add("x-api-key", _configuration["Anthropic:ApiKey"] ?? string.Empty);
        http.DefaultRequestHeaders.Add("anthropic-version", "2023-06-01");
        var response = await http.PostAsJsonAsync("https://api.anthropic.com/v1/messages", new
        {
            model = SummaryModel,
            max_tokens = 300,
            messages = new[] { new { role = "user", content = $"Summarize yesterday's receivables for the finance channel in three bullets:\n{reportJson}" } },
        }, cancellationToken);
        response.EnsureSuccessStatusCode();
        using var reply = JsonDocument.Parse(await response.Content.ReadAsStringAsync(cancellationToken));
        return reply.RootElement.GetProperty("content")[0].GetProperty("text").GetString() ?? string.Empty;
    }
}
