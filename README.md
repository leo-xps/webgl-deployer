# DMCC Tech Client Build Repo

## Getting Started

This repo will update the docker-based Unity Client build currently hosted ona docker server.

## Steps to deploy.

1. Clone this repo.
2. Create a build containing the following files inside a rar file named `WebGL.rar`:
   1. WebGL/
      1. TemplateData/\*
      2. ReadyPlayerMe/\*
      3. Build/\*
      4. AgoraWebSDK/\*
      5. index.html
      6. AgoraRTC_N.js
      7. (The files may expand or change in the future)
3. Double check step no.2 as it is very crucial
4. Push to main branch.
5. Each build commit on this branch might take 1 to 2 minutes.

## Notice

If there is a build issue or the build is not working, please contact the developer.

## Notice on uploading large files on codecommit

```bash
# only use on first commit
git push --force --force-if-includes --no-verify landvault-aws main

# use on subsequent commits
git push --no-verify landvault-aws main
```

## Build Command

```bash
docker build . -t elevare-client --build-arg DATA_SERVER="dev-landvault-server.int2.lv-aws-x3.xyzapps.xyz/" --build-arg GAME_SERVER="https://dev-landvault-be.int2.lv-aws-x3.xyzapps.xyz"
docker run -p 80:80 elevare-client
```
