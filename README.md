# User intent survey explorer

Prototype to help make sense of user intent survey data.

## Deployment

The application is deployed on the Paas and has a IP whitelist router sitting in
front of it to lock it down to office IPs.

To deploy the application, follow the [getting started guide for GOV.UK
PaaS](https://docs.cloud.service.gov.uk/get_started.html#get-started) to set up
your account and the `cf` command line.

You can push a new version with:

```
cf push
```

## Authentication

When the Rails environment is `production`, the application is protected by
basic authentication. You can set the user name and password by creating the two
expected environment variables on the Paas:

```
cf set-env govuk-user-intent-survey-explorer GOVUK_USERNAME <value>
cf set-env govuk-user-intent-survey-explorer GOVUK_PASSWORD <value>
```
