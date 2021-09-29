# Jiraya 
This is a program to worklog your work in jira.

## How to build image

```bash
docker build -t jiraya:v1.0.0 .
```

## How to run
The volume is required! We recommended use the document folder.
```bash
docker run -v "C:\Users\<your-user>\Documents\jiraya:/jiraya" --name "jiraya" -it jiraya:v1.0.0
```

## To rerun
Use the docker desktop play or execute:
```bash
docker container start jiraya -i
```