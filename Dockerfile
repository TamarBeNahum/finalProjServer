# Use the official .NET image as the base image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Use the SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["InternViewServer.csproj", "./"]
RUN dotnet restore "InternViewServer.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "InternViewServer.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "InternViewServer.csproj" -c Release -o /app/publish

# Set up the final stage for the app
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "InternViewServer.dll"]
