using System.Collections.Concurrent;

namespace Ledger.Core;

/// <summary>The balances the portal shows. The Postgres store is the record; this is the read model.</summary>
public sealed class LedgerBook
{
    private readonly ConcurrentDictionary<string, List<LedgerEntry>> _entries = new(StringComparer.OrdinalIgnoreCase);

    public void Post(LedgerEntry entry)
    {
        if (entry.Amount == 0)
        {
            throw new ArgumentException("a posting needs an amount", nameof(entry));
        }

        var list = _entries.GetOrAdd(entry.Account, _ => new List<LedgerEntry>());
        lock (list)
        {
            list.Add(entry);
        }
    }

    public decimal Balance(string account)
    {
        if (!_entries.TryGetValue(account, out var list))
        {
            return 0m;
        }

        lock (list)
        {
            return list.Sum(entry => entry.Amount);
        }
    }

    public IReadOnlyList<LedgerEntry> Statement(string account, DateOnly from, DateOnly to)
    {
        if (!_entries.TryGetValue(account, out var list))
        {
            return Array.Empty<LedgerEntry>();
        }

        lock (list)
        {
            return list.Where(entry => entry.PostedOn >= from && entry.PostedOn <= to).OrderBy(entry => entry.PostedOn).ToList();
        }
    }
}
