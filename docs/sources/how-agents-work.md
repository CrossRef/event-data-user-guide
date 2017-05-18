# How Sources and Agents Work

Every Event starts its life in a Source. Because of the diversity of Agents, Sources and Events, it's difficult to give a single definition of a source, so here are some examples:

 - The Twitter API is a Source because it provides information about Tweets.
 - Newsfeeds (e.g. RSS or Atom feeds of blogs) are Sources because they provide pointers to blog posts. They don't provide the content of the blog posts, but tell the Agent where to look.
 - DataCite is a source because it provides links between DOIs and Crossref DOIs. It provides DOI to DOI links.

Every Source has one or more Agents dedicated to it. Each Agent connects to its Source and produces Events. The kind of data that the Source makes available, and the way that the Agent processes it, vary.

 - Some Sources send content which is refined by the Agent. This is how the Twitter and Reddit Agents work.
 - Some Sources send pointers to content, which the Agent then visits. This is how the Wikipedia and Newsfeeds Agents work.
 - Some Sources are custom-built to send Events directly. This is how the Crossref and DataCite Agents work.

A source not only identifies a concrete external service, Twitter, but also a conceptual view of the data. For example:

 - The `newsfeed` source covers all newsfeeds that we track.
 - The `reddit` source covers comments and activity that occur on Reddit.
 - The `reddit-links` source covers the content of links (e.g. blog posts) that people share on Reddit. 

## Common features in Agents

There are some common features and patterns that occur accross Agents. 

### Issuing Queries for Landing Page Domains

Many of the links that we track use the [Landing Page URL of the Article](/data/ids-and-urls). We maintain an Artifact which contains all of the Domains we're interested in. Some external APIs, such as Reddit, allow queries to be issued for links by their domain. In cases like this, the Agent will periodically scan the API, issuing a query for each Landing Page domain.

### Following links

Some sources send links to things that must be consulted. For example, each RSS newsfeed contains links to Blog posts that must be processed to extract links. The Wikipedia Agent recieves a stream of Wikipedia page URLs, each of which must be visited to extract links.

### Events and Evidence Records

Most Agents don't produce Events directly. Instead they produce Evidence Records, which are further processed into Events at a later. This means that the Agent only does the job of converting external data into the standard Evidence Record format.

An internal component, called the Percolator, does the job of processing the Evidence Record into Events and inserting them into the system. You can read about the process in [Evidence Records](/data/evidence-records). 

Some Agents, such as Crossref Links and DataCite Links, create Events directly from their internal databases and skip the Evidence Record stage. In future, Agents operated by external parties may also do this. The reason for this is that Evidence Records exist to document how external data was processed, and to make transparent the internal processes within Event Data. When the data comes directly from the external source, we perform no extra processing, so there is nothing to document. External services which operate Agents may choose to run record their own form of Evidence, but these will be different to the standardized Crossref Event Data Evidence Records.