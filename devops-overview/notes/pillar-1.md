# Table of Contents

1. [Pull Request Automation](#pull-request-automation) Environment

   - [Running Automated tests](#automated-tests)
   - [Code Review](#code-review)
   - [Ephimeral Environment](#ephimeral-environment)
   - [Auto Notification](#auto-notification)

<br>

# Pillar 1: Pull Request Automation <a name="pull-request-automation"></a>

The main purpose of pull request automation is to make sure the proposed code gets merged as fast as possible.

Pull Request Automation consists of

- running automated tests
- performing code review
- creating ephemeral environments.
- sending automatic notifications.

## Running Automated tests <a name="automated-tests"></a>

Automated tests are tests that runs whenever a new pull request is submitted.

<br>

### Why do we need automated tests?

Whenever a developer proposes a new change i.e. files a pull request, the new change might create some problem to existing code base.

So, we run automated tests on the new proposed change to make sure there arent any problems.

<br>

### What if the automated test fails?

If the test fails, the pull request gets rejected. The script will automatically notify the developer.

<br>

### What does this tests contain?

This tests are noting but unit/integration/end-to-end tests which are written to test the project's functionality.

<br>

### Can't we run these tests locally?

Yes, a developer can run all the tests in their local development environment first. If all the test passes, then they can submit a pull request.

However, we can't be sure if all developer will do that. So it is better to set up automated tests.

<br>

### What are other tests that we can do?

We can also set up linting, formatting and security checks.

By Setting Linting Checks, we can reject those changes which contain any linting errors.

By Setting Formatting Checks, we can reject those changes which donot follow the predefined format.

By Setting Security Checks, we can reject those changes which may potentially introduce security issues.

<hr>
<br>

## Code Review <a name="code-review"></a>

Code Review is a process of reviewing someone elses code.

<br>

### Why is Code Review Done?

Code Review is done to make sure the new changes complies with standards set by the organization.

<br>

### When is Code Review Done?

It is generally done when a developer submits a pull request.

<br>

### Who does Code Review?

The person reviewing the code in pull request is called `Code Reviewer`.

<br>

### Who can be a Code Reviewer?

Code Reviewer is usually another developer who has the knowledge of the codebase which has been changed.

For Visual Changes, the code also has to be approved by the designer who made the design specification.

However, In large Organizations other individuals are also involved in code review, such as product manager/engineering managers who are charge of the functionlality.

Sometimes, management also has to approve the changes. However, management people cannot understand code, so we create ephimeral environments.

<hr>
<br>

## Ephemeral Environments <a name="ephimeral-environment"></a>

Ephemeral environment is a temporary environment created by building the application from the changes in pull request.

Its main purpose is to let other stakeholders interact with the application.

<br>

### Problens in Current Approach

Whenever we review a pull request, we can see the changes done in the pull request. But we cannot interact with the application. To do so, we have to pull the change locally and run the application.

This is a tiresome process. This is where Ephemeral Environments help.

### How does Ephemeral Environment solve the issue?

Ephemeral environments lets us interact with the application which is built from the changed code.

We can then share the URL of the ephemeral environment and let the code reviewer see the application.

This saves time for the developer as we no longer need any kind of meeting to showcase the latest changes.

### Other Advantages of Ephemeral Environments

This also helps non-technical people understand what our code change did to the application.

We can also have QA Engineers do manual testing in this ephemeral environment.

<br>

### When should we close the ephemeral environment?

There are mulitple strategies one can use. But generaly, ephemeral environments should be closed once the pull Request has been merged.

The code Reviewer checks the application in our ephimeral environment and when satisfied merges the pull request.

<br>

### Drawbacks of ephemeral environment

Creation of each ephemeral environment costs money.

So, if we are taking a lot of time to merge a pull request, then creation of ephemeral environment will increase the deployment cost of the company multiple times.

<hr>
<br>

## Auto Notification <a name="auto-notification"></a>

<br>

We have to automatically notify the code reviewer to review the new pull request.

<br>

### When should we notify code reviewer?

Whenever a pull request passes all the automatic tests, we have to notify the code reviewer.

<br>

### What is the benefit of sending auto notification?

Auto notification is sent to fasten the process of reviewing the pull request.

The biggest reason why softwares are shipped slowly is due to time taken in code review.

We can fasten the process by automatically sending notification to the code reviewer.

<br>
<hr>
