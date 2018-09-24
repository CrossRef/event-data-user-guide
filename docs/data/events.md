# Events

Each Event is a JSON-representable object. Events have a core set of fields and are extensible.

| Field              | Type        | Optional? | Description |
|--------------------|-------------|-----------|-------------|
| `subj_id`          | URI         | No  | Subject Persistent ID. |
| `relation_type_id` | string      | No  | Type of the relationship between the subject and object. |
| `obj_id`           | URI         | No  | Object Persistent ID. |
| `timestamp`        | Timestamp   | No  | Timestamp of when the Event was created. |
| `occurred_at`      | Timestamp   | No  | Timestamp of when the Event is reported to have occurred. |
| `id`               | UUID        | No  | Unique ID for the Event. |
| `source_id`        | string      | No  | A name for the source. |
| `source_token`     | UUID        | No  | Unique ID that identifies the Agent that generated the Event. |
| `terms`            | URL         | Yes | Terms of use for using the API at the point that you acquire the Event. |
| `license`          | URL         | Yes | A license under which the Event is made available. |
| `evidence_record`  | URL         | Yes | Link to an Evidence Record for this Event. |
| `subj`             | JSON Object | Yes | Subject metadata. |
| `obj`              | JSON Object | Yes | Object metadata. |


# subj_id and obj_id

An Event has a Subject and an Object, expressed as a URI. This could be:

 - The Canonical URL of a webpage, if one is supplied. E.g. Some blogging platforms report a Canonical URL.
 - The URL of a webpage as found.
 - The DOI of the content being referenced.

Becuase Event Data is designed to track Registered Content via DOIs, every Event contains a DOI as the `subj_id` or `obj_id`. Most events have a webpage URL as the `subj_id` and a DOI as the `obj_id`, but this is left to the individual Agent that produces the Event.

# relation_type_id

The Relation Type ID is taken from a controlled vocabulary. You should refer to the documentation for each source to see which relation types are used. 

# timestamp and occurred_at

Every Event has a time at which it was *created*. This is automatically assigned when the Agent sends an Event into the Event Data system. This is usually soon after the Event was observed. You can use this `timestamp` to filter Events that were collected within a certain date range, and as a reliable method for iterating over all Events. 

In addition to this, every Event has a theoretical date on which it *occurred*. The precise meaning of this can vary from source to source. Twitter's `occurred_at` corresponds to the date that Twitter reports that the Tweet was published. The Newsfeed source takes the date from the time that an RSS feed indicates that the blog was published. The Web source takes the date that a webpage was observed. For more information, see each source's documentation. There is an in-depth discussion of times in the [Time](/data/time) page.

Timestamps found in the `timestamp` or `occurred_at` fields are given in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) UTC Z format, e.g. `2017-05-14T05:04:57Z`. In other fields you may see formats including, e.g. `2017-05-14T05:04:57.000Z`. All dates conform to ISO8601.

# id

Every Event is assigned a unique ID. This enables you to unambiguously refer to the Event in question.

# source_id

The `source_id` identifies the *original source* of the input data. It corresponds to the list of sources you can find listed in this guide. Every source is monitored by an Agent. 

# source_token 

Each Agent has its own unique ID, which you can find in the Sources documentation. The `source_token` identifies the *Agent that processed the data* to produce the Event.

# terms and license

Events will be made available via the Crossref Event Data Query API. If you use this service you must abide by the [Terms of Use](https://www.crossref.org/services/event-data/terms/), which are indicated in the `terms` field. You may find the same data made available via other services, for example DataCite's Event Data service. If this is the case, the terms field in Events made available via these other services may be different or missing.

As each Source may operate under a different license, every Event includes a `license` field. Only licenses from the [Open Definition](https://opendefinition.org/guide/) list are used.

# evidence_record

An Event may have an Evidence Record associated with it. This is a file that provides an audit trail of how the Event was created. For more information see [Evidence Records](/data/evidence-records).

# subj and obj

The Event may include metadata about its subject and/or object. For example:

 - `pid` - The persistent ID. Must correspond to `subj_id` or `obj_id`.
 - `issued` - publication date.
 - `title` - the title of the webpage, comment, etc.
 - `author` - author of the comment, blog etc.
 - `url` - URL where this was found. May be different to `pid`.
 - `method` - Optional. The method by which we matched a URL for Registered Content to a DOI.
 - `verification`. Optional. The method by which we verified that this content has the given DOI.

We typically only include metadata that you are unable to get elsewhere and that is unlikely to change. Where the `subj_id` or `obj_id` is a DOI, we will not include the metadata because you can easily look it up using the Crossref or DataCite APIs and it could go out of date if recorded. We also store a large amount of metadata associated with each DOI, and including it all would balloon the data to many times its size.

People don't always use DOIs to cite Registered Content, especially on social media, so we often links using the Landing Page. Where a link to Landing Page is identified, and we can match that to a DOI, we will use the DOI as the `obj_id` and `obj.pid`, and the actual URL of the Landing Page as the `obj.url`. In these cases, we include an optional `method` and `verification` and field to indicate how we matched a DOI, and how we verified that. For a full description see [Matching Landing Pages](/data/matching-landing-pages).



