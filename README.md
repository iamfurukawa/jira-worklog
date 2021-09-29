# Jiraya 
This is a program to worklog your work in jira.

## How to build image

```bash
docker build -t iamfurukawa/jiraya:v1.0.0 .
```

## How to run
The volume is required! We recommended use the document folder.
```bash
docker run -v "C:\Users\<your-user>\Documents\jiraya:/jiraya" --name "jiraya" -it iamfurukawa/jiraya:v1.0.0
```

## To rerun
Use the docker desktop play or execute:
```bash
docker container start jiraya -i
```

## Pushing a new version
Before build the image localy using the previous command and than push with:
```bash
docker push iamfurukawa/jiraya:v1.0.0  
```