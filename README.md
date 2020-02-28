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

## Creating an up-to-date database diagram

To create an up-to-date database diagram, we're using `rails-erd`.

To run, ensure you have Graphviz installed on your system (see https://voormedia.github.io/rails-erd/install.html).

When you're ready, run:

`erd --filename "doc/database-diagram"`

This will create the database diagram in the `doc` directory. Note that we didn't run `erd` in the context of Rake - if you try this you'll get a `No models found` error.