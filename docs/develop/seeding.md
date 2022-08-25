# Seeding

Since we don't have a proper UI yet to manage all the components. The easiest way to seed the app is to use a YAML definition. You can see the demo [here](/docs/demo-seed.yaml). 
 
There are 2 ways you can import that file. 

* Console

Log in into the console and do: 

```
YamlElixir.read_from_file('docs/demo-seed.yaml')
|> LiveSup.LiveSup.DataImporter.Importer.import()
```

* API

To use the API you first need to have a valid token, to do that, you can use the following curl command (change the host accordingly):

```
curl --location --request POST 'http://localhost:4000/api/sessions' \
--header 'accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw '{
    "email": "emiliano@summing-up.com",
    "password": "Very@Safe@Password"
}'
```

Grab the token and convert the yaml file into json. You can use `jq --raw-input --slurp < demo-seed.yaml`

```
curl --location --request POST 'http://localhost:4000/api/seed' \
--header 'Authorization: Bearer YOUR-TOKEN-HERE' \
--header 'Content-Type: application/json' \
--data-raw '{
    "data":"....."
  }'
```
