# Query API

The [Quick Start guide](quickstart) shows you how to get your hands dirty quickly. Come back and read this section afterwards!

In most cases you will want to retrieve a large batch of Events so you can perform further processing on them. The Query API provides access to all Events, with filters to restrict the results based on source, date-range, DOI etc. 

## Query parameters

The following query parameters are control how you retrieve the data:

 - `rows` — the number of Events you want to retrieve per page. The default, and recommended, value is 10,000, which allows you to retrieve large numbers of Events quickly. There are typically between 10,000 and 100,000 Events collected per day.
 - `cursor` — allows you to iterate through a search result set.

The following can be used to filter Events:

  - `from-occurred-date ` - as YYYY-MM-DD
  - `until-occurred-date ` - as YYYY-MM-DD
  - `from-collected-date` - as YYYY-MM-DD
  - `until-collected-date` - as YYYY-MM-DD
  - `from-updated-date` - as YYYY-MM-DD
  - `until-updated-date` - as YYYY-MM-DD
  - `subj-id` - quoted URL or a DOI
  - `obj-id` - quoted URL or a DOI
  - `subj-id.prefix` - DOI prefix like 10.5555, if Subject is a DOI
  - `obj-id.prefix` - DOI prefix like 10.5555, if Object is a DOI
  - `subj-id.domain` - domain of the subj_id e.g. en.wikipedia.org
  - `obj-id.domain` - domain of the obj_url e.g. en.wikipedia.org
  - `subj.url` - quoted full URL
  - `obj.url` - quoted full URL
  - `subj.url.domain` - domain of the optional subj.url, if present e.g. en.wikipedia.org
  - `obj.url.domain` - domain of the optional obj.url, if present e.g. en.wikipedia.org
  - `subj.alternative-id` - optional subj.alternative-id
  - `obj.alternative-id` - optional obj.alternative-id
  - `relation-type` - relation type ID
  - `source` - source ID

## Tell us who you are

Please also send the `mailto` query parameter. **It is not compulsory**, but will help us understand how people are using the API and get in contact if we need to. We won't share your email address, and will only contact you in connection with API use. For example: 

    https://api.eventdata.crossref.org/v1/events?mailto=example@example.org&obj-id=10.5555/12345678

If you are uncomfortable sending a contact email address, you don't have to. You can [read more about the rationale here](https://github.com/CrossRef/rest-api-doc#etiquette). 

## Facets

Facets allow you to view a breakdown of the results that match your query. Using facets, you can answer questions like "of the search results, how many came from each source" or "of the search results, what were the top domains?". Facets can help you understand search results and to guide further investigation.

**The numbers that are returned are approximate not exact** and you should be careful what you do with them. Bear in mind, for example, that the same link may be observed more than once at different points in time. Facets represent "this many Events" not necessarily "this many links".

The following facets are available.

 - `source` - Source ID
 - `relation-type` - Relation type ID
 - `obj-id.prefix` - DOI prefix like 10.5555, if Object is a DOI
 - `subj-id.prefix` - DOI prefix like 10.5555, if Subject is a DOI
 - `subj-id.domain` - Domain of the `subj_id` URL
 - `obj-id.domain` - Domain of the `obj_id` URL
 - `subj.url.domain` - Domain of the `subj.url` URL. This may or may not be the same as the `subj_id`.
 - `obj.url.domain` - Domain of the `obj.url` URL. This may or may not be the same as the `obj_id`.

Each facet should be supplied with a limit (i.e. the top <i>n</i> results) or `*`, which is the maximum number supported. The syntax of a facet is `«facet»:«limit»`. For example

 - `source:*` means "show me the breakdown by source, up to the limit".
 - `subj-id.domain:*` means "show me the breakdown by the subject's domain name, up to the limit".
 - `subj-id.domain:10` means "show me the top 10 subj-id domains".

You many use any combination of facets, separated by commas. The following query means "show me the top 10 domains found in Events for the Newsfeed source":

    https://api.eventdata.crossref.org/v1/events?mailto=YOUR_EMAIL_HERE&rows=0&source=newsfeed&facet=subj-id.domain:10

The result, at the time of writing, includes:

    facets: {
      subj-id-domain: {
        value-count: 10,
        values: {
          www.sciencenews.org: 11572,
          www.curiousmeerkat.co.uk: 7782,
          www.scientificamerican.com: 6768,
          www.euroscientist.com: 6191,
          www.sbpdiscovery.org: 5063,
          speakingofresearch.com: 5031,
          www.nationalelfservice.net: 4926,
          retractionwatch.com: 4848,
          cosmosmagazine.com: 4507,
          academic.oup.com: 4365
        }
      }
    }

The following query means "of all Newsfeed Events found from www.theguardian.com, show me the top DOI prefixes that Events refer to".

    https://api.eventdata.crossref.org/v1/events?mailto=YOUR_EMAIL_HERE&rows=0&source=newsfeed&subj-id.domain=www.theguardian.com&facet=obj-id.prefix:*

The result shows:

    facets: {
      obj-prefix: {
        value-count: 46,
        values: {
          10.1038: 418,
          10.5281: 255,
          10.1136: 45,
          10.1080: 36,
          10.1371: 27,
          10.1111: 27,
          10.2139: 25,
          10.1007: 19,
          10.1002: 16,
          10.3354: 9,
          10.5772: 8,
          10.1056: 7,
          10.3389: 5,
          10.1098: 4,
          10.7717: 3,
          10.1086: 3,
    ...
        }
      }
    }

Remember that these totals don't refer to unique links necessarily, so you should be cautious about using the numbers for anything other than exploration.

## Navigating results

Every API response includes a `cursor` field. If this is not `null`, you should append that cursor value to query to fetch the next page of results. Once you have fetched all results the returned cursor value will be `null`.

The total number of results matched by the query is also returned.

The order or Events returned in the result is not defined, but is stable. This means that if you iterate over a result set using the cursor you will retrieve all results for that query.

## Example queries

Ten Events from the Reddit source:

    https://api.eventdata.crossref.org/v1/events?mailto=YOUR_EMAIL_HERE&rows=10&source=reddit

Ten Events collected on the first of March 2017

    https://api.eventdata.crossref.org/v1/events?mailto=YOUR_EMAIL_HERE&rows=10&from-collected-date=2017-03-01&until-collected-date=2017-03-01

Ten Events collected in the month of March 2017

    https://api.eventdata.crossref.org/v1/events?mailto=YOUR_EMAIL_HERE&rows=10&from-collected-date=2017-03-01&until-collected-date=2017-03-31

Ten Events that occurred on or after the 10th of March 2017

    https://api.eventdata.crossref.org/v1/events?mailto=YOUR_EMAIL_HERE&rows=10&from-occurred-date=2017-03-10

Up to ten Events for the DOI https://doi.org/10.1186/s40536-017-0036-8

    https://api.eventdata.crossref.org/v1/events?mailto=YOUR_EMAIL_HERE&rows=10&obj-id=10.1186/s40536-017-0036-8

Ten Events for the DOI prefix 10.1186

    https://api.eventdata.crossref.org/v1/events?mailto=YOUR_EMAIL_HERE&rows=10&obj-id.prefix=10.1186

All Events ever! Note that you will need to use the cursor to iterate through the result set.

    https://api.eventdata.crossref.org/v1/events?mailto=YOUR_EMAIL_HERE&rows=10000

Using the cursor returned from the first page (yours may be different) 

    https://api.eventdata.crossref.org/v1/events?mailto=YOUR_EMAIL_HERE&rows=10000&cursor=17399fd9-319d-4b28-9727-887264a632b1

## Keeping up-to-date

Events can be marked as deleted or edited, as described in the [updates](../data/updates) page. If you retrieve data and store it, you must make regular checks against Event Data to see if you need to update your own copy of the data.

### Edited Events

Events can be edited. This happens in exceptional circumstances, for example if we notice a bug in the system or make a design change. If you retrieve data and store it, you must regularly query this endpoint to check if you need to update your database.

These Events can be queried from this endpoint:

    https://api.eventdata.crossref.org/v1/events/edited

You can use all of the standard query parameters to filter the data, including `from-updated-date` and `until-updated-date`.

### Deleted Events

Events can be deleted. This happens, for example, if a tweet is deleted and we are obliged to remove the data. **If you retrieve data and store it, you must monitor for deleted Events**.

These are available at this endpoint:

    https://api.eventdata.crossref.org/v1/events/deleted

### Example

For example, on the 2nd of February 2017 you retrieve events from Twitter:

    https://api.eventdata.crossref.org/v1/events?mailto=YOUR_EMAIL_HERE&rows=10&source=twitter

You store the Events. One month later, you re-query for any Events that were updated since you last queried:

    https://api.eventdata.crossref.org/v1/events/edited?mailto=YOUR_EMAIL_HERE&rows=10&source=twitter&from-updated-date=2017-02-02

And any that were deleted:

    https://api.eventdata.crossref.org/v1/events/deleted?mailto=YOUR_EMAIL_HERE&rows=10&source=twitter&from-updated-date=2017-02-02

