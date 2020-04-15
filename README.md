# Wheater-API

This project was created as a practical test.

## Installation

First of all is necessary to clone the repository into your local machine or wherever you want to run it.

```shell
$ git clone git@github.com:Arquetipo28/wheater-api.git
```

after that we will run the bundler to install the required gems as well as the yarn packages.

```shell
$ bundle install
$ yarn install
```

and them just run the application

```shell
$ rails s
```

## API

This contains only one resource and it is not RESTful. It is called `wheater`.
The API can be found at http://{host}:{port}/api/ where host is your local or remote host and port is the one you are running your application on.

| Route         | Action        |
| ------------- | ------------- |
| weather/min   | WheaterController#show_min |
| wheater       | WheaterController#show     |

Is important to mention that the second route specified above can receive two parameters which are order filters, these are `created_at` and `temp` which allow you to filter the historical data in ascendant ('asc') or descendant ('desc') order

## Examples

### Request - Show min temp registered
`GET http://{host}:{port}/api/wheater?temp=desc&created_at=asc`

it is worth mentioning that both query paramters `temp` and `created_at` are both optional and only accepts `asc` or `desc` values.

### Response
```json
{
  "message": "successfully returned min wheater",
  "data": {
    "value": {
      "id": "<integer>",
      "city": "<string>",
      "temp": "<float>",
      "created_at": "<timestamp>",
      "updated_at": "<timestamp>"
    }
  }
}
```

### Request - Show all historical data registered

`GET http://{host}:{port}/api/wheater/min`

### Response
```json
{
  "message": "successfully returned historical wheater",
  "data": {
    "wheater": [
      {
        "id": "<integer>",
        "city": "<string>",
        "temp": "<float>",
        "created_at": "<timestamp>",
        "updated_at": "<timestamp>"
      }
    ]
  }
}
```
