# AWS Unified CloudWatch Cookbook
![Runtime][runtime-badge]
![License][license-badge]

Unofficial Chef Cookbook that install and configure [AWS CloudWatch Logs][aws-cloudwatch-url]
Agent and deploy it's configurations automatically.

## Quickstart

Add this cookbook to your base recipe:

```ruby
cookbook 'aws-cloudwatch', git: 'https://github.com/finfo/chef-aws-cloudwatch.git'
```

And update your recipe/role/etc. to include the install:

    include_recipe 'aws-cloudwatch::default'

    # or if you want to put it in node
    {
      "run_list": [
        ...some awesome recipes...,
        "recipe[aws-cloudwatch::default]"
      ]
    }

You can add files to log by adding attributes in nodes:

    "aws_cloudwatch": {
      "logfiles":[{
        "file_path": "/path/to/log/file1",
        "log_group_name": "log group_name",
        "log_stream_name": "log steam_name"
      }, {
        "file_path": "/path/to/log/file2",
        "log_group_name": "log group_name",
        "log_stream_name": "log steam_name"
      }]
    }

* Add log file infos under `node['aws_cloudwatch']['logfiles']` array.
* Attributes `file_path`, `log_group_name`, `log_stream_name` are required.
* Optional attributes are
  * `timezone`: Default to Local
  * `timestamp_format`: Default to current time
  * `encoding`: Default to utf-8

For more deployment details about AWS CloudWatch Logs, please visit the [AWS CloudWatch Unified Agent Documentation][aws-cloudwatch-url] and [CloudWatch Agent Configuration File Details](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html).

See something missing? Feel free to open a [pull request](https://github.com/ejhayes/aws-codedeploy-agent/pulls)!

## Testing
You can run some basic smoke tests with:

    chef gem install --no-user-install kitchen-docker
    kitchen test

## Requirements

### Platform

* Ubuntu 16.04

## Attributes

See `attributes/default.rb` for default values.

## Recipes

### default

This recipe will check if all necessary requirements being met, and after
that will call `install` recipe.

### install

This recipe will install AWS CloudWatch Logs Agent.

## License and Author

See `LICENSE` for more details.

## Trademark

Amazon Web Services and AWS are trademarks of Amazon.com, Inc. or
its affiliates in the United States and/or other countries.

   [aws-cloudwatch-url]: https://aws.amazon.com/cloudwatch/
   [license-badge]: https://img.shields.io/badge/license-mit-757575.svg?style=flat-square
   [runtime-badge]: https://img.shields.io/badge/runtime-ruby-orange.svg?style=flat-square
