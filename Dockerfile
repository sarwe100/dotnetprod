FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY .editorconfig .
COPY src/WeatherApi/WeatherApi.csproj ./
RUN dotnet restore "WeatherApi.csproj"

# copy everything else and build app
COPY src/WeatherApi/ ./
RUN dotnet publish -c Release -o /app

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app

COPY --from=publish /app .

ENTRYPOINT ["dotnet", "WeatherApi.dll"]