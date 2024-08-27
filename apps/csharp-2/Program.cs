using Npgsql;
using Dapper;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

// var connectionString = "server=localhost;port=5432;database=the_database;user id=db_user;password=db_pass;include error detail=true;";
var connectionString = Environment.GetEnvironmentVariable("DATABASE_URL");
// using var connection = new NpgsqlConnection(connectionString);

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddTransient<NpgsqlConnection>(provider => new NpgsqlConnection(connectionString));

var app = builder.Build();

// app.MapGet("/products", async (ProductDto product, IMediator mediator) =>
app.MapGet("/", () =>
{
    return Results.Ok("Hello");
});

// app.MapGet("/products", async (ProductDto product, IMediator mediator) =>
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

// class RowData {
//
// }


app.MapPost("/insert", async (NpgsqlConnection connection, RawData body) =>
{
    // var count = await connection.QueryAsync<int>("SELECT count(*) from csharp_2");
    // Console.WriteLine("Counting: {0}", count);
    if (connection.State != System.Data.ConnectionState.Open)
    {
        Console.WriteLine("the connection is not open!!");
        await connection.OpenAsync();
    }
    // Console. WriteLine("Inserting", body);
    var id = System.Guid.NewGuid();
    // Console.WriteLine("id: {0}", id);
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
    //
    // // Write-only property (less common)
    // public string Baz { set; }
}


// app.MapPost("/products", async (ProductDto product, IMediator mediator) =>
// {
//     var result = await mediator.Send(new RegisterProductCommand(product.Id, product.Name, product.Price));
//     return result.IsSuccess ? Results.Ok(result.Value) : Results.BadRequest(result.Error);
// });
