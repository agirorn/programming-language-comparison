using Npgsql;
using Dapper;
using System.Text.Json;

var connectionString = Environment.GetEnvironmentVariable("DATABASE_URL");

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddTransient<NpgsqlConnection>(provider => new NpgsqlConnection(connectionString));

var app = builder.Build();

app.MapGet("/", () =>
{
    return Results.Ok("Hello");
});

app.MapGet("/hello", () =>
{
    return Results.Ok("Hello from c# 2");
});


app.MapGet("/count", async (NpgsqlConnection connection) =>
{
    Console.WriteLine("Counting");
    var count = await connection.QueryAsync<int>("SELECT count(*) from csharp_2");
    Console.WriteLine("Counting: {0}", count);
    return Results.Ok(count);
});

app.MapPost("/insert", async (NpgsqlConnection connection, RawData body) =>
{
    if (connection.State != System.Data.ConnectionState.Open)
    {
        Console.WriteLine("the connection is not open!!");
        await connection.OpenAsync();
    }
    var id = System.Guid.NewGuid();
    string sql = $"INSERT INTO csharp_2 (id, data) VALUES (@id, @data)";
    var cmd = new NpgsqlCommand(sql, connection);
    cmd.Parameters.AddWithValue("id", id);
    cmd.Parameters.AddWithValue("data", JsonSerializer.Serialize(body))
        .NpgsqlDbType = NpgsqlTypes.NpgsqlDbType.Json;

    await cmd.ExecuteNonQueryAsync().ConfigureAwait(false);

    return Results.Ok(body);
});

app.Run();


public class RawData
{
    // Read-only property
    public string Key { get; set; }

    public RawData(string key)
    {
        Key = key;
    }
}

