# How data Contributors, Sources and Agents work

Every Event starts its life in a data Contributor. This section of the User Guide describes each Contributor and the kind of Events you may find for each. The term 'Source' is an internal label for the data Contributor and in some cases a particular way of looking at their data. It's the way we identify where each Event came from. Most data Contributors are represented by a single Source, but where a data Contributor has more than one type of data they may be represented by more than one Source. For example, Twitter is a data Contributor and we have a corresponding `twitter` source. Reddit is another data Contributor, but we have two Sources: `reddit` for the content of discussions that happen on reddit and `reddit-links` for the content of pages that are linked to from Reddit.

Every Source usually has one or more Agents dedicated to it. Each Agent connects to its Source and produces Events. The kind of data that the Source makes available, and the way that the Agent processes it, vary.

 - Some Sources send content which is refined by the Agent. This is how the Twitter and Reddit Agents work.
 - Some Sources send pointers to content, which the Agent then visits. This is how the Wikipedia and Newsfeeds Agents work.
 - Some Sources are custom-built to send Events directly. This is how the Crossref and DataCite Agents work.

## Common features in data collection

There are some common features and patterns that occur across Agents and the Percolator. 

### Reversing landing page domains back into DOIs

When a registered content item is linked to via its landing page, the Agent will identify the link and then pass it to the Percolator, which will attempt to convert the landing page URL back into a DOI. If it is unable to do this, no Event will be created. This process is the most dynamic and potentially variable step. You can read all about it in [Matching landing pages to DOIs](data/matching-landing-pages/).

### Issuing Queries for landing page domains

Many of the links that we track use the [Landing page URL of the Article](/data/ids-and-urls). We maintain an Artifact which contains all of the Domains we're interested in. Some external APIs, such as Reddit, allow queries to be issued for links by their domain. In cases like this, the Agent will periodically scan the API, issuing a query for each landing page domain.

### Following links

Some sources send links to things that must be consulted. For example, each RSS newsfeed contains links to Blog posts that must be processed to extract links. The Wikipedia Agent receives a stream of Wikipedia page URLs, each of which must be visited to extract links.

### Events and Evidence Records

Most Agents don't produce Events directly. Instead they produce Evidence Records, which are further processed into Events at a later. This means that the Agent only does the job of converting external data into the standard Evidence Record format.

The Percolator does the job of processing the Evidence Record into Events and inserting them into the system. You can read about the process in [Evidence Records](/data/evidence-records). 

Some Agents, such as Crossref Metadata and DataCite Metadata, create Events directly from their internal databases and skip the Evidence Record stage. In the future, Agents operated by external parties may also do this. The reason for this is that Evidence Records exist to document how external data was processed, and to make transparent the internal processes within Event Data. When the data comes directly from the external source, we perform no extra processing, so there is nothing to document. External services which operate Agents may choose to record their own form of Evidence, but these will be different to the standardized Crossref Event Data Evidence Records.
