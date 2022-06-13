# tf-fg-app-module

## pre-commit

* Install the pre-commit package

``` 
brew install pre-commit
```

* Install the pre-commit hook 

```
pre-commit install
```

## Kitchen

* Install the required ruby gems

```
bundle install
```
* Run the module to create the aws resource

```
bundle exec kitchen converge
```
* Run the Inspec tests

```
terraform output --json > test/integration/default/files/terraform.json
inspec exec test/integration/default
```

