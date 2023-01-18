# Continuous Integration (CI)

When a codebase uses Continuous Integration, it means that all the new changes can only me merged if it satisfies some standards.

Continuous Integration falls under 1st Pillar of DevOps i.e. Pull Reqeuest Automation

<br>

### Benefit of CI

CI gives developer confidence that the code they pushed does not break any existing functionality, does not introduce any security issues, and works as intended in all environments.

<br>

### Who sets these code standards?

The Company managing the codebase sets these standards.

<br>

### What is the purpose of setting these standards?

The purpose is to make sure only good quality code goes into production.

<br>

### What defines a good quality code?

Various Organizations have their own way of determining good quality code.

Some of the characteristics of good quality code is:

- The code must pass all the predefined tests. This gives confidence that the new code didnot break any existing code.

- The code must have a consistent formatting and must not have any linting errors. Every developer have their own preferences of code editor, formatting settings etc. But when the code is pushed in the remote repository, we have to maintain a consistent formatting.

- The code must not introduce any security issues to the application.

- The code must work in all the environments, not just developer environment.

- The test coverage must not be below a certain threshold. This means for a new change to be merged, it might be compulsory to at least test some percentage of the new code changes.

<br>

### How to set up Continuous Integration on a code base

Setting continuous Integration is as simple as writing a script. Everytime a developer pushes a pull request, the script runs.

<br>

### What are the providers that help us set up Continuous Integrtion ?

There are various providers such as Github Actions, GitLab, CircleCI etc.

<br>

# Some Intresting Questions

### What if developer runs all the tests locally before filling Pull Request ? Do we still need automated test running?

Compatibility issues and security issues can be solved if the developer ran all unit/integration tests before submitting a pull request. This will ensure that the proposed change does not break existing functionality.

But there is no way to be 100% sure if the developer ran tests before submitting the pull Request.

To be sure, the pull request reviewer has to pull the proposed change in the local environment and then run all the tests before approving the pull Request.

So, it is a better idea to have automated tests.

<br>

### Is Continuous Integration Replacement of Code Review?

It should also be noted that CI is not a replacement for code reviews. Tests cannot check if the new proposed code is of high quality and actually solves a business requirement.

<hr>
<br>

# Explain the working of CI with real example

Developer completes working on a feature and submits the pull request to merge the feature.

The CI script checks the quality of the pull request such as if the code passes all unit/integration/end-to-end tests, if the code has proper formatting and linting, if the test-coverage satisfies a certain threeshold etc.

If the code doesnot satisfy all the requirements, the pull request will be rejected and the developer will be notified.

If the code satisfies all the requirements, CI script will notify the appropriate Code Reviewer.

The script might also create a Ephemeral Environment once all the tests passes.

<br>
