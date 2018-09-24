# Time

<a name="concept-timescales"></a>
## Occurred-at, collected-at and updated-at

Every Event results from an action that was taken at some point in time. This is considered to be the time that the Event 'occurred'. Examples of the 'occurred' field:

 - the time the tweet was published
 - the time the edit was made on Wikipedia
 - the time that the Reddit comment was made
 - the time that the blog post was published
 - the time an article with a data citation was published

In some cases, the occurrence time is reported by the source. In other cases, such as the Web source, the occurrence time isn't available and it's recorded by the Agent as the point point in time when it visited the page.

Usually Events are collected soon after they occur, but we make no guarantees. For example, Agents may receive archives of old data, or re-scan old date ranges, or reprocess inputs that couldn't be processed in the past.

Every Event also has a 'collected' time. This is the time when the Agent or Percolator submitted an Event. Depending on load, there may be a delay between when the Agent ingested some data and when it was timestamped. 

We try to avoid changing an Event after it has been collected, but in some circumstances, for example when we are contractually obliged to, we will edit an Event. Read more in [Updates](/data/updates). 

These three dates are represented as the `occurred_at`, `timestamp` and `updated_date` fields on each Event. The Query API has two views which allow you to find Events filtered by both `occurred_at` and `timestamp` timescales. It also lets you query for Events that have been updated since a given date.

### Using the Query API over time

The Query API is updated continuously, usually within one hour of current activity. It has two views (as documented in the [Query API page](../service/query-api)): `collected` and `observed`. Once a day's worth of data is collected and made available via its `collected` view, that selection of Events won't change (although Events themselves may be edited for compliance reasons). 

The Query API also contains an `occurred` view. This returns Events based on the date they **occurred** on. Because Events can be collected some time after they occurred, the data in this view can change.

<img src="../../images/occurred-collected-timeline.svg" alt="Occurred at vs Collected at" class="img-responsive">

When you use the **collected** view you should be aware that it may contain Events that occurred in the past.

When you use the **occurred** view you should be aware that that the results may change over time, and that Events may have happened in the past that have not yet been collected.

### Stable dataset with `collected`

The `collected` dataset provides a stable dataset that can be referenced. You can be confident that the data returned by a query URL won't change over time. You can also be confident that by collecting data for each day you will build a complete dataset of Events collected over that period.

The downside of this is that you will not be able to find Events that occurred on a given day without downloading a complete dataset.

### Flexible data with `occurred`

The `occurred` dataset provides an up-to-date dataset that lets you find Events that occurred on a given day. The data at a Query API URL will change over time, so you can't rely on the dataset to be stable and citable.

The timestamp field is available on all Events, so you can see when they were collected and added to the dataset for a given day.

### Updates

Update dates are cross-cutting. You can issue a query that simultaneously specifies collected dates, occurred dates and update dates. If you store the result of a query in a database you should periodically re-run the query, along with the `from-updated-date` of the last time you ran the query, to refresh your data with Events that were updated since the last time you ran it.
