using Ledger.Api;
using Ledger.Core;
using Newtonsoft.Json;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSingleton<LedgerBook>();
builder.Services.AddHttpClient<TransactionCategorizer>(http =>
{
    http.BaseAddress = new Uri("https://api.anthropic.com/");
    http.DefaultRequestHeaders.Add("x-api-key", builder.Configuration["Anthropic:ApiKey"] ?? string.Empty);
    http.DefaultRequestHeaders.Add("anthropic-version", "2023-06-01");
});

var app = builder.Build();

app.MapGet("/health", () => "ok");

app.MapGet("/accounts/{account}/balance", (string account, LedgerBook book) =>
    Results.Text(JsonConvert.SerializeObject(new { account, balance = book.Balance(account) }), "application/json"));

app.MapPost("/entries", async (HttpRequest request, LedgerBook book, TransactionCategorizer categorizer) =>
{
    using var reader = new StreamReader(request.Body);
    var entry = JsonConvert.DeserializeObject<LedgerEntry>(await reader.ReadToEndAsync());
    if (entry is null)
    {
        return Results.BadRequest();
    }

    var categorized = entry with { Category = entry.Category ?? await categorizer.CategorizeAsync(entry.Memo) };
    book.Post(categorized);
    return Results.Text(JsonConvert.SerializeObject(categorized), "application/json", statusCode: 201);
});

app.Run();

public partial class Program
{
}
