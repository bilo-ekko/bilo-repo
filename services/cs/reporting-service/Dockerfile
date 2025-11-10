FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["reporting-service.csproj", "./"]
RUN dotnet restore "reporting-service.csproj"

COPY . .
RUN dotnet build "reporting-service.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "reporting-service.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

EXPOSE 4011

ENTRYPOINT ["dotnet", "reporting-service.dll"]

