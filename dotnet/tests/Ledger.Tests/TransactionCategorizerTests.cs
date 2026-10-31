using Ledger.Api;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json.Linq;
using Xunit;

namespace Ledger.Tests;

public class TransactionCategorizerTests
{
    private static TransactionCategorizer Create(string? model = null)
    {
        var settings = new Dictionary<string, string?>();
        if (model is not null)
        {
            settings["Categorizer:Model"] = model;
        }

        var configuration = new ConfigurationBuilder().AddInMemoryCollection(settings).Build();
        return new TransactionCategorizer(new HttpClient(), configuration);
    }

    [Fact]
    public void RequestUsesTheDefaultModelWhenNoneIsConfigured()
    {
        var body = JObject.Parse(Create().BuildRequest("Fuel stop, Amarillo"));

        Assert.Equal(TransactionCategorizer.DefaultModel, (string?)body["model"]);
        Assert.Equal(20, (int?)body["max_tokens"]);
        Assert.Null(body["temperature"]);
    }

    [Fact]
    public void ConfiguredModelWins()
    {
        Assert.Equal("some-other-model", Create("some-other-model").Model);
    }
}
