FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["analytics-service.csproj", "./"]
RUN dotnet restore "analytics-service.csproj"

COPY . .
RUN dotnet build "analytics-service.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "analytics-service.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

EXPOSE 3201

ENTRYPOINT ["dotnet", "analytics-service.dll"]

