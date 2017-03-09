# Sources and Agents

Every Data Source exists for a different reason, and therefore provides a different style of data. Every Agent operates slightly differently, according to its source. When you consume Events you should be mindful of the source they came from and the Agent that processed them.

<a name="concept-relevant-source"></a>

### Sources that send only relevant Data

Some sources, such as "DataCite Crossref" and "Crossref DataCite" are specialists in the Scholarly Publishing space. They send data to CED, and each item of Data that is sent can be converted into an Event. This is highly efficient, as it means that no data or time is wasted.

<a name="concept-pre-filtering"></a>
### Pre-filtering URLS by their Domain

Some sources, such as Twitter and Reddit support queries by domain. This means that the Agent has to issue each Query once per domain to perform a full scan of the corpus of Items. In these cases the `domain-list` Artifact is used. It contains around 15,000 domains. In these cases, some data is sent that cannot be matched to an Event, but the ratio is still very high.

When an Agent of this type connects to a Data Source it will conduct a search for this domain list. In the case of Twitter that means constructing a ruleset that includes all domains. In the case of Reddit and Wordpress.com it means conducting one search per domain. This initial filter returns a dataset which mentions one of the domains that is found to contain Landing Pages. From this pre-filtered dataset the Agent then examines each result for Events.

Every Agent that uses the `domain-list` Artifact includes a link to the version of the Artifact they used when they conducted the query.

<a name="concept-query-entirety"></a>
### Sources that must be queried in their entirety

Some sources have no means of filtering or querying and must be downloaded in their entirety. These sources generally contain a high amount of relevant content, so the chance of being able to extract Events is high, and this method isn't wasteful.

Examples of these sources are Newsfeeds. The Newsfeed agent consumes all the data in each Newsfeed and then filters them for Events. As Newsfeed List is curated to include only blogs that are likely to feature links to Items that can be extracted, this approach is reasonably efficient.

<a name="concept-external-agents"></a>
## External Agents

Most Agents are operated by Crossref or DataCite (see [Data Sources](service#data-sources)). Some are operated by external parties. We welcome new Data Sources.

Where Crossref operates the Agent we provide full Evidence records for each Event. Where the Agent is operated by another party, they may or may not provide full Evidence. See [Not all Events need Evidence](evidence#evidence-not-all) for further discussion.

## Trust the Source, not Event Data

We work hard to ensure that the Events our Agents produce are reliable and correct, and will partner with organisations that we believe to be trustworthy. However, the Crossref Event Data service acts only as a conduit for this data. When deciding how to interpret an Event, you should bear in mind its source, the Agent that processed it.

We provide full Evidence Records for this purpose.