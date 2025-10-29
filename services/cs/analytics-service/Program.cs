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
app.MapGet("/health", () => new { status = "healthy", service = "analytics-service", stack = "C# (.NET Core)" });

// Analytics endpoints
app.MapGet("/analytics/reports", () =>
{
    // TODO: Implement heavy reporting with LINQ aggregations
    return Results.Ok(new { message = "Analytics reports" });
});

app.MapPost("/analytics/aggregate", () =>
{
    // TODO: Implement data aggregations
    return Results.Ok(new { message = "Data aggregated" });
});

app.MapPost("/analytics/pipeline", () =>
{
    // TODO: Implement data pipeline processing
    return Results.Ok(new { message = "Pipeline executed" });
});

app.MapGet("/analytics/export", () =>
{
    // TODO: Implement BI/export functionality
    return Results.Ok(new { message = "Data exported" });
});

var port = Environment.GetEnvironmentVariable("PORT") ?? "3201";
Console.WriteLine($"📈 Analytics Service is running on: http://localhost:{port}");

app.Run($"http://0.0.0.0:{port}");

