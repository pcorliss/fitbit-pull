Fitbit JSON Parser
==================

Just a quick script to convert the JSON from [Fitbit's time-series API](https://wiki.fitbit.com/display/API/API-Get-Time-Series) into a CSV for importing and processing.

Getting the Data
----------------

I found that using the following endpoint as part of the [API explorer](https://wiki.fitbit.com/display/API/API+Explorer) was the easiest for me. Then I just used the Dev Tools to pull out the response body. A full blown OAuth app would do the trick as well.

```
GET /1/user/[Your User ID]/body/weight/date/2010-08-11/2010-08-15.json
```

Maybe I'll add in an authorization prompts or a Web GUI later on for ease of use.

Usage
-----

```
ruby process_json_to_csv.rb input.json output.csv
```
