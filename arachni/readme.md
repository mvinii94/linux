#Build Container:
```docker build -t mvarachni . ```

#Run:
```docker run -p 7331:7331 -d mvarachni```

#Using Arachni REST API

## Create a new scan:

``` curl -X POST -H 'Content-Type: application/json' -d @file.json http://127.0.0.1:7331/scans ```

## file.json Example:
```
{
"url":    "http://infoaws.com",

    "scope": {
            "page_limit": 10
                
    },
        "checks": ["*"]

}

```

##Output
``` {"id":"43db9452c2b17556bde59f0eb89f9952"}```

## Check scan status:
``` curl -s -X GET -H 'Content-Type: application/json' "http://127.0.0.1:7331/scans/${ID}" | jq -c '{status, busy}' ```

## Dowload scan report:
``` wget http://127.0.0.1:7331/scans/"${ID}"/report.html.zip ```
