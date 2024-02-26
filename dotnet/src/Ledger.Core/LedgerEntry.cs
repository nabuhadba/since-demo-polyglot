namespace Ledger.Core;

/// <summary>One posting. Positive amounts are charges to the customer, negative are payments.</summary>
public sealed record LedgerEntry(string Account, decimal Amount, string Memo, DateOnly PostedOn)
{
    public string? Category { get; init; }
}
