using Npgsql;

namespace Ledger.Core;

public sealed class PostgresLedgerStore
{
    private readonly string _connectionString;

    public PostgresLedgerStore(string connectionString) => _connectionString = connectionString;

    public async Task AppendAsync(LedgerEntry entry, CancellationToken cancellationToken = default)
    {
        await using var connection = new NpgsqlConnection(_connectionString);
        await connection.OpenAsync(cancellationToken);
        await using var command = new NpgsqlCommand(
            "insert into ledger_entry (account, amount, memo, posted_on, category) values (@account, @amount, @memo, @posted_on, @category)",
            connection);
        command.Parameters.AddWithValue("account", entry.Account);
        command.Parameters.AddWithValue("amount", entry.Amount);
        command.Parameters.AddWithValue("memo", entry.Memo);
        command.Parameters.AddWithValue("posted_on", entry.PostedOn);
        command.Parameters.AddWithValue("category", (object?)entry.Category ?? DBNull.Value);
        await command.ExecuteNonQueryAsync(cancellationToken);
    }
}
