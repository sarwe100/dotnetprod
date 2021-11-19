FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app
COPY *.sln .
COPY src/WeatherApi/WeatherApi.csproj  ./src/WeatherApi/
COPY src/WeatherApi.Tests/WeatherApi.Tests.csproj ./src/WeatherApi.Tests/

RUN dotnet restore
# copy full solution over
COPY . .
RUN dotnet build
FROM build AS testrunner
WORKDIR /app/test/WeatherApi.Tests
CMD ["dotnet", "test", "--logger:trx"]
# run the unit tests
FROM build AS test
WORKDIR /app/test/WeatherApi.Tests
RUN dotnet test --logger:trx

# publish the API
FROM build AS publish
WORKDIR /app/src/WeatherApi
RUN dotnet publish -c Release -o out
# run the api
FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-alpine AS runtime
WORKDIR /app
COPY --from=publish /app/src/WeatherApi/out ./
EXPOSE 80
ENTRYPOINT ["dotnet", "WeatherApi.dll"]


