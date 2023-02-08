# GitLab CI

We can define Gitlab CI Pipeline with a file called **gitlab-ci.yml**. This file will be run automatically everytime there is some change to the project. The file has to be in YAML syntax.

Here is the contents of the CI file that will make a fresh computer everytime the project changes.

```shell
build laptop:
    image: alpine
    script: 
        - echo "Buiding Laptop Pipeline starts working"
        - mkdir build
        - touch build/laptop.txt
        - echo "adding the laptop outer case" >>  build/laptop.txt
        - echo "adding monitor, keyboard and essential softwares" >> build/laptop.txt
```

The CI file can contain one or multiple Jobs. A Job contain multiple fields that define how to run that job.

- **build laptop** is a Job.
- **image** defines the docker image to use for creating the environment.
- **script** defines commands for this job. All the commands are executed one after another.

You can either use your own infratructure or Gitlab's infastructure to run this project. We can also see all the logs produced by running this Job inside GitLab.

This pipeline will run inside a docker container to make sure the external environment donot affect the Pipeline. In this example we have specified the image explicitly. If Image is not specified, Gitlab will pull a Ruby Docker Image and build the container from this image.

You might have multiple Jobs. So, it is essential to organize the Jobs. that's why a Job is associated with a stage. If stage is not mentioned explicitly (like this example), GitLab by default uses **Test** Stage.

<hr>
<br>

## Architecture of GitLab

On a over simplified level, gitlab has 2 major components which run our CI pipeline.

- GitLab Server
- Gitlab Runner

Gitab Server store all the information about the pipeline, manages all the jobs and stores all the results generated after executing the jobs.

Gitlab Runner executes the job. Gitlab Server sends instructions to the runner and the runner executes it. There needs to be atleast 1 runner to run the CI Pipeline. You can also have mutiple runners to run pipeline faster.

![Architecutre of GitLab](../../assets/images/Screenshot%20from%202023-01-19%2012-08-59.png)

<hr>
<br>

## Explain the step of pipeline execution

![GitLab Process](../../assets/images/Screenshot%20from%202023-01-19%2012-12-18.png)

These are all the steps explaining this picture.

1. Gitlab Server sends the instructions about Docker Image to Gitlab Runner.
2. Gitlab Runner pulls the docker Image and creates the container.
3. Gitlab Server sends the information about the git repository to clone.
4. Gitlab Runner clones the repository.
5. Gitlab Server sends terminal instructions to execute.
6. Gitlab Runner executes the instructions and sends the log to Gitlab Server.
7. Gitlab Runner destroys the docker container and other related information about this Pipiline execution.
8. Gitlab Server shows the logs to the User.

<hr>
<br>

## Jobs

Every Job runs seperately. Each job creates its own container, replicates the git repository and runs command define within that job.

So, if you have 2 jobs that depend upon each other, either you have to combine those 2 jobs into one or you can export **artifacts** from one job to another.

Gitlab allows you to define a field **artifacts** inside a job. Inside artifcats you can define another field called **paths**. Inside paths you can define folders/files that you want to export from this job. These files/folders are caled artifacts

Gitlab will upload those files in the Gitlab Server. Now, whenever any other job runs, these artifcats will be downloaded to the docker container of the job.

So, if you have 2 jobs, 1 creating a certain file and another checking if that file was created, you will have to export the file from the first job and download the file to another job.

## Stage

Every Job runs on a certain stage. You can either explicitly assign a Job to a Stage or else Gitlab will assign that Job to Test Stage.

Jobs in the same stage runs parallely. If we want to run a job that depends upon another jobs completion, those 2 jobs has to have seperate stages.
