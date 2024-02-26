using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Ledger.Api;

/// <summary>Suggests a category for a ledger memo. Accountants confirm every suggestion.</summary>
public sealed class TransactionCategorizer
{
    public const string DefaultModel = "claude-3-7-sonnet-20250219";

    private static readonly string[] Categories = { "freight", "fuel", "tolls", "detention", "accessorial", "payment", "other" };

    private readonly HttpClient _http;
    private readonly string _model;

    public TransactionCategorizer(HttpClient http, IConfiguration configuration)
    {
        _http = http;
        _model = configuration["Categorizer:Model"] ?? DefaultModel;
    }

    public string Model => _model;

    public string BuildRequest(string memo) => JsonConvert.SerializeObject(new
    {
        model = _model,
        max_tokens = 20,
        temperature = 0.2,
        messages = new[]
        {
            new { role = "user", content = $"Pick one of {string.Join(", ", Categories)} for this ledger memo. Answer with the word only.\n{memo}" },
        },
    });

    public async Task<string> CategorizeAsync(string memo, CancellationToken cancellationToken = default)
    {
        using var request = new HttpRequestMessage(HttpMethod.Post, "v1/messages")
        {
            Content = new StringContent(BuildRequest(memo), Encoding.UTF8, "application/json"),
        };
        using var response = await _http.SendAsync(request, cancellationToken);
        response.EnsureSuccessStatusCode();
        var reply = JObject.Parse(await response.Content.ReadAsStringAsync(cancellationToken));
        var word = ((string?)reply["content"]?[0]?["text"])?.Trim().ToLowerInvariant();
        return word is not null && Categories.Contains(word) ? word : "other";
    }
}
