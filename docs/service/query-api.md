# Query API

The [Quick Start guide](quickstart) shows you how to get your hands dirty quickly. Come back and read this section afterwards!

In most cases you will want to retrieve a large batch of Events so you can perform further processing on them. The Query API provides access to all Events, with filters to restrict the results based on source, date-range, DOI etc. 

## Query Parameters

The following query parameters are available:

 - `rows` — the number of Events you want to retrieve per page. The default, and recommended, value is 10,000, which allows you to retrieve large numbers of Events quickly. There are typically between 10,000 and 100,000 Events collected per day.
 - `filter` — supply a filter that allows you to restrict results.
 - `cursor` — allows you to iterate through a search result set.
 - `from-updated-date` — a special filter that includes updated and deleted Events, to allow you to keep your dataset up to date.

## Filter parameters

The `filter` parameter takes a `field:value,other-field:other-value` format, using colon (`:`) to separate keys and values and commas (`,`) to separate clauses. You can put keys or values in quotes if they contain colons, for example `subj-id:"http://example.com"`. The following fields are available. They can be used in any combination.

  - `from-occurred-date ` - as YYYY-MM-DD
  - `until-occurred-date ` - as YYYY-MM-DD
  - `from-collected-date` - as YYYY-MM-DD
  - `until-collected-date` - as YYYY-MM-DD
  - `subj-id` - quoted URL or a DOI
  - `obj-id` - quoted URL or a DOI
  - `subj-id.prefix` - DOI prefix like 10.5555
  - `obj-id.prefix` - DOI prefix like 10.5555
  - `subj-id.domain` - domain of the subj_id e.g. en.wikipedia.org
  - `obj-id.domain` - domain of the subj_id e.g. en.wikipedia.org
  - `subj.url` - quoted full URL
  - `obj.url` - quoted full URL
  - `subj.url.domain` - domain of the optional subj.url, if present e.g. en.wikipedia.org
  - `obj.url.domain` - domain of the optional obj.url, if present e.g. en.wikipedia.org
  - `subj.alternative-id` - optional subj.alternative-id
  - `obj.alternative-id` - optional obj.alternative-id
  - `relation` - relation type ID
  - `source` - source ID

## Navigating results

Every API response includes a `cursor` field. If this is not `null`, you should append that cursor value to query to fetch the next page of results. Once you have fetched all results the returned cursor value will be `null`.

The total number of results matched by the query is also returned.

The order or Events returned in the result is not defined, but is stable. This means that if you iterate over a result set using the cursor you will retrieve all results for that query.

## Example queries

Ten Events from the Reddit source:

    http://query.eventdata.crossref.org/events?rows=10&filter=source:reddit

Ten Events collected on the first of March 2017

    http://query.eventdata.crossref.org/events?rows=10&filter=from-collected-date:2017-03-01,until-collected-date:2017-03-01

Ten Events collected in the month of March 2017

    http://query.eventdata.crossref.org/events?rows=10&filter=from-collected-date:2017-03-01,until-collected-date:2017-03-31

Ten Events that occurred on or after the 10th of March 2017

    http://query.eventdata.crossref.org/events?rows=10&filter=from-occurred-date:2017-03-10

Ten Events for the DOI https://doi.org/10.1186/s13006-016-0076-7

    http://query.eventdata.crossref.org/events?rows=10&filter=work:10.1186/s13006-016-0076-7

Ten Events for the DOI prefix 10.1186

    http://query.eventdata.crossref.org/events?rows=10&filter=prefix:10.1186

All Events ever! Note that you will need to use the cursor to iterate through the result set.

    http://query.eventdata.crossref.org/events?rows=10000

Using the cursor returned from the first page (yours may be different) 

    http://query.eventdata.crossref.org/events?rows=10000&cursor=17399fd9-319d-4b28-9727-887264a632b1

## Keeping up to date

Events can be marked as deleted or edited, as described in the [updates](../data/updates) page. By default the Query API won't serve Events that have been marked as deleted. 

If you want to check whether not not events have been updated (edited or deleted) you should supply the `from-updated-date` in `YYYY-MM-DD` format. The API will return only those Events that were updated on or after that day, **including those that were deleted**.

For example, on the 2nd of February 2017 you retrieve events from Twitter:

    http://query.eventdata.crossref.org/events?rows=10&filter=source:twitter

You store the Events. One month later, you re-query for any Events that were updated since you last queried:

    http://query.eventdata.crossref.org/events?rows=10&filter=source:twitter&from-update-date:2017-02-02

**We only edit Events when we absolutely need to** and the Query API will usually send an empty reply, confirming that you don't need to update your data. If it does, you should over-write your stored Events with the new ones. 

**If you retrieve Events and store them, you should regularly check up to see if they have been updated.** We don't anticipate this will happen very often, but when it does happen, it is important that you stay up-to-date. See the Best Practice section for guidance.

### Updates and Evidence

Every Evidence Record that results in an Event will contain a copy of that Event (minus the timestamp, which is applied later). If an update is made to an Event, it will not be recorded in the original Event Record.
