# Events in Depth
<!-- TODO -->
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

## Subject and Object IDs

The `subj_id` and `obj_id` are URIs that represent the subject and object of the Event respectively. In most cases they are resolvable URLs, but in some cases they can be URIs that represent entities but are not resolvable URLs.

Examples of resolvable `subj_id` or `obj_id`s are: 

 - DOIs, e.g. `https://doi.org/10.5555/12345678`
 - Twitter URLs, e.g. `http://twitter.com/statuses/763877751396954112`

Examples of non-resolvable `subj_id` or `obj_id`s are:

 - Facebook-month, e.g. `https://facebook.com/2016/08/`

URIs like the Facebook-month example are used for two reasons. Firstly, we are collecting data for 'total like count of some users on Facebook', therefore no URL that can identify the entities actually exists. Secondly, it is useful to record the entity-per-date for ease of data processing and counting at a later date.

## Occurred At

The `occurred_at` field represents the date that the Event occurred. The precise meaning of 'occurred' varies from source to source:

For some sources, an event occurs on the publication of a `work`, and the `occurred_at` is the same as the issue date of the work. In these cases, the `occurred_at` value is supplied by the original Source (e.g. Twitter API or metadata on the blog).

 - a tweet was published and it referenced a DOI
 - a blog post was published and it referenced a DOI

For some sources, an event occurs at the point that an existing work is edited and the `occurred_at` is the same as the edit date. In these cases the `occurred_at` value is supplied by the original Source (e.g. Wikipedia API):

 - a Wikipedia article was edited and it referenced a DOI

For some sources, an event occurs at the point that a count is observed from a pre-aggregating source. In these cases, the `occurred_at` value is supplied by the Agent that makes the request to an external service, e.g. Facebook Agent:

 - Facebook was polled for the count for a DOI
 - Mendeley was polled for the count for a DOI

Therefore `occurred_at` field comes from a different authority depending on the source, sometimes an internal service, sometimes an external one. Bear this in mind if you intend to rely on the precise time of an Event. 

## Timestamp

The `timestamp` field represents the date that the Event was processed. Every piece of data travels through an internal pipeline within the Event Data service. The timestamp records the time at which an Event was inserted into the Lagotto service, which is the central component that collects all Events.

<!---
TODO: PIPELINE PICTURE
-->

The `timestamp` is used in the `collected` view in the Query API.

The `timestamp` usually happens a short while after the event was collected. For some sources, such as Twitter, this can be a few minutes. For sources that operate in large batches, such as Facebook, this can be a day or two. Regardless of variation between agents, the `timestamp` represents the canonical time at which Event Data became aware of an Event.

## Subject and Object Metadata

Event Data allows Subject and Object metadata to be included. Where the Subject or Object metadata are DOIs, and therefore can be easily looked up from the Crossref or DataCite Metadata API, it is usually not included. In other cases, it is often included.

For some sources, such as Facebook, the subject ID may be a representative URI and not a URL, and doesn't correspond to a webpage. See [Subject URIs and PIDs in Facebook](#sources-depth/in-depth-facebook-uris) for more details.

## ID

The ID is generated by Agents, whether they're operated by Crossref or external parties. They are expressed as UUIDs and should be treated as opaque identifiers.

See the list of [Sources in-depth](sources-in-depth) for a discussion of the various subject fields per source.

## Message Action

Most of the time an Event can be read as 'this relation was created or observed'. An Event records the relationship that came into being at a given point in time.

Sometimes these relationships come and go. For example, in Wikipedia, an edit can result in the removal of a reference from an article. In fact, we often see a history of references being added and removed as the result of a series of edits and sometimes reversions to previous versions.

The removal of a relation in Wikipedia doesn't constitute the removal of an Event, it means a new event that records the fact that that the relation was removed.
