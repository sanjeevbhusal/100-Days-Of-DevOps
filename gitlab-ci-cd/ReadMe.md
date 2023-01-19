# GitLab CI/CD Pipeline

## What is a Pipeline?

A pipeline is a analogy made when we have to perform a series of steps/jobs to accomplish a goal.

Example: If we want to produce a Laptop, the production has to go through a series of steps such as Assembling the hardware, connecting components together, installing required softwares, doing quality checks and then ship the laptop to customers. The pipeline for producing laptop include all these steps/jobs.

<hr>
<br>

## What is a Job

A job is a concept used while we build the pipiline. A job consists of set of commands that will be executed whenever the pipeline executes.

The file in which we define the Job has to be written in YAML Format.
The file also needs to have a specific name which depends upon the CI provider such as Github, Gitlab etc.

This is the example of how you define CI inside GitLab. The file name has to be **gitlab-ci.yml**

```shell
build laptop:
    script:
        - echo "Buiding Laptop Pipeline starts working"
```

**build laptop** is a job. the **script** section is used to write commands for the job.

📚 **Learning Resources**

- [GitLab CI Notes](./notes/Gitlab-CI.md)
