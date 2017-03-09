## Status Service

*This feature will be available at launch.*

When using Events you may want to know a bit more about how the systen was behaving when they were collected. For example, if you find a dip in Wikipedia activity you may want to check to see if we were receiving data from Wikipedia at the normal rate over that period, or whether their APIs returned elevated rates of error codes. If you notice that references from a particular website suddenly dry up, you may want to check whether not not they changed their robots policy and we were suddenly unable to collect data from this source.

The Status Service monitors heartbeats and other actions from all components of the system and generates daily reports. It also analyzes the output of CED and generates information. We use these reports internally to monitor the performance of the system and quality of data, but they are open. Entries with an asterisk may be of interest to consumers of Event Data. 

The `status` and `website` reports will probably be of most use to you.

Available daily reports include:

 - `doi-validity`*
    - check that all DOIs conform to a regular expression, i.e. catch obvious mistakes
    - check that all DOIs exist
    - check for stray `?` and `#` characters, which can indicate a bug in processing
 - `event`
    - count of events
    - count of events by DOI prefix
    - count of all distinct DOIs
    - count per source
    - lag between `occurred_at` and `collected` dates. Note that these will often be large, as we can gather Events from historical archives.
 - `evidence`
    - every Event reported in an Evidence Record exists in the API
 - `json`
    - every API response can be parsed by the JQ JSON tool
 - `reversal`*
    - landing page domains that we were unable to reverse into DOIs
 - `status`*
    - daily snapshots of Status heartbeats
 - `websites`
    - domains visited and status codes
    - domains that returned error codes
    - domains that were blocked because of robots.txt

You can access a report at the following URL:

    https://evidence.eventdata.crossref.org/r/«date»/«name».json

e.g.

    https://evidence.eventdata.crossref.org/r/2017-03-01/events.json

