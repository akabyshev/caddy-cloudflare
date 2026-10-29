@echo off
setlocal enabledelayedexpansion

:: Configuration parameters
set DOCKER_USER=akabyshev
set IMAGE_NAME=caddy-cloudflare
set TAG=2.11.3-alpine
set FULL_IMAGE_NAME=%DOCKER_USER%/%IMAGE_NAME%:%TAG%

echo ===================================================
echo COMPILING CUSTOM CADDY BINARY FOR DOCKER HUB
echo Target: %FULL_IMAGE_NAME%
echo ===================================================

:: Force pull upstream dependencies to clear local cache anomalies
docker build --pull --no-cache -t %FULL_IMAGE_NAME% .
if %errorlevel% neq 0 (
    echo [ERROR] Compilation failed.
    exit /b %errorlevel%
)

echo [SUCCESS] Build complete. Authenticating session...
docker login
if %errorlevel% neq 0 (
    echo [ERROR] Authentication rejected by Docker Hub.
    exit /b %errorlevel%
)

echo Uploading verified layers to Docker Hub...
docker push %FULL_IMAGE_NAME%
if %errorlevel% neq 0 (
    echo [ERROR] Upload failed.
    exit /b %errorlevel%
)

echo [SUCCESS] Image successfully pushed to cloud storage.
endlocal