# Based on the .NET Core self-contained runtime image to run bicep CLI
FROM mcr.microsoft.com/dotnet/core/runtime-deps:3.1-bionic
WORKDIR /bicep

LABEL "com.github.actions.name"="Bicep Build"
LABEL "com.github.actions.description"="Build ARM templates using the bicep CLI"
LABEL "com.github.actions.icon"="copy"
LABEL "com.github.actions.color"="orange"

LABEL "repository"="http://github.com/aliencube/bicep-build-actions"
LABEL "homepage"="http://github.com/aliencube"
LABEL "maintainer"="Justin Yoo <no-reply@aliencube.com>"

# Install curl
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
 && rm -rf /var/lib/apt/lists/*

# Fetch the latest Bicep CLI binary
RUN curl -Lo bicep https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64

# Mark it as executable
RUN chmod +x ./bicep

# Add bicep to your PATH (requires admin)
RUN sudo mv ./bicep /usr/local/bin/bicep

# Verify you can now access the 'bicep' command
RUN bicep --help
# Done!

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
