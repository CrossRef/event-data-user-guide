# Time

<a name="concept-timescales"></a>
## Occurred-at vs collected-at

Every Event results from an action that was taken at some point in time. This is considered to be the time that the Event 'occurred'. Examples of the 'occurred' field:

 - the time the Tweet was published
 - the time the edit was made on Wikipedia
 - the time that the Reddit comment was made
 - the time that the blog post was published
 - the time an article with a data citation was published

Usually Events are collected soon after they occur, but we make no guarantees. For example, agents may recieve archives of old data, or re-scan old date ranges, or reprocess inputs that couldn't be processed in the past.

Every Event also has a 'collected' time. This is the time when the Agent submitted an Event to the Event Data Service. Depending on load, there may be a delay between when the Agent ingested some data and when it was timestamped. 

These two dates are represented as the `occurred_at` and `timestamp` fields on each Event. The Query API has two views which allow you to find Events filtered by both timescales.

### Using the Query API over time

The Query API is updated every day. It has two views (as documented in the [Query API page](../service/query-api)): `collected` and `observed`. Once a day's worth of data is collected and made available via its `collected` view, that selection of Events won't change (although Events themselves may be edited in exceptional circumstances). 

The Query API also contains an `occurred` view. This returns Events based on the date they **occurred** on. Because Events can be collected some time after they occurred, the data in this view can change.

<img src="../../images/occurred-collected-timeline.svg" alt="Occurred at vs Collected at" class="img-responsive">

When you use the **collected** view you should be aware that it may contain Events that occurred in the past.

When you use the **occurred** view you should be aware that that the results may change over time, and that Events may have happened in the past that have not yet been collected.

### Stable dataset with `collected`

The `collected` dataset provides a stable dataset that can be referenced. You can be confident that the data returned by a query URL won't change over time. You can also be confident that by collecting data for each day you will build a complete dataset of Events collected over that period.

The downside of this is that you will not be able to find Events that occurred on a given day without downloading a complete dataset.

### Flexible data with `occurred`

The `occurred` dataset provides an up-to-date dataset that lets you find Events that occurred on a given day. The data at a Query URL will change over time, so you can't rely on the dataset to be stable and citable.

The timestamp field is available on all Events, so you can see when they were collected and added to the dataset for a given day.