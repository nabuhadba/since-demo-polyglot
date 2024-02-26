using Ledger.Core;
using Xunit;

namespace Ledger.Tests;

public class LedgerBookTests
{
    [Fact]
    public void BalanceSumsChargesAndPayments()
    {
        var book = new LedgerBook();
        book.Post(new LedgerEntry("ACME", 1850.00m, "CHI-DEN pallet x10", new DateOnly(2024, 3, 1)));
        book.Post(new LedgerEntry("acme", -1000.00m, "ACH payment", new DateOnly(2024, 3, 5)));

        Assert.Equal(850.00m, book.Balance("ACME"));
    }

    [Fact]
    public void StatementIsOrderedAndBounded()
    {
        var book = new LedgerBook();
        book.Post(new LedgerEntry("ACME", 20m, "late", new DateOnly(2024, 3, 9)));
        book.Post(new LedgerEntry("ACME", 10m, "early", new DateOnly(2024, 3, 2)));
        book.Post(new LedgerEntry("ACME", 99m, "next month", new DateOnly(2024, 4, 1)));

        var statement = book.Statement("ACME", new DateOnly(2024, 3, 1), new DateOnly(2024, 3, 31));
        Assert.Equal(new[] { "early", "late" }, statement.Select(entry => entry.Memo));
    }

    [Fact]
    public void ZeroPostingsAreRejected()
    {
        Assert.Throws<ArgumentException>(() => new LedgerBook().Post(new LedgerEntry("ACME", 0m, "nothing", new DateOnly(2024, 3, 1))));
    }
}
