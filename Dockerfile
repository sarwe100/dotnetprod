FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY .editorconfig .
COPY src/WeatherApi/WeatherApi.csproj ./
src/WeatherApi.Tests/WeatherApi.Tests.csproj
RUN dotnet restore "WeatherApi.csproj"

# copy everything else and build app
COPY src/WeatherApi/ ./
RUN dotnet publish -c Release -o /app

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app

COPY --from=build /app .

ENTRYPOINT ["dotnet", "WeatherApi.dll"]

# run the unit tests
FROM build AS test
# set the directory to be within the unit test project
WORKDIR src/WeatherApi.Tests/WeatherApi.Tests.csproj
# run the unit tests
RUN dotnet test --logger:trx
