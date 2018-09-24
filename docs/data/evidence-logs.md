# Evidence Records

Evidence Logs trace the actions performed within Event Data during the creation of an Event. They should be read in conjunction with the Evidence Records. Evidence Logs are collected daily and are made up of a sequence of entries, each entry describing a particular action that was taken. Each Evidence Log corresponds to a slice of time, and typically comprises a few million entries.

There are a standard set of fields, including the Evidence Record ID. You can use this either to find all activity in the Evidence Log that correspond to the processing of a particular Evidence Record, or to find the Evidence Record that corresponds to a particular Log Entry.

Evidence Logs and Evidence Records fulfill slightly different roles. Whilst the Evidence Record describes the data that came in, the resulting Events, and the interim steps that were taken, the Evidence Logs describe in detail exactly which steps were taken.

Software changes over time, so it may not behave today the same way it behaved a year ago. The Evidence Records describe exactly what happened. Becuase of this you will see changes in the logs over time, including some log message types that are no longer produced.

# Format

Evidence Logs are available in two formats, which can be read by a wide variety of tools:

 - Lines of JSON entries
 - CSV

There is a controlled set of fields available. They have one-character names for compactness (log files can run to around one gigabyte per day). All fields except `t` are optional, and the precise meaning varies between log entry types:

| Field | Name | Description |
|-------|------|-------------|
| `t` | <u>T</u>imestamp | A UNIX epoch timestamp of when the action occurred, i.e. milliseconds since January 1, 1970 UTC. |
| `s` | <u>S</u>ervice | The service that logged the Entry, in most cases the name of an Agent or the Percolator. For example, `reddit-agent` or `percolator`. |
| `c` | <u>C</u>omponent | The Component within the Service, which broadly corresponds to a task being performed. For example, the Percolator has a `web` component to retrieve web pages. |
| `f` | <u>F</u>acet | The facet of work being done. For example, the Percolator's `web` component has a `request` facet for reporting on how it retrieves webpages, and a `robots-txt-check` to report on how it checks various websites' `robots.txt` files. |
| `i` | Log message type <u>I</u>D | An ID for the message type. Enables you to find a log type in the source code or to trace all log messages of the same type. |
| `p` | <u>P</u>artition | When the same task is running a number of times in parallel, a partition number might be indicated. |
| `r` | Evidence <u>R</u>ecord ID | This is included for all actions that are related to the processing of a given Evidence Record. |
| `a` | <u>A</u>ction ID | The Action ID, if present. Every Evidence Record is made up of Actions, most of which have IDs. This allows you to trace an input through to a match. Note that some Agents, for example Wikipedia, do not assign action IDs. |
| `v` | <u>V</u>alue | Some actions have a value associated with them. Depending on context this can be an input value or a result value. |
| `d` | <u>D</u>OI | The action may have an associated DOI. |
| `n` | Eve<u>n</u>t ID | The action may concern a particular Event. |
| `u` | <u>U</u>RL | The action may concern a particular URL. |
| `e` | R<u>e</u>sult status | Where an operation can succeed or fail, this can have a value of `t` for 'true', `f` for 'false', `e` for 'error' etc. |
| `o` | <u>O</u>rigin of the data | This can be `c` for 'cache' or `e`q for external. For example, `robots.txt` files are cached. This parameter allows you to know whether a value was retrieved at that point in time or from cache, which may explain why a value is slightly out of date.

Note that this list is not exhaustive, and historical log messages may use different fields. Specifically, during the pre-release Beta period, the format was changed on or around the 21st August 2017 for various components.

Note that the selection of fields may expand in future, including new fields names with more than one character. According to convention, the order of fields in the CSV file is specified by the first line, so you should not rely on the order of columns remaining unchanged.

# Log types

Every type of log message communicates a type of action or decision that was taken. You can identify them by the service.component.facet fields. In addition to this a message type ID is specified in the `i` field.

## Percolator

The Percolator is the system that performs the work of extracting and identifying links to Registered Content, and is used by all of the Crossref Agents. Therefore, when tracing the creation of an Event, most of the activity, and therefore log entries, will come from the Percolator. The Percolator works in batches, each batch being stored an Evidence Record. 

The Percolator works in three stages: identify candidates from the input data, match each candidate to a DOI, then produce an Event for each match. There are also underlying activities that happen (such as fetching webpages) that describe activity in more detail.

## Percolator DOI Matching

### Percolator was instructed to a visit a URL to look for links

The Percolator was instructed to a visit a URL to see if it could find links to registered content. This log entry describes whether or not it was allowed to visit this page. Reasons for not visiting include a URL being malformed, the wrong content type (for example a PDF) or being hosted on a domain that we think could have a DOI, which disqualifies it from Event Data.

 - `i` - "p0001"
 - `s` - "percolator" 
 - `c` - "observation"
 - `f` - "should-visit-content-page"
 - `v` - If allowed then "t", otherwise "f".
 - `r` - The Evidence Record ID.
 - `u` - The URL in question.
 - `t` - Timestamp.

### Percolator was instructed to visit a URL to see if it is an article landing page

The Percolator was instructed to visit a URL to see if it is an article landing page. This log entry describes whether or not it was allowed to visit the page. Reasons for not visiting include a URL being malformed, the wrong content type (for example PDF) or it not being hosted on a domain that we think could have a DOI.

 - `i` - "p0002"
 - `s` - "percolator" 
 - `c` - "match-landing-page-url"
 - `f` - "should-visit-landing-page"
 - `v` - If allowed then "t", otherwise "f".
 - `r` - The Evidence Record ID.
 - `u` - The URL in question.
 - `t` - Timestamp.

### Percolator attempted to match observation

The Percolator attempted to match one of a number of types of Observation to a DOI. The log entry records the type of observation, the success or failure of the operation, and the resulting DOI.

The operations involved in performing this match are described in more detail in other log messages (such as percolator.match-doi-url.match).

 - `i` - "p0003"
 - `s` - "percolator"
 - `c` - "match"
 - `f` - One of:
      - "doi-url" - A DOI in the format of a URL, e.g. `https://doi.org/10.5555/12345678`
      - "pii" - a PII (Publisher Item Identifier), e.g. `S0960-9822(11)01319-4`
      - "plain-doi" - A DOI expressed without the URL, e.g. `10.5555/12345678`
      - "shortdoi-url" - A ShortDOI, eg. `http://doi.org/hvx`
      - "landing-page-url" - The URL of a landing page, e.g. `http://psychoceramics.labs.crossref.org/10.5555-12345678.html`
 - `r` - The Evidence Record ID.
 - `d` - The resulting valid DOI, if succesful.
 - `s` - If succesful, `t` otherwise `f`.
 - `t` - Timestamp.

### Percolator attempted to match a candidate DOI URL

The Percolator attempted to match a candidate DOI URL to a valid DOI. This provides more detail for `percolator.match.doi-url`.

 - `i` - "p0004"
 - `s` - "percolator"
 - `c` - "match-doi-url"
 - `f` - "match"
 - `a` - The Action ID.
 - `v` - The input DOI URL.
 - `d` - The resulting valid DOI, if succesful. 
 - `e` - If succesful, `t` otherwise `f`.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Percolator attempted to match a Landing Page URL

The Percolator attempted to match a Landing Page URL that contains a DOI as one of the query parameters to a valid DOI. This provides more detail for `percolator.match.landing-page-url`.

 - `i` - "p0005"
 - `s` - "percolator"
 - `c` - "match-landingpage-url"
 - `f` - "from-get-params"
 - `a` - The Action ID.
 - `u` - The input Landing Page URL.
 - `d` - The resulting valid DOI, if succesful.
 - `e` - If succesful, `t` otherwise `f`.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.
 
### Percolator attempted to match a Landing Page URL with embedded DOI

The Percolator attempted to match a Landing Page URL that contains an embedded DOI string to a valid DOI. This provides more detail for `percolator.match.landing-page-url`.

 - `i` - "p0006"
 - `s` - "percolator"
 - `c` - "match-landingpage-url"
 - `f` - "from-url-text"
 - `a` - The Action ID.
 - `u` - The input Landing Page URL.
 - `d` - The resulting valid DOI, if succesful.
 - `e` - If succesful, `t` otherwise `f`.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.
 
### Percolator attempted to match a Landing Page URL with embedded PII

The Percolator attempted to match a Landing Page URL that contains an embedded PII string to a valid DOI. This provides more detail for `percolator.match.landing-page-url`.

 - `i` - "p0007"
 - `s` - "percolator"
 - `c` - "match-landingpage-url"
 - `f` - "from-pii-from-url-text"
 - `a` - The Action ID.
 - `u` - The input Landing Page URL.
 - `d` - The resulting valid DOI, if succesful.
 - `e` - If succesful, `t` otherwise `f`.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.
 
### Percolator attempted to match Landing Page URL with DOI in metadata

The Percolator attempted to match Landing Page URL in case that page contains a valid DOI in in its HTML metadata. In order to do this, it must fetch the landing page to look at its metadata. Because this is a frequent operation, the result is cached to avoid overloading websites. The `e` field indicates whether the cache was consulted or whether the Percolator had to go and retrieve the page from an external request via Internet.

This provides more detail for `percolator.match.landing-page-url`.

 - `i` - "p0008"
 - `s` - "percolator"
 - `c` - "match-landingpage-url"
 - `f` - "from-page-metadata"
 - `a` - The Action ID.
 - `u` - The input Landing Page URL.
 - `d` - The resulting valid DOI, if succesful.
 - `e` - If succesful, `t` otherwise `f`.
 - `o` - If an external request was made to the Internet, `e`. If the result was fetched from cache, `c`.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Percolator attempted to match a PII to a valid DOI

The Percolator attempted to match a PII to a valid DOI. This provides more detail for `percolator.match.pii`.

 - `i` - "p0009"
 - `s` - "percolator"
 - `c` - "match-pii"
 - `f` - "validate"
 - `a` - The Action ID.
 - `v` - The input PII value.
 - `d` - The resulting valid DOI, if succesful.
 - `e` - If succesful, `t` otherwise `f`.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Percolator attempted to match a plain DOI to a valid DOI

The Percolator attempted to match a plain DOI to a valid DOI. This provides more detail for `percolator.match.plain-doi`.


 - `i` - "p000a"
 - `s` - "percolator"
 - `c` - "match-plain-doi"
 - `f` - "match"
 - `a` - The Action ID.
 - `v` - The input plain DOI.
 - `d` - The resulting valid DOI, if succesful.
 - `e` - If succesful, `t` otherwise `f`.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Percolator attempted to match a ShortDOI URL to a valid DOI

The Percolator attempted to match a ShortDOI URL to a valid DOI. This provides more detail for `percolator.match.plain-doi`

 - `i` - "p000b"
 - `s` - "percolator"
 - `c` - "match-shortdoi-url"
 - `f` - "validate"
 - `a` - The Action ID.
 - `v` - The ShortDOI input URL.
 - `d` - The resulting DOI, if succesful.
 - `e` - If succesful, `t` otherwise `f`.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

## Percolator Process Control

### Percolator created Event

When the Percolator creates an Event and sends it on through the system.

 - `i` - "p000c"
 - `s` - "percolator"
 - `c` - "process"
 - `f` - "send-event"
 - `n` - The Event ID.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Percolator failed to send Event

This arises when there is an error connecting to the internal event bus.

 - `i` - "p001d"
 - `s` - "percolator"
 - `c` - "process"
 - `f` - "send-event-error"
 - `n` - The Event ID


### Percolator input lag count

The Percolator monitors an input queue of Evidence Records sent by Agents. The Queue is split into a number of partitions, and each running instance of the Percolator monitors a number of partitions. At peak load the Percolator may get behind in processing, but catch up again at a quieter time. This log entry records how far behind the the Percolator is in each partition of the queue. 

This number can help to explain, for example, delays in the system between an event occurring and the time when it is processed.

 - `i` - "p000d"
 - `s` - "percolator"
 - `c` - "process"
 - `f` - "input-message-lag"
 - `p` - Partition number
 - `v` - Lag, measured in number of messages.
 - `t` - Timestamp.

### Percolator input lag time

The Percolator also monitors the time delay between an Agent sending the Evidence Record and the time when it started to process it. See `percolator.process.input-message-lag` for more information.

 - `i` - "p000e"
 - `s` - "percolator"
 - `c` - "process"
 - `f` - "input-message-time-lag"
 - `v` - Lag, measured in milliseconds.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Percolator input item size

The Percolator monitors the size of each input Evidence Record in bytes. 

 - `i` - "p000f"
 - `s` - "percolator"
 - `c` - "process"
 - `f` - "input-message-size"
 - `v` - Size, measured in bytes.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Percolator starts processing Evidence Record

The Percolator records when it starts and finished processing each Evidence Record. You may occasionally see duplicate 'start' events for a given Evidence Record ID, due to the design of the pipeline. The Percolator ensures that it doesn't re-process the same Evidence Record twice. 

 - `i` - "p0010"
 - `s` - "percolator"
 - `c` - "process"
 - `f` - "start"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Percolator skips already processed Evidence Record

Due to the design of the pipeline, the Percolator can receieve an Evidence Record that it already processed in the past. If this happens, this log entry will indicate that the Evidence Record was skipped for this reason.

 - `i` - "p0011"
 - `s` - "percolator"
 - `c` - "process"
 - `f` - "skip-already-processed"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Percolator skips currently processing Evidence Record

Due to the design of the pipeline, the Percolator can receieve an Evidence Record that it's already processing elsewhere. If this happens, this log entry will indicate that the Evidence Record was skipped for this reason.

 - `i` - "p0012"
 - `s` - "percolator"
 - `c` - "process"
 - `f` - "skip-processing-elsewhere"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.


### Percolator finishes processing Evidence Record

The Percolator records when it starts and finished processing each Evidence Record. It also records time time taken to process the Evidence Record.

 - `i` - "p0013"
 - `s` - "percolator"
 - `c` - "process"
 - `f` - "finish"
 - `v` - Time taken to process Evidence Record in milliseconds.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

## Percolator supporting functions

### Percolator saw a Newsfeed link

Whenever the Percolator visits a webpage it records any newsfeed links (e.g. RSS or Atom) that it finds on that page. This data may be useful at some future point in time.

 - `i` - "p0014"
 - `s` - "percolator"
 - `c` - "newsfeed-link"
 - `f` - "found"
 - `a` - The Action ID.
 - `v` - The URL of the page visited.
 - `u` - The URL of the newsfeed.
 - `p` - The "rel" field of the link (could be e.g "alternate", "comments" etc)
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

## Percolator Lookups / Matching

### Percolator validates DOI

When the Percolator needs to validate that a DOI exists, it will check a local cache of valid DOIs. If it can't find the DOI in the local cache, it will call out to the call out to the API on DOI.org. 

 - `i` - "p0015"
 - `s` - "percolator"
 - `c` - "doi"
 - `f` - "validate"
 - `a` - The Action ID.
 - `v` - The input suspected DOI.
 - `d` - A valid, normalized DOI, if there was a match.
 - `e` - On success "t", otherwise "f".
 - `o` - If the result was found in the cache, "c". Otherwise, if an external request was necessary, "e".
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Percolator resolves DOI on Handle API

This is called as part of `percolator.doi.validate`, and indicates that the Percolator went out and made a call to the DOI.org API via the Internet. Because it's sometimes difficult to identify precisely where a DOIs ends, the DOI validator may try validating the DOI by repeatedly dropping a number of characters from the end. 

 - `i` - "p0016"
 - `s` - "percolator"
 - `c` - "doi"
 - `f` - "resolve"
 - `v` - Input DOI
 - `e` - `t` if successful match, otherwise `f`.
 - `d` - Resulting DOI on success. Note that, as DOIs are case-insensitive, this value may be in a different case to the input.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Percolator looks up PII with Crossref API

When the percolator finds a PII, it needs to make a call to the Crossref REST API to search for a DOI connected to that PII. 

 - `i` - "p0017"
 - `s` - "percolator"
 - `c` - "pii"
 - `f` - "lookup"
 - `a` - The Action ID.
 - `v` - The input PII.
 - `d` - If successful, the DOI.
 - `e` - `t` if successful match, otherwise `f`.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Percolator URL fetch request

This occurs when the Percolator requests a webpage. There are a number of reasons for this, for example visiting a Landing Page to retrieve article metadata or visiting a webpage that was mentioned in a newsfeed. The response is indicated by `percolator.fetch.response` or `percolator.fetch.error`.

 - `i` - "p0018"
 - `s` - "percolator"
 - `c` - "fetch" 
 - `f` - "request"
 - `a` - The Action ID.
 - `u` - The URL requested.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Percolator URL fetch response

This indicates that a response was received from a web request. Because a web request may involve a number of redirects, there may be more than one response that corresponds to the `percolator.fetch.request` log entry.

 - `i` - "p0019"
 - `s` - "percolator"
 - `c` - "fetch" 
 - `f` - "response"
 - `a` - The Action ID.
 - `u` - The URL requested (may be different due to redirects).
 - `v` - The HTTP Status Code returned by the server (e.g. 200 for success, 30x for redirect, 404 for "not found").
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Percolator URL fetch request error

This indicates that an HTTP request resulted in an error. Ther are a number of kinds of error:

 - `i` - "p001a"
 - `s` - "percolator"
 - `c` - "fetch" 
 - `f` - "error" 
 - `a` - The Action ID.
 - `v` - Type of error:
     - "uri-syntax-exception" - There was an error in the syntax of the URL
     - "unknown-host-exception" - The host (domain name) was not recognised.
     - "timeout-exception" - There was a timeout waiting for the server to respond causing an error.
     - "timeout" - The Percolator killed an HTTP request as a failsafe because it took to long. Timeouts will usually be signalled by the other "timeout-exception" error type.
     - "protocol-exception" - There was a network-level error.
     - "unknown-exception" - Some other error.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Percolator checked robots.txt file for URL

The Percolator checks the robots.txt file for every web request and only accesses a site if it is allowed. This log entry indicates whether or not a request for a URL was allowed by its `robots.txt` file. If you expect to find an Event but it it was not detected by in Event Data, you can check to see if the request was prevented by a robots.txt rule.

 - `i` - "p001b"
 - `s` - "percolator"
 - `c` - "robot-check"
 - `f` - "result"
 - `a` - The Action ID.
 - `v` - If allowed `t`, otherwise `f`.
 - `u` - The URL requested.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.


### Percolator skipped checking robots.txt file for URL

By default every request to a URL is whitelisted by a robots.txt file. However, under certain circumstances we are allowed to access a URL in contravention to the robots.txt rules. For example, the Wikipedia RESTBase API. This log entry indicates that a web request was made explicitly ignoring the robots.txt rules.

 - `i` - "p001c"
 - `s` - "percolator"
 - `c` - "robot-check"
 - `f` - "skip"
 - `a` - The Action ID.
 - `u` - The URL requested.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

## Any Crossref Agent

### Agent sends Evidence Record

 - `i` - "a0001"
 - `s` - Agent name
 - `c` - "evidence"
 - `f` - "send"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Agent Fails to send Evdience Record

If the Agent can't connect to the internal message bus, it will fail sending data. This will only happen in serious circumstances. If a situation arises whereby it's impossible to send data, this log message may also fail to register. 

 - `i` - "a0040"
 - `s` - Agent Name
 - `c` - "evidence"
 - `f` - "send-error"
 - `r` - The Evidence Record ID

### Agent fetches an Artifact

 - `i` - "a0002"
 - `s` - Agent name
 - `c` - "artifact"
 - `f` - "fetch"
 - `v` - Artifact name
 - `u` - Retrieved version URL that was used.
 - `t` - Timestamp.

## Hypothesis Agent

### Hypothesis Agent makes a request to the Hypothesis API

 - `i` - "a0003"
 - `s` - "hypothesis-agent"
 - `c` - "hypothesis-api"
 - `f` - "request"
 - `v` - Offset query parameter.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Hypothesis Agent gets a response back from the Hypothesis API

 - `i` - "a0004"
 - `s` - "hypothesis-agent"
 - `c` - "hypothesis-api"
 - `f` - "response"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.
 - `e` - HTTP Status code

### Hypothesis Agent gets an error accessing the Hypothesis API

 - `i` - "a0005"
 - `s` - "hypothesis-agent"
 - `c` - "hypothesis-api"
 - `f` - "error"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Hypothesis Agent starts periodic scan

 - `i` - "a0006"
 - `s` - "hypothesis-agent"
 - `c` - "scan"
 - `f` - "start"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Hypothesis Agent completes periodic scan

 - `i` - "a0007"
 - `s` - "hypothesis-agent"
 - `c` - "scan"
 - `f` - "finish"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

## Newsfeed Agent

### Newsfeed Agent parses newsfeed entries from a specific newsfeed

 - `i` - "a0008"
 - `s` - "newsfeed-agent"
 - `c` - "newsfeed"
 - `f` - "parsed-entries"
 - `v` - Number of entries found in Newsfeed.
 - `u` - URL of newsfeed.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Newsfeed Agent retrieves a specific newsfeed

 - `i` - "a0009"
 - `s` - "newsfeed-agent"
 - `c` - "remote-newsfeed"
 - `f` - "request"
 - `u` - URL of newsfeed
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Newsfeed Agent attempts to parse a specific newsfeed

 - `i` - "a000a"
 - `s` - "newsfeed-agent"
 - `c` - "remote-newsfeed"
 - `f` - "parse"
 - `e` - If parsed OK, `t` else `f`.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Newsfeed Agent starts periodic scan of all newsfeeds

 - `i` - "a000c"
 - `s` - "newsfeed-agent"
 - `c` - "scan"
 - `f` - "start"
 - `t` - Timestamp.


### Newsfeed Agent completes periodic scan

 - `i` - "a000d"
 - `s` - "newsfeed-agent"
 - `c` - "scan"
 - `f` - "finish"
 - `t` - Timestamp.

## Reddit Agent

### Reddit Agent authenticates with Reddit API

 - `i` - "a000e"
 - `s` - "reddit-agent"
 - `c` - "reddit-api"
 - `f` - "authenticate"
 - `e` - `t` on success, else `f`
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Reddit Agent makes request to Reddit API

 - `i` - "a0035"
 - `s` - "reddit-agent"
 - `c` - "reddit-api"
 - `f` - "request"
 - `u` - URL queried.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Reddit Agent gets response from Reddit API

 - `i` - "a000f"
 - `s` - "reddit-agent"
 - `c` - "reddit-api"
 - `f` - "response"
 - `u` - URL queried.
 - `e` - HTTP Status.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Reddit Agent gets error connecting to Reddit API

 - `i` - "a0010"
 - `s` - "reddit-agent"
 - `c` - "reddit-api"
 - `f` - "error"
 - `u` - URL queried.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Reddit Agent starts periodic scan of all domains

 - `i` - "a0011"
 - `s` - "reddit-agent"
 - `c` - "scan"
 - `f` - "start"
 - `t` - Timestamp.

### Reddit Agent completes periodic scan

 - `i` - "a0012"
 - `s` - "reddit-agent"
 - `c` - "scan"
 - `f` - "finish"
 - `t` - Timestamp.


## Reddit Links Agent

### Reddit Links Agent authenticates with Reddit API

 - `i` - "a0013"
 - `s` - "reddit-links-agent"
 - `c` - "reddit-api"
 - `f` - "authenticate"
 - `r` - The Evidence Record ID.
 - `e` - `t` on success, else `f`
 - `t` - Timestamp.

### Reddit Links Agent makes request to Reddit API

 - `i` - "a0036"
 - `s` - "reddit-links-agent"
 - `c` - "reddit-api"
 - `f` - "response"
 - `u` - URL queried
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Reddit Links Agent gets response from Reddit API

 - `i` - "a0014"
 - `s` - "reddit-links-agent"
 - `c` - "reddit-api"
 - `f` - "response"
 - `u` - URL queried
 - `e` - HTTP status.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Reddit Links Agent gets error connecting to Reddit API

 - `i` - "a0015"
 - `s` - "reddit-links-agent"
 - `c` - "reddit-api"
 - `f` - "error"
 - `u` - URL queried.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Reddit Links Agent starts periodic scan of known Subreddits in Artifact

 - `i` - "a0016"
 - `s` - "reddit-links-agent"
 - `c` - "scan"
 - `f` - "start"
 - `t` - Timestamp.

### Reddit Links Agent completes periodic scan

 - `i` - "a0017"
 - `s` - "reddit-links-agent"
 - `c` - "scan"
 - `f` - "finish"
 - `t` - Timestamp.

# StackExchange Agent

### StackExchange Agent makes request to list all sites on the StackExchange network

 - `i` - "a0018"
 - `s` - "stackexchange-agent"
 - `c` - "stackexchange-api"
 - `f` - "retrieve-all-sites-request"
 - `u` - URL queried.
 - `p` - Page number.
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### StackExchange Agent gets response listing all sites on the StackExchange network

 - `i` - "a0019"
 - `s` - "stackexchange-agent"
 - `c` - "stackexchange-api"
 - `f` - "retrieve-all-sites-response"
 - `r` - The Evidence Record ID.
 - `e` - HTTP status.
 - `u` - URL queried.
 - `t` - Timestamp.

### StackExchange Agent gets error listing all sites on the StackExchange network

 - `i` - "a0019"
 - `s` - "stackexchange-agent"
 - `c` - "stackexchange-api"
 - `f` - "error"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### StackExchange Agent makes request to StackExchange API to search for a given domain

 - `i` - "a001a"
 - `s` - "stackexchange-agent"
 - `c` - "stackexchange-api"
 - `f` - "search-request"
 - `r` - The Evidence Record ID.
 - `v` - The domain.
 - `p` - Page number
 - `t` - Timestamp.

### StackExchange Agent gets response from StackExchange API searching for given domain

 - `i` - "a001b"
 - `s` - "stackexchange-agent"
 - `c` - "stackexchange-api"
 - `f` - "search-response"
 - `r` - The Evidence Record ID.
 - `e` - HTTP status
 - `v` - The domain.
 - `p` - Page number
 - `t` - Timestamp.

### StackExchange Agent gets error from StackExchange API searching for domain

 - `i` - "a001c"
 - `s` - "stackexchange-agent"
 - `c` - "stackexchange-api"
 - `f` - "search-error"
 - `r` - The Evidence Record ID.
 - `v` - The domain.
 - `p` - Page number
 - `t` - Timestamp.

### StackExchange Agent starts periodic scan of selected sites in the Artifact

 - `i` - "a001d"
 - `s` - "stackexchange-agent"
 - `c` - "scan-selected-sites"
 - `f` - "start"
 - `t` - Timestamp.

### StackExchange Agent completes periodic scan

 - `i` - "a001e"
 - `s` - "stackexchange-agent"
 - `c` - "scan-selected-sites"
 - `f` - "finish"
 - `t` - Timestamp.

### StackExchange Agent starts periodic scan of all sites on the StackExchange network

 - `i` - "a001f"
 - `s` - "stackexchange-agent"
 - `c` - "scan-all-sites"
 - `f` - "start"
 - `t` - Timestamp.

### StackExchange Agent completes periodic scan

 - `i` - "a0020"
 - `s` - "stackexchange-agent"
 - `c` - "scan-all-sites"
 - `f` - "finish"
 - `t` - Timestamp.

## Twitter Agent

### Twitter Agent (re)connects to Twitter streaming API to get stream of input Tweets

Agent will attempt to get tweets from up to 5 minutes ago to fill in any gaps on disconnection.

 - `i` - "a0021"
 - `s` - "twitter-agent"
 - `c` - "twitter-api"
 - `f` - "connect"
 - `t` - Timestamp.

### Twitter Agent was disconnected from Twitter API

 - `i` - "a0022"
 - `s` - "twitter-agent"
 - `c` - "twitter-api"
 - `f` - "disonnect"
 - `t` - Timestamp.

### Twitter Agent starts the process of ingesting Tweets from the Twitter API

 - `i` - "a0023"
 - `s` - "twitter-agent"
 - `c` - "ingest"
 - `f` - "start"
 - `t` - Timestamp.

### Twitter Agent starts the process of processing Tweets from the Twitter API

 - `i` - "a0024"
 - `s` - "twitter-agent"
 - `c` - "process"
 - `f` - "start"
 - `t` - Timestamp.

### Twitter Agent got a chunk of Tweets and bundled them in an Evidence Record

 - `i` - "a0025"
 - `s` - "twitter-agent"
 - `c` - "process"
 - `f` - "got-chunk"
 - `r` - The Evidence Record ID.
 - `v` - Chunk size
 - `t` - Timestamp.

### Twitter agent performed periodic fresh of rules

Agent periodically retrieves the domain list, the DOI Prefix list, and produces a set of rules to send to Twitter. These are used to filter Tweets that are sent to the Agent.

 - `i` - "a0037"
 - `s` - "twitter-agent"
 - `c` - "update-rules"
 - `f` - "start"
 - `t` - Timestamp.

Get domains from "domain-list" Artifact.

 - `i` - "a0038"
 - `s` - "twitter-agent"
 - `c` - "update-rules"
 - `f` - "domain-count"
 - `v` - Number of domains in the Artifact.
 - `t` - Timestamp.

Get DOI prefixes from "doi-prefix" Artifact.

 - `i` - "a0039"
 - `s` - "twitter-agent"
 - `c` - "update-rules"
 - `f` - "prefix-count"
 - `v` - Number of prefixes in the Artifact.
 - `t` - Timestamp.

Combine, compact and produce rules.

 - `i` - "a003a"
 - `s` - "twitter-agent"
 - `c` - "update-rules"
 - `f` - "rule-count"
 - `v` - Number of resulting rules.
 - `t` - Timestamp.

Send the new batch.

 - `i` - "a003b"
 - `s` - "twitter-agent"
 - `c` - "update-rules"
 - `f` - "send-new-rules"
 - `v` - Number of resulting rules.
 - `t` - Timestamp.

Delete the batch that were there before.

 - `i` - "a003c"
 - `s` - "twitter-agent"
 - `c` - "update-rules"
 - `f` - "remove-old-rules"
 - `v` - Number of resulting rules.
 - `t` - Timestamp.

And finish the scan.

 - `i` - "a003d"
 - `s` - "twitter-agent"
 - `c` - "update-rules"
 - `f` - "finish"
 - `t` - Timestamp.

## Wikipedia Agent

### Wikipedia Agent (re)connected to the Wikipedia streaming API.

There is no way to fill-in any missed data during disconnection.

 - `i` - "a0026"
 - `s` - "wikipedia-agent"
 - `c` - "wikipedia-api"
 - `f` - "connect"
 - `t` - Timestamp.

### Wikipedia Agent was disconnected from the Wikipedia streaming API.

 - `i` - "a0027"
 - `s` - "wikipedia-agent"
 - `c` - "wikipedia-api"
 - `f` - "disconnect"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Wikipedia Agent starts (or re-starts) the process of ingesting edits from the API

 - `i` - "a0028"
 - `s` - "wikipedia-agent"
 - `c` - "ingest"
 - `f` - "start"
 - `t` - Timestamp.

### Wikipedia Agent unhandled error ingesting

 - `i` - "a0033"
 - `s` - "wikipedia-agent"
 - `c` - "ingest"
 - `f` - "error"
 - `t` - Timestamp.

### Wikipedia Agent starts the process of processing edits from the API

 - `i` - "a0029"
 - `s` - "wikipedia-agent"
 - `c` - "process"
 - `f` - "start"
 - `t` - Timestamp.

### Wikipedia Agent unhandled error ingesting

 - `i` - "a003f"
 - `s` - "wikipedia-agent"
 - `c` - "ingest"
 - `f` - "error"
 - `t` - Timestamp.

### Wikipedia Agent got a chunk of edits and bundled them into an Evidence Record

 - `i` - "a0030"
 - `s` - "wikipedia-agent"
 - `c` - "process"
 - `f` - "got-chunk"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.
 - `v` - Chunk size

## Wordpress.com Agent

### Wordpress.com Agent starts periodic scan of all known domains

 - `i` - "a0031"
 - `s` - "wordpressdotcom-agent"
 - `c` - "scan-all-sites"
 - `f` - "start"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Wordpress.com Agent completes periodic scan

 - `i` - "a0032"
 - `s` - "wordpressdotcom-agent"
 - `c` - "scan-all-sites"
 - `f` - "finish"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### Wordpress.com Agent made a request to the Wordpress search API

 - `i` - "a0033"
 - `s` - "wordpressdotcom-agent"
 - `c` - "wordpressdotcom-api"
 - `f` - "request"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.
 - `v` - Domain queried.
 - `p` - Page number.
 - `u` - URL queried.

### Wordpress.com Agent got a response from the Wordpress search API

 - `i` - "a0034"
 - `s` - "wordpressdotcom-agent"
 - `c` - "wordpressdotcom-api"
 - `f` - "response"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.
 - `e` - `t` or `f`
 - `v` - Domain queried.
 - `p` - Page number.
 - `u` - URL queried.

## F1000 Agent

### F1000 Agent starts a scan of the F1000 input.

 - `i` - "a0041"
 - `s` - "f1000-agent"
 - `c` - "f1000-dump"
 - `f` - "start"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.

### F1000 Agent finishes its scan of the F1000 input

 - `i` - "a0042"
 - `s` - "f1000-agent"
 - `c` - "f1000-dump"
 - `f` - "finish"
 - `r` - The Evidence Record ID.
 - `t` - Timestamp.


## Event Bus

### Event Bus receives new Event

 - `i` - "b0001"
 - `s` - "event-bus"
 - `c` - "event"
 - `f` - "received"
 - `n` - Event ID.
 - `v` - The Source ID of the Event.
 - `t` - Timestamp.

### Event Bus updates Event

This happens if an Event is updated, for example due to Twitter compliance.

 - `i` - "b0002"
 - `s` - "event-bus"
 - `c` - "event"
 - `f` - "updated"
 - `n` - Event ID.
 - `v` - The Source ID of the Event.
 - `t` - Timestamp.

### Event Bus Heartbeat

 - `i` - "b0003"
 - `s` - "event-bus"
 - `c` - "heartbeat"
 - `f` - "tick"
 - `t` - Timestamp.

# Quality checks

## Archive Integrity Check

### Check started

 - `i` - "q0001"
 - `s` - "quality"
 - `c` - "archive-query-integrity"
 - `f` - "start"
 - `t` - Timestamp

### Check finished

 - `i` - "q0002"
 - `s` - "quality"
 - `c` - "archive-query-integrity"
 - `f` - "finish"
 - `t` - Timestamp

### Events are missing in the Query API (compared to the Archive)

 - `i` - "q0003"
 - `s` - "quality"
 - `c` - "archive-query-integrity"
 - `f` - "missing-from-query"
 - `p` - Date of Events in question
 - `v` - Number of Events missing
 - `e` - Result - "f" if there are missing Events, otherwise "t"
 - `t` - Timestamp

### Events are missing in the Archive (compared to the Query API)

 - `i` - "q0004"
 - `s` - "quality"
 - `c` - "archive-query-integrity"
 - `f` - "missing-from-archive"
 - `p` - Date of Events in question
 - `v` - Number of Events missing
 - `e` - Result - "f" if there are missing Events, otherwise "t"
 - `t` - Timestamp

## Evidence Log Check

### Check for presence of Evidence Log dump for day

 - `i` - "q0005"
 - `s` - "quality"
 - `c` - "evidence-log"
 - `f` - "check"
 - `p` - Date of the log snapshot in question
 - `t` - Timestamp

### CSV dump present

 - `i` - "q0006"
 - `s` - "quality"
 - `c` - "evidence-log"
 - `f` - "csv-present"
 - `p` - Date of the log snapshot in question
 - `e` - Result - "t" if the file is present.
 - `t` - Timestamp

### JSON dump present

 - `i` - "q0007"
 - `s` - "quality"
 - `c` - "evidence-log"
 - `f` - "json-present"
 - `p` - Date of the log snapshot in question
 - `e` - Result - "t" if the file is present.
 - `t` - Timestamp

## Twitter Compliance Check

### Twitter compliance check started for Events on date

 - `i` - "q0009"
 - `s` - "quality"
 - `c` - "twitter-compliance-scan"
 - `f` - "start"
 - `p` - Date of the Eventss in question
 - `v` - 
 - `t` - Timestamp

### Twitter compliance check started for Events on date

 - `i` - "q000a"
 - `s` - "quality"
 - `c` - "twitter-compliance-scan"
 - `f` - "finish"
 - `p` - Date of the Eventss in question
 - `v` - Number of Events that were deleted
 - `t` - Timestamp

