---
paths:
  - "**/*.cs"
  - "**/*.csproj"
  - "**/Directory.Build.props"
  - "**/global.json"
---
# C# / .NET
- Before declaring done: `dotnet build -warnaserror` and `dotnet test` from the solution root.
- Follow the repo's existing data-access choice. New code with no precedent: Dapper, not EF Core.
- Analyzers come from `Directory.Build.props` (Roslynator). Do not suppress warnings; fix them.
- No reflection-based magic, no service-locator, no AutoMapper-style mappers: write the mapping.
