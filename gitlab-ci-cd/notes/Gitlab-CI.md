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

The CI file contains Jobs. A Job contain multiple fields that define how to run that job.

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

![GitLab Process](../../assets/images/Screenshot%20from%202023-01-19%2012-12-18.png)

These are all the steps explaining this picture.

1. Gitlab Server sends the instructions about Docker Image to Gitlab Runner.
2. Gitlab Runner pulls the docker Image and creates the container. 3. Gitlab Server then sends the information about the git repository to clone. Gitlab Runner clones the repository
