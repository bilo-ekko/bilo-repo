using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors();
app.UseAuthorization();
app.MapControllers();

// Health check endpoint
app.MapGet("/health", () => new { status = "healthy", service = "portfolio-service" });

// Portfolio endpoints
app.MapGet("/portfolios/{id}", (string id) =>
{
    // TODO: Implement portfolio retrieval with LINQ/EF Core
    return Results.Ok(new { id, message = "Portfolio details" });
});

app.MapPost("/portfolios", () =>
{
    // TODO: Implement portfolio creation
    return Results.Ok(new { message = "Portfolio created" });
});

app.MapGet("/portfolios/{id}/aggregate", (string id) =>
{
    // TODO: Implement portfolio aggregation using LINQ
    return Results.Ok(new { id, message = "Portfolio aggregated" });
});

app.MapGet("/portfolios/{id}/report", (string id) =>
{
    // TODO: Implement reporting with typed DTOs
    return Results.Ok(new { id, message = "Portfolio report" });
});

var port = Environment.GetEnvironmentVariable("PORT") ?? "3200";
Console.WriteLine($"📊 Portfolio Service is running on: http://localhost:{port}");

app.Run($"http://0.0.0.0:{port}");

