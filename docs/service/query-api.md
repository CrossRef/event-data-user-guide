# Query API

The [Quick Start guide](quickstart) shows you how to get your hands dirty quickly. Come back and read this section afterwards!

CED has Events, and lots of them. Usually you'll be interested in getting all Events from a particular source, or range of DOIs, over a period of time. The Query API answers queries like:

 - give me all Events that were collected in this date range
 - give me all Events from Reddit
 - give me all Events that concern a DOI with this prefix
 - give me all Events ever

The Query API is a simple JSON REST API. Because of the volume of Events (we collect tens of thousands of Events per day), every query is paginated by a date, in `YYYY-MM-DD` format. There are a number of filters available to help you narrow down the results.

When you write a client to work with the API it should be able to deal with responses in the tens of megabytes, preferably dealing with them as a stream. You may find that saving an API response directly to disk is sensible.

### Two points of view

Every Event ocurred at point in time, and was collected at a different point in time. Both of these dates are useful to you. You can read about this in more depth in [Occurred-at vs collected-at](concepts#concept-timescales). The Query API therefore provides two **views**: `collected` and `occurred`.

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

  - `https://query.eventdata.crossref.org/occurred/`
  - `https://query.eventdata.crossref.org/collected/`

All queries are available on both views.

The Query API is updated once a day, shortly after midnight. This means that from the time an Event is first collected to the time when it is available on the Query API can be up to 24 hours. Once a `collected` result is available it should never change, but `occurred` results can.

## Available Queries

<!-- TODO REAL WORKING QUERIES
 -->
<a name="quick-start" id="quick-start"></a>

### All data for a day

    https://query.eventdata.crossref.org/«view»/«date»/events.json

### All data for a particular source for a day

    https://query.eventdata.crossref.org/«view»/«date»/sources/«source»/events.json

### All data for a particular DOI prefix for a day

    https://query.eventdata.crossref.org/«view»/«date»/prefix/«prefix»/events.json

### All data for a DOI for a day

The Query API returns all Events that have the given DOI as a subject or object of the Event.

    https://query.eventdata.crossref.org/«view»/«date»/works/«doi»/events.json

### All data for a DOI for a day for a given source

    https://query.eventdata.crossref.org/«view»/«date»/works/«doi»/sources/«source»/events.json

## Querying a Date Range

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

## Format of Event Records

The response from the Query API will be a list of Events. An Event is of the form 'this subject has this relation to this object'. All Events conform to the Event Data Schema, but every Agent produces slightly different Events. See [Events in Depth](/events-in-depth) for detail, and the individual Agents' documentation for source-specific information.

## Keeping up to date

Events are never *removed* from the system, but they are sometimes updated. For example, if an Agent has a bug that generates Events with invalid DOIs, and we are able to clean them up and mark the Events as edited, we will update those Events. If it generates non-existent DOIs, we may mark those Events as deleted. If a user deletes a Tweet that's referenced from an Event, we will erase the tweet and author ID from the Event, leaving the rest untouched, and mark it as deleted.

If an Event is updated, three fields will be set:

 - `updated` - will have a value of `deleted` or `edited`
 - `updated-reason` - optional, may point to an announcement page explaining the edit
 - `updated-date` - ISO8601 date string for when the event was updated.

By default, the Query API **will not** serve Events that have been already been `deleted`, but **will** serve Events that have been `edited`.

### Checking up

The `updated-since` parameter accepts a date in `YYYY-MM-DD` format. It will serve up Events that have been updated since, including, that date.

For example, on the 2nd of February 2017 you retrieve events for the day before:

    https://query.eventdata.crossref.org/collected/2017-01-02/events.json

You store the events. One month later, you re-query for any Events that were updated since you last queried:

    https://query.eventdata.crossref.org/collected/2017-01-02/events.json?updated-since=2017-01-02

**Events are only edited in exceptional circumstances** and the Query API will usually send an empty reply, confirming that you don't need to update your data. If it does, you should over-write your stored Events with the new ones. 

**If you retrieve Events and store them, you should regularly check up to see if they have been updated.** We don't anticipate this will happen very often, but when it does happen, it is important that you stay up-to-date. See the Best Practice section for guidance.

### Editing and Evidence

Every Evidence Record that results in an Event will contain a copy of that Event (minus the timestamp, which is applied later). If an update is made to an Event, it will not be recorded in the original Event Record.
