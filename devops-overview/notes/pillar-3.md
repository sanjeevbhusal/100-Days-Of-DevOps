## Pillar 3: Application Performance Management

The main purpose of application performance management is to make sure that the application is performing well in production.

We can do so by focusing on various aspects such as:

- Performing Logging
- Collecting Metrics
- Alerting

<br>

## Performing Logging

The main idea behind logging is to record every actions that happens with our application.

<br>

### What can we log?

- We should log the average time taken for a request and response cycle.
- We should log the time taken by database to process a query.
- We should log the time taken by a API Endpoint to process the request.
- We should log the users IP address, time of the request etc.

<br>

### What are the benefits of logging?

When we log all the data, identifying critical issues becomes easier. We can derive all the insights regarding our application through logged data.

<br>

## Collecting Metrics

The main idea behind collecting metrics is to identify what is going right and what needs to be fixed in the application.

We collect metrics base upon data we receive through Loggs.

<br>

### What metrics can we derive from logs?

- We can identify if a API endpoint is processing a request slowly based upon the average response time of the endpoint.

- We can identify if a database query takes more time.

- We can introduce concepts such as caching if we feel the request response cycle is taking long time.

- We can identify total users per country visiting our application. We can also know the average time when we get more traffic. We can make business plans according to those data.

- We can also check if we have enough Memory, Storage and Processor avaiable. MalFUnctioning of these compnents can cause huge issues.

<br>

## Alerting

Whenever there are some issue, we should automatically alert the associated individuals. This helps to fix the issue faster.
