Event Data as a Graph Data Structure

## Graphs represent things and relationships

Event Data describes connections between things, which makes it an ideal fit for a graph database. Unlike conventional table-oriented databases, graph databases (for example [Neo4J](https://neo4j.com)) represent entities and relationships between them. They can also represent the breadth and diversity of data that we collect. 

![Nodes and an edge](/images/graph-a.png)

Graphs are made up of 'nodes' and 'edges'. A node represents a 'thing' and an edge represents a connection between two 'things'. The 'thing' in question might be a tangible object, such as an instance of an article, or a concept such as a subject area. A node can have properties (e.g. title, publication date). An edge can have a type, for example to indicate what kind of relationship the edge represents.

![Apple is a kind of fruit](/images/graph-apple.png)

In this example we have two nodes and one edge. The nodes and edges have labels which represent the concepts 'apple', 'is a kind of' and 'fruit'.

![Apple is a kind of fruit, humans eat apples, animals eat apple](/images/graph-food.png)

In this example we've added a few more edges and nodes. It contains nodes for real instances of things, such as 'Alice' and 'Bob'. It also contains nodes for concepts, such as 'animals' and 'apples"'. You could issue a query on this graph that asks:

> For all `X`s that `eat` `Apples`, find all `Z`s that `X` `is a` type of `X`.

Which, in English is:

> Find me all `Z`s that are types of things that eat apples.

To which the answers are:

> animals eat apples
> humans eat apples

As graphs grow, we can represent concepts and real objects and they way they are all related. 

## Representing Event Data

You can model Event Data as a graph, and you can combine it with data from other sources and other graphs. Each new Event represents a new connection between things you may already know about, and as more data comes in the connectedness of the graph will increase, allowing you to make new inferences.

But although each Event corresponds to a connection, that doesnt't always mean just two nodes an an edge. In order to construct a graph, you must choose how you represent Events as nodes and edges, and to do that it's necessary to _interpret_ the Events. How you interpret them is up to you, and will depend on what you're trying to achieve. Models go from very simple but easy to navigate, to very detailed but possibly hard to interrogate or query.

Let's take an example event:

    {"obj_id":"https://doi.org/10.3201/eid2202.151250",
     "source_token":"a6c9d511-9239-4de8-a266-b013f5bd8764",
     "occurred_at":"2016-01-26T01:49:17.000Z",
     "subj_id":"https://reddit.com/r/science/comments/42p4xg/prognostic_indicators_for_ebola_patient_survival/",
     "id":"0003a012-e3fd-4d2f-8c18-1d8b7bb07e20",
     "terms":"https://doi.org/10.13003/Event Data-terms-of-use",
     "action":"add",
     "subj":{
       "pid":"https://reddit.com/r/science/comments/42p4xg/prognostic_indicators_for_ebola_patient_survival/",
       "type":"post",
       "title":"Prognostic Indicators for Ebola Patient Survival",
       "issued":"2016-01-26T01:49:17.000Z"
      },
      "source_id":"reddit",
      "obj":{
        "pid":"https://doi.org/10.3201/eid2202.151250",
        "url":"http://wwwnc.cdc.gov/eid/article/22/2/15-1250_article"
      },
      "timestamp":"2017-02-22T17:16:17.909Z",
      "evidence_record":"https://evidence.eventdata.crossref.org/evidence/2017022244f5e774-b3ca-4b29-8555-269777b38983",
      "relation_type_id":"discusses",
      "license": "https://creativecommons.org/publicdomain/zero/1.0/"
    }


We can identify several potential nodes that this Event mentions. In order of obviousness:

1. The Event itself by its ID of `0003a012-e3fd-4d2f-8c18-1d8b7bb07e20` (from the `id` field)
2. The DOI `https://doi.org/10.3201/eid2202.151250` that identifies a piece of content (from the `subj_id` field)
3. The relation-type `discusses` (from the `relation_type` field)
4. The URL `https://reddit.com/r/science/comments/42p4xg/prognostic_indicators_for_ebola_patient_survival/` that identifies a Reddit comment (from the `subj_id` field).
5. The URL `http://wwwnc.cdc.gov/eid/article/22/2/15-1250_article` that is associated with to the same piece of content as the DOI (from the `subj` field).
6. The Evidence Record with the URL `https://evidence.eventdata.crossref.org/evidence/2017022244f5e774-b3ca-4b29-8555-269777b38983` (form the `evidence-record` field)
7. The source with ID `a6c9d511-9239-4de8-a266-b013f5bd8764` that idenfies the Agent that collected the Event (from the `source_token` field)
8. The URL `https://doi.org/10.13003/Event Data-terms-of-use` that identifies the Terms of the Event (from the `terms` field).
9. The Action type `add` (from the `action` field)
10. The Reddit type of `post` (from the `subj` field)
11. The source ID `reddit` (from the `source_id` field)
12. The concept of `discusses` (from the `relation_type_id` field)
13. The license at the URL `https://creativecommons.org/publicdomain/zero/1.0/`


Some of these are specific to the Reddit source. Some may or may not be relevant to you. Notice that we have a gap between the concept of the article and its two identifiers https://doi.org/10.3201/eid2202.151250 and http://wwwnc.cdc.gov/eid/article/22/2/15-1250_article.

We can also identify several potential arcs in the Event. In order of obviousness:

1. From the `subj_id`, `relation_type_id` and `obj_id` fields:
    - Content at the URL `https://reddit.com/r/science/comments/42p4xg/prognostic_indicators_for_ebola_patient_survival/`
    - discusses
    - the Content Item with DOI `https://doi.org/10.3201/eid2202.151250`
2. From the `subj.id` field:
    - The content at the URL `https://reddit.com/r/science/comments/42p4xg/prognostic_indicators_for_ebola_patient_survival/`
    - referred to the subject
    - using URL `http://wwwnc.cdc.gov/eid/article/22/2/15-1250_article`
3. From the `subj_id` field:
    - The Event ID `0003a012-e3fd-4d2f-8c18-1d8b7bb07e20`
    - has a `subj_id`
    - of `https://reddit.com/r/science/comments/42p4xg/prognostic_indicators_for_ebola_patient_survival/`
4. From the `obj_id` field: 
    - Event ID `0003a012-e3fd-4d2f-8c18-1d8b7bb07e20` 
    - has an `obj_id` 
    - of `https://doi.org/10.3201/eid2202.151250`.
5. From the `evidence_record` field:
    - Event ID `0003a012-e3fd-4d2f-8c18-1d8b7bb07e20`
    - is supported by
    - Evidence Record `https://evidence.eventdata.crossref.org/evidence/2017022244f5e774-b3ca-4b29-8555-269777b38983`
6. From `source_token` field:
    - Event ID `0003a012-e3fd-4d2f-8c18-1d8b7bb07e20`
    - is asserted by
    - Agent with source token `a6c9d511-9239-4de8-a266-b013f5bd8764`.
7. From the `source_id` field:
    - The data for Event ID `0003a012-e3fd-4d2f-8c18-1d8b7bb07e20`
    - came from
    - source ID `reddit`.
8. From the `subj.url` and `subj_id` fields:
    - The Agent asserts that the content found at the URL `http://wwwnc.cdc.gov/eid/article/22/2/15-1250_article`
    - has the DOI
    - `https://doi.org/10.3201/eid2202.151250`.
9. From the `terms` field:
    - Event ID `0003a012-e3fd-4d2f-8c18-1d8b7bb07e20`
    - is subject to
    - terms of use found at `https://doi.org/10.13003/Event Data-terms-of-use`.
10. From the `license` field:
    - Event ID `0003a012-e3fd-4d2f-8c18-1d8b7bb07e20` 
    - is made available under the license
    - `https://creativecommons.org/publicdomain/zero/1.0/`.
11. From the `id` and `relation_type_id` fields:
    - The Event ID `0003a012-e3fd-4d2f-8c18-1d8b7bb07e20`
    - reports on activity of type
    - `discusses`
12. From the `subj_id` and `subj.type` fields:
    - The content at the URL `https://reddit.com/r/science/comments/42p4xg/prognostic_indicators_for_ebola_patient_survival/` 
    - has the type
    - `post`
13. From the `action` field:
    - Event ID `0003a012-e3fd-4d2f-8c18-1d8b7bb07e20`
    - has the action
    - `add`.

If we were to show the above graphically it might look like:

![All full modelling of Reddit Event](/images/graph-reddit.png)

There are even more potential arcs in there, and they can be represented at any level of detail. But this level of detail is already overkill for most uses and adding unncecessary detail can slow things down and make the data more difficult to query.

**The way you represent Event Data in a graph database should be guided by the kind of queries you want to run.**

## Is an Event a node or an edge?

At the simplest level, an Event represents an edge (i.e. a connection between two nodes). It has a subject, object, and a way of connecting them. As you've seen, it also contains many other kinds of relationships beyond this.

But an Event could also be represented as a node. It is an object that exists, and it has connections to other nodes. If you wanted to answer the question 'which tweets mention this article?' you would have to phrase it differently depending on your choice:

 - If you represent **Events as edges**, you would say "find all nodes that have the type 'tweet' and that have a connection to the node with this DOI".
 - If you represent **Events as nodes**, you would have to say "find all Event nodes that have a subject node that has the type 'tweet' and an object node that has this DOI".

In practice, both of these queries are trivial to write, but once you have a large quantity of data, it might make a difference. The first case is simple to query and understand but lacks any supporting data. The second case is more detailed but includes more supporting information.

## Why not both?

You can choose to model Events several different ways at the same time. This process is known as 'denormalization' and involves representing the same data different ways (and therefore including some redundancy) but makes querying more flexible and possibly more efficient. 

You could also run two databases, one for running simple efficient queries and one for representing the full detail.

## Six ways you can model Event Data

Here are six illustrations of practical ways you could model Events in a graph database. Each has upsides and downsides.

### 1: `subj_id` &rarr; `obj_id`

![Model 1](/images/graph-1.png)

- Subject PID is a node
- Object PID is a node
- Event is an edge, type taken from `relation_type_id`

This is the simplest representation. It keeps the essence of the relationship, and allows you to query by relation type. Because the optional `obj.url` url is discarded, this model doesn't capture the URL that was actually linked to, instead it captures the conceptual link to the article. So you would know 'the Reddit comment linked to the article with this DOI' but you wouldn't know how it linked to the article.

It is lightweight and good for initial investigations, but discards most of the information.

### 2: `subj.url` &rarr; `obj.url` with PIDs links

![Model 2](/images/graph-2.png)

 - Subject PID is a node
 - Object PID is a node
 - Subject URL is a node
 - Object URL is a node
 - Relationship between subject URL and object URL is an edge
 - Relationships between subject URL and subject PID, and between object URL and object PID are edges

By linking the `subj.url` to the `obj.url`, this model records what actually happened, e.g. a Reddit post linking to an article Landing Page URL. The `subj_id` and `obj_id` are also included and linked, so we can see which conceptual article is meant by the URL.

Note that every subject and object has a PID, but doesn't necessarily have a URL. In this case you might consider falling back to the PID.

This model represents the activity more accurately, but still discards information. For example if you want to connect the Reddit comment to the DOI, you have to perform an extra 'hop' to get to the DOI which may incur extra computation time. And once the data is in the graph database, you can't say which Event or Evidence Record caused it to get there.

### 3: `subj_id` &rarr; `obj_id` with URLs.

![Model 3](/images/graph-3.png)

 - Subject PID is a node
 - Object PID is a node
 - Subject URL is a node
 - Object URL is a node
 - Relationship between subject PID and object PID is an edge
 - Relationships between subject PID and subject URL, and between object PID and object URL are edges

This model represents the link between the conceptual items via their PIDs and also includes the URLs. This model includes more information but, like model 1, doesn't describe exactly which URLs were used in a given link.

This is similar to model 1, except that the relationship is modelled between the PIDs, not the URLs. This may not represent that the Reddit page mentioned the article Landing Page, but it does represent that it mentioned the article, and that the article has the Landing Page URL.

Event Data uses DOIs to represent registered content such as articles, so the way this model is expressed is closer to the way the Event is expressed. However it discards the information about *how* the Reddit post linked to the article.

### 4: The Event as the central node.

![Model 4](/images/graph-4.png)


 - Subject PID is a node
 - Object PID is a node
 - Subject URL is a node
 - Object URL is a node
 - Event is a node
 - Connections from Event node to subject PID, object PID, subject URL and object URL

In previous models the place of an Event is represented implicitly as an arc. In this model it becomes a node. As a node, it can have properties (such as title) and it can also represent an Event in the database. With the Event as the central node, it represents both the conceptual link and the actual URLs that were used to connect the two things. 

Questions you can ask of this model are:

 - If this node is the subject of an Event node, give me all nodes that are the object of the Event node
 - If this node is an article DOI, find all URL nodes that are the subj_url of nodes of which this is an a subj_PID. In other words, find the Landing Page URL for this article DOI.

This model is the richest so far, but issuing queries between subject and object nodes requires an extra 'hop' to find the intermediary Event node. 

### 5: The Event as the central node, plus denormalizations.

![Model 5](/images/graph-5.png)

In this model we mix #3 and #4. We can make simple queries like 'find nodes that mention this DOI' or 'find DOIs that this node references', but once we find a connection we can then say 'which event(s) connect these two nodes'. This model includes duplicate data, but allows a combination of lightweight querying with supporting evidence. 

### 6: Event node with relationships between all other nodes.

![Model 6](/images/graph-6.png)

This model combines all of the above. It represents the relationships between PID nodes and their URLs, between pairs of PID nodes, using the `relation_type_id` as the type of node. It also connects the Event to all of the nodes to allow queries like 'which Events(s) connect these two PIDs' but also 'in which Event was it asserted that this DOI has this Landing Page URL'.

## Over to you

Hopefully this has been an useful introduction to modelling Event Data. Just as there's no one true user of Event Data, there's no one true way to represent this information in a graph database. Choosing the right model will always be a trade-off between fullness of data, ease of querying, and practical considerations. 

