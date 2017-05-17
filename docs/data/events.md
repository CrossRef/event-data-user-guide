# Events

Each Event is a JSON-representable object. Events have a core set of fields and are extensible.

| Field              | Type        | Optional? | Description |
|--------------------|-------------|-----------|-------------|
| `subj_id`          | URI         | No  | Subject Persistent ID. |
| `relation_type_id` | string      | No  | Type of the reationship between the subject and object. |
| `obj_id`           | URI         | No  | Object Persistent ID. |
| `timestamp`        | Timestamp   | No  | Timestamp of when the Event was created. |
| `occurred_at`      | Timestamp   | No  | Timestamp of when the Event is reported to have occurred |
| `id`               | UUID        | No  | Unique ID for the event |
| `source_id`        | string      | No  | A name for the source |
| `source_token`     | UUID        | No  | Unique ID that identifies the Agent that generated the Event. |
| `terms`            | URL         | Yes | Terms of use for using the API at the point that you acquire the Event. |
| `license`          | URL         | Yes | A license under which the Event is made available. |
| `evidence`         | URL         | Yes | Link to an Evdience Record for this Event. |
| `subj`             | JSON Object | Yes | Subject metadata. |
| `obj`              | JSON Object | Yes | Object metadata. |


# subj_id and obj_id

An Event has a Subject and an Object, expressed as a URI. When a [Persistent Identifier](https://en.wikipedia.org/wiki/Persistent_identifier) is available, it will be used. Otherwise this will be the URL of a webpage or in some cases a URI. When a Registered Content Item is referenced as the Subject or Object, the DOI (which is a type of Persistent Identifier) will be used in the `subj_id` or `obj_id` field, normalized to comply with the [Display Guidelines](https://www.crossref.org/display-guidelines/).

# relation_type_id

The Relation Type ID is taken from a controlled vocabulary. You should refer to the documentation for each source to see which relation types are used. 

# timestamp and occurred_at

Every Event has a time at which it *came into being*, when the Agent passed an Event into the Event Data system. This is usually soon after the Event was observed. You can use this timestamp to filter Events that were collected within a certain date range, and as a reliable method for iterating over all Events. 

In addition to this, every Event has a theoretical date on which it *occurred*. The precise meaning of this can vary from source to source. Twitter's `occurred_at` corresponds to the date that Twitter reports that the Tweet was published. The Newsfeed source takes the date from the time that an RSS feed indicates that the blog was published. The Web source takes the date that a webpage was observed. For more information see each source's documentation. There is an in-depth discussion of times in the [Time](/data/time) page.

Timestamps found in the `timestamp` or `occurred_at` fields are given in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) UTC Z format, e.g. `2017-05-14T05:04:57Z`. In other fields you may see formats including, e.g. `2017-05-14T05:04:57.000Z`. All dates conform to ISO8601.

# id, source_id and source_token

Every Event is assigned a unique ID. This enables you to unabiguously refer to the Event in question.

The `source_id` identifies the *original source* of the input data. It corresponds to the list of sources you can find listed in this guide. Every source is monitored by one Agent. Each Agent has its own unique ID, which you can find in the Sources documentation. The `source_token` identifies the *Agent that processed the data* to produce the Event.

# terms and license

Events will be made available via the Crossref Event Data Query API. If you use this service you must abide by the terms of use, which are indicated by the URL. You may find the same data made available via other services, for example DataCite. If this is the case, the terms field may be different or missing.

As each Source may operate under a different license, every Event includes a `license` field. Only licenses from the [Open Definition](http://opendefinition.org/guide/) list are used.

# evidence

An Event may have an Evidence Record associated with it. This is a file that provides an audit trail of how the Event was created. For more informatoin see [Evidence Records](/data/evidence-records).

# subj and obj

The Event may include metadata about its subject and/or object. For example:

 - `pid` - the persistent ID. Must correspond to `subj_id` or `obj_id`
 - `issued` - publication date
 - `title` - the title of the webpage, comment, etc
 - `author` - author of the comment, blog etc
 - `url` - URL where this was found. May be different to `pid`

We typically only include metadata that you are unable to get elsewhere and that is unlikely to change. Where the `subj_id` or `obj_id` is a DOI, we will not include the metadata because you can easily look it up using the Crossref or DataCite APIs and it could go out of date if recorded. We also store a large amount of metadata associated with each DOI, and including it all would balloon the data to many times its size.

Note that the `url` can be different to the `pid`. For example if a webpage links to a Registered Content Item via its article landing page, the Agent will represent that Item using its DOI in the `obj_id` and `obj.pid` but will include the landing page URL in the `subj.url`. This allows you to unambiguously identify the Content Item in question whilst also retaining the detail about how it was linked. For more information see [IDs and URLs and the Web](/data/ids-and-urls).



