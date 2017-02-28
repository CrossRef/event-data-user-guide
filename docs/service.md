# The Service

Crossref Event Data is a system for collecting Events and distributing them. The Query API delivers batches of Events based on queries, rather than individual events. Tens of thousands of events Events occur per day, of the order of one per second, though the rate fluctuates depending on the activity of the Agents and the underlying patterns in the source. 

 - The Query API provides an interface for accessing Events. It's a REST API that allows download of Events and supports various filters. 

 - Every Event that Crossref produces has an Evidence Record. These are available via the Evidence Service. It provides supporting evidence for every Event.

 - Every component in the CED system, internal and external, monitored. The Status Service monitors all data flowing into the system, all parts of the processing pipeline, and the delivery mechanisms. It records the availability and activity of components and completeness of data.

## Versions

The current version of the service as whole is the same as the version of this User Guide. Each component of the Service, for example the Query API and the various Agents that collect data, have versions, and you can check the currently running version using the Evidence Service.

<a name="data-sources"></a>
## Data Sources

Event Data is a hub for the collection and distribution of Events and contains data from a selection of Data Sources. 

| Name                   | Source Identifier   | Provider    | What does it contain? |
|------------------------|---------------------|-------------|------------------|
| Crossref to DataCite   | crossref_datacite   | Crossref    | Dataset citations from Crossref Items to DataCite Items |
| Newsfeed               | newsfeed            | Crossref    | Mentions of Items on blogs and websites with syndication feeds |
| Reddit                 | reddit              | Crossref    | Mentions and discussions of Items on Reddit |
| Twitter                | twitter             | Crossref    | Mentions of Items on Twitter |
| Wikipedia              | wikipedia           | Crossref    | References of Items on Wikipedia |
| Wordpress.com          | wordpressdotcom     | Crossref    | References of Items on Wordpress.com blogs |
| DataCite to Crossref   | datacite_crossref   | DataCite    | Dataset citations from DataCite Items to Crossref Items |

For detailed discussion of each one, see the [Sources In Depth](sources-in-depth) section.

## Query API

Event Data presents a stream of Events. They can be accessed through the Query API, which allows you to retrieve a slice of data. The Query API is a simple JSON REST API. Because of the volume of Events, every query is paginated by a date, in `YYYY-MM-DD` format. Even when scoped to a particular day, there can be tens of thousands of Events. Therefore there are a number of filters available to help you narrow down what you're looking for.

When you write a client to work with the API it should be able to deal with responses in the tens of megabytes, preferably dealing with them as a stream. You may find that saving an API response directly to disk is sensible.

### Timing and Freshness

As detailed in [Occurred-at vs collected-at](concepts#concept-timescales), every Event has a 'occurred at' timestamp, but may be collected at a different time. The Query API therefore provides two views of time: `collected` and `occurred`.

You may want to use `collected` when:

 - you want to run a daily query to fetch *all* Events in the system to build your own copy of the complete database
 - you want to be sure that you get all of the data
 - you only want to know about each event once
 - you're not interested in a particular time-range in which Events might have occurred
 - you want to reference or cite a dataset that never changes

You may want to use `occurred` when:

 - you're interested in a particular time period when you think Events occurred
 - you are happy to re-issue queries for the given date-range (because Events may have subsequently been collected for that period)


The API base is therefore one of:

  - `http://query.eventdata.crossref.org/occurred/`
  - `http://query.eventdata.crossref.org/collected/`

All queries are available on both views.

The Query API is updated once a day. This means that from the time an Event is first collected to the time when it is available on the Query API can be up to 24 hours. Once a `collected` result is available it should never change, but `occurred` results can.

### Available Queries

<!-- TODO REAL WORKING QUERIES
 -->
<a name="quick-start" id="quick-start"></a>

#### All data for a day

    http://query.eventdata.crossref.org/«view»/«date»/events.json

e.g.

    http://query.eventdata.crossref.org/collected/2017-02-23/events.json

#### All data for a particular source for a day

    http://query.eventdata.crossref.org/«view»/«date»/sources/«source»/events.json

e.g.

    http://query.eventdata.crossref.org/collected/2017-02-23/sources/reddit/events.json

#### All data for a DOI for a day

    http://query.eventdata.crossref.org/«view»/«date»/works/«doi»/events.json

e.g.

    http://query.eventdata.crossref.org/collected/2017-02-23/works/10.3389/FNINS.2015.00404/events.json

#### All data for a DOI for a day for a given source

    http://query.eventdata.crossref.org/«view»/«date»/works/«doi»/sources/«source»/events.json

e.g.

    http://query.eventdata.crossref.org/collected/2016-11-01/sources/wikipedia/works/10.3389/FNINS.2015.00404/events.json

### Querying a Date Range

If you want to collect all Events for a given date range, you can issue a set of queries. E.g. to get all Wikipedia Events in November 2016, issue the following API query:

<!-- TODO WORKING QUERY -->

`http://query.eventdata.crossref.org/occurred/2016-11-01/sources/reddit/events.json`

The response contains the 'next date' link:

    meta: {
      status: "ok",
      message-type: "event-list",
      total: 77,
      total-pages: 1,
      page: 1,
      previous: "http://query.eventdata.crossref.org/collected/2016-10-31/sources/reddit/events.json",
      next: "http://query.eventdata.crossref.org/collected/2016-11-02/sources/reddit/events.json"
    }

Follow the 'next' link until you have all the data you want.

Note that this is a form of pagination, which is a standard feature of REST APIs. You can find code examples in the [Code Examples](#appendix-code-examples) section.

### Format of Event Records

The response from the Query API will be a list of Events. An Event is of the form 'this subject has this relation to this object'. The most up-to-date list of supported relations is available in [Lagotto](https://github.com/lagotto/lagotto/blob/master/db/seeds/production/relation_types.yml), but the documentation for each Source in this document lists all relation types that the Source produces.

A sample Event can be read:

 - a Work with the DOI `https://doi.org/10.1090/bull/1556`
 - was `discussed`
 - in the comment `https://reddit.com/r/math/comments/572xbh/five_stages_of_accepting_constructive_mathematics/ `
 - on `reddit`
 - the title of the discussion is `"Five stages of accepting constructive mathematics, by Andrej Bauer [abstract + link to PDF]"`
 - the post was made at `2016-10-12T07:20:40.000Z`
 - and was collected / processed at `2017-20-20T07:20:40.000Z`
 - the ID of the Event is `615cf92e-9922-4868-9b62-a51b8efd29ee`
 - by looking at the `subj`, we can see that the article was referenced using its Article Landing page `http://www.ams.org/journals/bull/0000-000-00/S0273-0979-2016-01556-4/home.html` rather than the DOI in this case.
 - you can visit `https://evidence.eventdata.crossref.org/evidence/2017022284421dfd-ddbe-4730-bc35-caf11d92231f` to find out more about how the Event was extracted.

It looks like:

    {
      "obj_id": "https://doi.org/10.1090/bull/1556",
      "source_token": "a6c9d511-9239-4de8-a266-b013f5bd8764",
      "occurred_at": "2016-10-12T07:20:40.000Z",
      "subj_id": "https://reddit.com/r/math/comments/572xbh/five_stages_of_accepting_constructive_mathematics/",
      "id": "615cf92e-9922-4868-9b62-a51b8efd29ee",
      "action": "add",
      "subj": {
        "pid": "https://reddit.com/r/math/comments/572xbh/five_stages_of_accepting_constructive_mathematics/",
        "type": "post",
        "title": "Five stages of accepting constructive mathematics, by Andrej Bauer [abstract + link to PDF]",
        "issued": "2016-10-12T07:20:40.000Z"
      },
      "source_id": "reddit",
      "obj": {
        "pid": "https://doi.org/10.1090/bull/1556",
        "url": "http://www.ams.org/journals/bull/0000-000-00/S0273-0979-2016-01556-4/home.html"
      },
      "evidence-record": "https://evidence.eventdata.crossref.org/evidence/2017022284421dfd-ddbe-4730-bc35-caf11d92231f",
      "relation_type_id": "discusses",
      "timestamp": "2017-20-20T07:20:40.000Z"
    }
   

The following fields are available:

 - `subj_id` - the subject of the relation as a URI, in this case a discussion on Reddit. This is normalized to use the `https://doi.org` DOI resolver and converted to upper case.
 - `relation_type_id` - the type of relation.
 - `obj_id` - the object of the relation as a URI, in this case a DOI.
 - `occurred_at` - the date and time when the Event occurred.
 - `id` - the unique ID of the event. This is used to identify the event in Event Data. Is used to trace Evidence for an Event. 
 - `message-action` - what action does this represent? Can be `create` or `delete`. There are currently no sources that use `delete`.
 - `source_id` - the ID of the source as listed in [Data Sources](service#data-sources).
 - `subj` - the subject metadata, optional. Depends on the Source.
 - `obj` - the object metadata, optional. Depends on the Source.
 - `total` - the pre-aggregated total that this represents, if this is from a pre-aggregated source such as Facebook. Usually 1. See [Individual Events vs Pre-Aggregated](concepts#concept-individual-aggregated).
 - `timestamp`- the date and time at which the Event was processed by Event Data.
 - `evidence-record` - a link to a document that describes how this Event was generated

All times in the API in ISO8601 UTC Zulu format.

See [Event Records in Depth](events-in-depth) for more detail on precisely what the fields of an Event mean under various circumstances.

## Evidence Registry

The Evidence Registry stores all the Evidence that supports Events collected by Crossref. Other partners who share information via CED may not include Evidence Records. You can find a full discussion of Evidence in the [Evidence In Depth](evidence-in-depth) section.

An Evidence Record generally corresponds to a single input or batch of inputs that came from an external API. For example:

 - there is one Record per queried domain from the Reddit API
 - Tweets are collected into small batches

An Evidence Record may correspond to more than one Event. One Event is linked only to one Evidence Record. CED may contain Events for which there is no Evidence, where the Event was provided by an external party. Likewise, if some data was processed and we could not extract Events from it, there will be an Evidence Record with no Events.

### Format of Evidence Records

An Evidence Record is a JSON document and it follows a familiar format:

An Evidence Record comes from a single Agent, so it includes identifying fields:

 - `source-token`: a token that uniquely identifies the Agent
 - `source-id`: the source that identifies where the data ultimately came from
 - `agent`: supplementary information about the Agent, such as its version number and the Artifacts that it consumed to produce this Record

An Evidence Record also contains Actions. An example of an Action:

 - a comment was posted on Reddit
 - a Tweet was published
 - an edit was made to a Wikipedia page

An Action contains information about the thing that happened. This corresponds to the *Subject* of an Event.

 - the URL of the Subject (comment, tweet or page)
 - the relation type that the subject has to anything that we found in it. E.g. a Wikipedia page always `references`, a Tweet always `discusses`
 - the time that the Action is reported to have occurred
 - metadata about the Subject, such as the title

An Action also comes with Observations. Because there are a diverse range of types of input data in CED, different observations can be made. For example:

 - a Tweet has text content, in which we want to look for links and possibly convert into DOIs
 - Tweet also has a list of URLs, which we want to possibly convert into DOIs
 - a Newsfeed item from an RSS feed as a URL to the blog, which we want to visit and look for links
 - a Reddit discussion has one URL, which want to possibly convert into a DOI

An Action may have zero or more Observations. For example, a Tweet will have text content, but also a number of links. Sometimes we have to remove the actual input from the Evidence Record, but when we do, the `sensitive` flag is set to `true` and a hash of the message content is included. You are welcome to follow the URL to retrieve the content yourself and compare the hash.

Every Action also has an ID, which is calculated differently for each source. If the same Action is reported twice (e.g. duplicate data is sent from an upstream API), the `duplicate` field will be set on the Action, showing a link to the previous Evidence Record where the action occurred. When a Duplicate Action happens, no Events are extracted.

Note that this is not a guarantee that the same 'thing' may be observed in different Events. It is possible that two Agents independenly see the same thing and report on it. If, for example, a Reddit page appeared in an RSS feed, it might be picked up by both the Reddit and the Newsfeed agents, producing two Events. In each case, the Agent, source ID, and supporting Evidence Record would be different, and describe the process by which the Event came into being.

Actions are collected together into pages of lists of Actions. This model suits all Agents:

 - the Reddit API responds to a query with pages of results. Each API page corresponds to a page in the Evidence Record.
 - the Twitter agent always sends a single page containing a batch of Tweet Actions.

Finally, there are always little bits of extra information that come from sources that it's useful to have. The Evidence Record, Page and Action objects can all have an `extra` field to accommodate these.

When Events are succesfully extracted, they are included along with the Action that gave rise to them. They are then sent through the Event Data system for you to consume.

Event Data Agents spend a lot of time visiting webpages. Every Evidence Record contains a log of all of the URLs that were visited, and the HTTP status codes that were received. If you see an inconsistency in the processing of an Event Record, you can look at the log to see if it was caused by an external URL timing out, blocking the agent etc.


<!-- TODO DIAGRAM -->

### Example Evidence Record

Here is an example Evidence Record, adapted from [a real one in the API](https://evidence.eventdata.crossref.org/evidence/2017022284421dfd-ddbe-4730-bc35-caf11d92231f). As Evidence Records can be quite long, some lines were removed.

    
    {
      "source-token": "a6c9d511-9239-4de8-a266-b013f5bd8764",

The Crossref Reddit Agent identifies itself
      
      "extra": {
        "cutoff-date": "1948-09-12T16:14:51.795Z",
        "queried-domain": "www.ams.org"
      },
      
A bit of information about this Record specific to Reddit. It is looking for Events between now and 1948. This shows that it was performing a back-fill scan. Usually this will be a few hours into the past. It also shows that it was querying for the `www.ams.org` domain.
      
      "agent": {
        "version": "0.1.4",
        "artifacts": {
          "domain-set-artifact-version": "http://d1v52iseus4yyg.cloudfront.net/a/domain-list/versions/1487256359032"
        }
      },
      
The Agent also describes itself and tells us what version of the `domain-set` Artifact it was scanning through at the time. Looking at this, we know exactly which version of the list of domains it was working from.
      
      "pages": [

Previous pages have been snipped from this example.
      
        {
          "url": "https://oauth.reddit.com/domain/www.ams.org/new.json?sort=new&after=t3_3bgzfz",

This page was taken from this URL. Note that the `after` field, which is specific to the Reddit API, shows that we're mid pagination.
          
          "extra": {
            "after": "t3_4gcy84"
          },
          
The `after` field is included as a bit of extra information about this page.
          
          "actions": [
          
The list of Actions in this page corresponds to the list of items in the Reddit API response.

            {
              "occurred-at": "2011-01-12T06:07:04.000Z",

One Observation was made about this Action.

              "processed-observations": [
                {
                  "type": "url",
                  "input-url": "http://www.ams.org/journals/bull/2005-42-02/S0273-0979-05-01048-7/S0273-0979-05-01048-7.pdf",
                  
It turns out that the observation looks like a Landing Page URL, so one candidate is generated.

                  "candidates": [
                    {
                      "type": "landing-page-url",
                      "value": "http://www.ams.org/journals/bull/2005-42-02/S0273-0979-05-01048-7/S0273-0979-05-01048-7.pdf"
                    }
                  ]
                }
              ],
              "matches": [],
              
Sadly it was not possible to match any Candidates to DOIs.
              
              "events": [],
              
So no Events were generated this time. Better luck next time.
              
              "extra": {
                "subreddit": "puremathematics"
              },
              
Extra information about this Action is that it came from this subreddit.
              
              "id": "027d96141854aedb2ec0ac76d40f28b68d32b275",

The Action was given this ID, based on the ID of the Reddit conversation. If it is reported again, it will be marked as a duplicate.
              
              "url": "https://reddit.com/r/puremathematics/comments/f0qcn/immersion_theory_in_topology_pdf/",
              "subj": {
                "type": "post",
                "title": "Immersion Theory in Topology (pdf)",
                "issued": "2011-01-12T06:07:04.000Z"
              },
              
Extra information about the Reddit conversation.
              
              "relation-type-id": "discusses"
            },
            
Now we come to another Action. This time we were able to get Events!
            
            {
              "occurred-at": "2011-01-03T16:18:07.000Z",
              "processed-observations": [
                {
                  "type": "url",
                  "input-url": "http://www.ams.org/journals/bull/2008-45-04/S0273-0979-08-01223-8/home.html",
                  "candidates": [
                    {
                      "type": "landing-page-url",
                      "value": "http://www.ams.org/journals/bull/2008-45-04/S0273-0979-08-01223-8/home.html"
                    }
                  ]
                }
              ],

Another Article Landing Page URL observation, with a Candidate.

              "matches": [
                {
                  "type": "landing-page-url",
                  "value": "http://www.ams.org/journals/bull/2008-45-04/S0273-0979-08-01223-8/home.html",
                  "match": "https://doi.org/10.1090/s0273-0979-08-01223-8"
                }
              ],

The Agent was able to successfully match the candidate Article Landing Page to a DOI! Therefore the following Event was created.
              
              "events": [
                {
                  "obj_id": "https://doi.org/10.1090/s0273-0979-08-01223-8",
                  
The Object is the article being discussed.
                  
                  "source_token": "a6c9d511-9239-4de8-a266-b013f5bd8764",
        
The Source Token identifies the Agent.
                  
                  "occurred_at": "2011-01-03T16:18:07.000Z",
                  
The Subject was published at this time according to Reddit.

                  "subj_id": "https://reddit.com/r/math/comments/evgru/the_lord_of_the_numbers_atle_selberg_19172007_a/",
                  
The Subject is the Reddit comment at this URL.
                  
                  "id": "e5f8132e-9ae8-4fd9-ac61-56e47eff9fc2",
                  
The Event has a unique ID. This is different to the Action ID (after all, one Action could give rise to several Events).

                  "action": "add",
                  "subj": {
                    "pid": "https://reddit.com/r/math/comments/evgru/the_lord_of_the_numbers_atle_selberg_19172007_a/",
                    "type": "post",
                    "title": "The Lord of the Numbers, Atle Selberg (1917-2007).  A short description of his life and work and interview with the mathematical giant.",
                    "issued": "2011-01-03T16:18:07.000Z"
                  },

Subject metadata is included.

                  "source_id": "reddit",
                  "obj": {
                    "pid": "https://doi.org/10.1090/s0273-0979-08-01223-8",
                    "url": "http://www.ams.org/journals/bull/2008-45-04/S0273-0979-08-01223-8/home.html"
                  },
                  
Note that the Article is referred to by its DOI in the `obj_id` and `obj.pid` field (Persistent IDentifier), as all pieces of Registered Content are in CED. However, the URL field demonstrates that we actually found a link to the Article via its landing page.
                  
                  "evidence-record": "https://evidence.eventdata.crossref.org/evidence/2017022284421dfd-ddbe-4730-bc35-caf11d92231f",
                  
The Event will have a link back to the Evidence Record (this document) so you can read all about its journey.
                  
                  "relation_type_id": "discusses"
                }
              ], 
              
Now we're back to the Action, including some of the data that went on to be included in the Event.
                           
              "extra": {
                "subreddit": "math"
              },
              "id": "24e85e455fbee43299a5d4a39f5106d1b1dfafb3",
              "url": "https://reddit.com/r/math/comments/evgru/the_lord_of_the_numbers_atle_selberg_19172007_a/",
              "subj": {
                "type": "post",
                "title": "The Lord of the Numbers, Atle Selberg (1917-2007).  A short description of his life and work and interview with the mathematical giant.",
                "issued": "2011-01-03T16:18:07.000Z"
              },
              "relation-type-id": "discusses"
            }
          ]
        }
      ],
      
The Percolator is the component that does the work of building the Evidence Record and extracting all the Events. You should treat it as 'part of the agent'. It is common to all Crossref Event Data Agents. Here it includes some data of its own: the version number of the Percolator software, and the version of the Artifact it used to convert article landing pages back to DOIs.
      
      "percolator": {
        "artifacts": {
          "domain-set-artifact-version": "http://d1v52iseus4yyg.cloudfront.net/a/crossref-domain-list/versions/1482489046417"
        },
        "software-version": "0.1.4"
      },
      "id": "2017022284421dfd-ddbe-4730-bc35-caf11d92231f",
      
The ID of this Action, for de-duplication purposes.
      
      "url": "https://evidence.eventdata.crossref.org/evidence/2017022284421dfd-ddbe-4730-bc35-caf11d92231f",
      
The URL where this Evidence Record will live.
      
      "source-id": "reddit",
    
Every URL visited in the process of building this Event.
      
      "web-trace": [
        {
          "url": "https://www.ams.org/open-math-notes?utm_content=bufferf6d9f&amp;utm_medium=social&amp;utm_source=facebook.com&amp;utm_campaign=buffer",
          "error": "unknown-error"
        },
        
This URL timed out, or the connection was reset.
        
        {
          "url": "http://www.ams.org/journals/bull/2008-45-04/S0273-0979-08-01223-8/home.html",
          "status": 200
        }

This one returned the `200 OK` status.
        
      ],
      "timestamp": "2017-02-22T16:17:17.582Z"
    }


### Getting Evidence Records

If an Event has an Evidence Record, it will be included in the `evidence-record` field. Follow this URL to retrieve the Evidence Record from the Evdience Registry.

## Status Service

*This feature will be available at launch.*

Event Data connects to external systems and gathers data from them through a pipeline. Not all external services are available all the time, and some may experience fluctuations in service. The internal pipeline with the Event Data service may become congested or require maintenance from time to time. 

The Event Data Status Service proactively monitors all parts of the system and reports on activity, availability and completeness of data. The Dashboard will be available via a user interface and via an API through which users can access historical data.
