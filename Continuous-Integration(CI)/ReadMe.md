# Continuous Integration (CI)

When a codebase uses Continuous Integration, it means that all the new changes can only me merged if it satisfies some standards.

<br>

### Who sets this standards?

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

<br>

### How to set up Continuous Integration on a code base

Setting continuous Integration is as simple as writing a script. Everytime a developer pushes a pull request, the script runs.

The script checks the quality of the pull request such as if the code passes all unit/integration/end-to-end tests, if the code has proper formatting and linting etc.

If the code doesnot satisfy all the requirements, the pull request will be rejected and the developer will be notified.

<br>

### What are the tools that help us set up Continuous Integrtion

There are various tools such as Github Actions, GitLab, CircleCI etc.
