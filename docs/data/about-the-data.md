# About the Data

The Crossref Event Data is centred around Events, but contains supporting data and metadata:

 - **Events** record activity around Registered Content.
 - **Evidence Records** provide an evidence trail for Events.
 - **Artifacts** show some of the inputs that were used and feed into Evidence Records.
 - **Evidence Logs** document the behaviour of the system.

This section describes in detail exactly what data exists in Event Data, and what you should bear in mind when using it.

## Why Events?

Each Event represents an atomic unit of observed activity. It contains a single subject-relation-object triple and also has other supporting fields and metadata that indicate how, why, where and by whom the Event was created. In order to communicate all the relevant information, it's necessary to deliver data on this level of detail.

As we track connections as they cocur between a known set of things, you may wonder why the Event Data service is presented as a sequence of Events rather than a graph database of relations like, for example, Facebook's Graph API. The answers are twofold:

Firstly, the data is always changing. Any representation of Event Data in a graph structure would either have to be in a constant state of change, or it would have to be scoped for a specific date range. Both of these are good use cases for end-users but not for a the Event Data API that provides the original data.

Secondly, there are many ways that the Event Data could be modelled into a graph database. Choosing exactly how to do this involves interpreting the data, which is something we do not do. This subject is covered in depth in the [Event Data as a Graph Data Structure](/data/graph) page.

Because of this we present Event Data as a series of Events and you can decide if you want to create other representations in your own application. The Query API gives you the flexibility to scan over all data, or only to get those Events that were collected since your last visit.

The API also allows you to make queries like "all Events for this DOI" or "all Events for this Tweet". The results for these queries will change over time.

## Where we look

Data comes from different sources, via different routes. For some sources, like Crossref Metadata and DataCite Metadata, we receive Events directly from the source. For others, we operate an Agent (or bot) to go and look for Events.

![Event journeys](../images/journeys.png)

Events from each source go on a different journey to get into Event Data. Each Event documents its own provenance and links to supporting evidence, where applicable. Because of the diversity of routes by which data enters Event Data, you should consider which sources you are interested in. Each source is individually documented in this Guide.

Because Event Data captures links between 'traditional literature' and 'non-traditional literature', the 'subject' of most Events is a webpage and the 'object' is a Registered Content Item, linked via its DOI.

Crossref members already provide reference information for Registered Content, for example article to article citations. This falls under the 'traditional scholarship' category and is outside the scope of Event Data. If the Publisher has made it open, this data is available via the Deposit system (available via the Crossref REST API).

"Webpages" represent a wide variety of things, including members' sites. In order to avoid accidentally collecting 'traditional' reference information, all Crossref Event Data Agents avoid websites that belong to our members. We maintain a list of domains that the Event Data Bot will not visit because we know they belong to Publishers. This exclusion is done on a best-effort basis.

We also exclude other webpages that we believe are part of databases, library systems etc. As we monitor a potentially limitless set of websites, this with is done with heuristics on a best-effort basis.

<a name="data-sources"></a>

## Sources and Agents

Event Data is a hub for the collection and distribution of a variety of Events and contains data from a selection of Sources. Every Event is produced by an Agent operated by Crossref, DataCite or one of our partners. The Agent is responsible for connecting to an external Data Source and turning the data into Events. In some cases, the Agent is passing data directly through and in other cases the Agent has to do some work to extract the Event.

All of the Agents that Crossref operate attempt to co-operate to prevent the same webpage being visited by two Agents so that they make exactly the same observation. Nonetheless you may find that a (`subject`, `relation`, `object`) triple may occur in more than one source. For example, a blog post that's captured by the Wordpress.com agent might also be included in an RSS feed monitored by the Newsfeed agent, and might also be captured by the Web agent. In this case there might be three Events that have the same blog url subject and DOI object. You will need to interpret this kind of data, for example by de-duplicating duplicates, or by treating duplicates as extra corroboration.



For detailed discussion of each Agent, see its corresponding page.


| Name                                       | Source Identifier | Operated by | What does it contain? |
|--------------------------------------------|-------------------|-------------|------------------|
| [Crossref links](/sources/crossref)      | crossref          | Crossref    | Dataset citations from Crossref Items to DataCite Items |
| [DataCite links](/sources/datacite)      | datacite          | DataCite    | Dataset citations from DataCite Items to Crossref Items |
| [Hypothes.is](/sources/hypothesis)          | hypothesis        | Crossref    |
| [Newsfeed](/sources/newsfeed)               | newsfeed          | Crossref    | Links to Items on blogs and websites with syndication feeds |
| [Reddit](/sources/reddit)                   | reddit            | Crossref    | Mentions and discussions of Items on Reddit |
| [Reddit Links](/sources/reddit-links)       | reddit-links      | Crossref    | Mentions in pages shared on Reddit. |
| [StackExchange](/sources/stackexchange)     | stackexchange     | Crossref    | 
| [Twitter](/sources/twitter)                 | twitter           | Crossref    | Links to Items on Twitter |
| [Web](/sources/web)                         | web               | Crossref    | Links of Items on web pages |
| [Wikipedia](/sources/wikipedia)             | wikipedia         | Crossref    | References of Items on Wikipedia |
| [Wordpress.com](/sources/wordpress-dot-com) | wordpressdotcom   | Crossref    | References of Items on Wordpress.com blogs |

Every Data Source exists for a different reason, and therefore provides a different style of data. Every Agent operates slightly differently, according to its source. When you consume Events you should be mindful of the source they came from and the Agent that processed them.