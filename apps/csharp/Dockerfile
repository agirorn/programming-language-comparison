FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
# COPY ["my-api.csproj", "my-api/"]
COPY . .
# RUN dotnet restore "./my-api/my-api.csproj"
RUN dotnet restore "./my-api.csproj"
# WORKDIR "/src/my-api"
# WORKDIR "/src/my-api"
RUN dotnet build "./my-api.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./my-api.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "my-api.dll"]
