# The Event Data Service

This section describes the Event Data service and how to interact with it to get retrieve. Later sections describe what you should do once you've got it! The service comprises:

 - The **Query API** which provides access to Events in bulk,
 - The **Evidence Registry** which supplies supporting evidence and provenance information for Events,
 - The **Artifact Registry** which supplies supporting data used by Agents as they produce Events,
 - The **Status Service** which contains data on the performance and activity of the system.

Events are gathered by Agents, each of which monitors a particular data source.

<a name="data-sources"></a>
## Data Sources

Event Data is a hub for the collection and distribution of a variety of Events and contains data from a selection of Data Sources. Every Event is produced by an Agent operated by Crossref, DataCite or one of our partners. The Agent is responsible for connecting to an external Data Source and turning the data into Events. In some cases, the Agent is passing data through and in other cases the Agent has to do some work to extract the Event.

For detailed discussion of each Agent, see its corresponding page.


| Name                   | Source Identifier   | Provider    | What does it contain? |
|------------------------|---------------------|-------------|------------------|
| [Crossref to DataCite](sources/crossref_datacite)   | crossref_datacite   | Crossref    | Dataset citations from Crossref Items to DataCite Items |
| [DataCite to Crossref](sources/datacite_crossref)   | datacite_crossref   | DataCite    | Dataset citations from DataCite Items to Crossref Items |
| [Newsfeed](sources/newsfeed)               | newsfeed            | Crossref    | Links to Items on blogs and websites with syndication feeds |
| [Reddit](sources/reddit)                 | reddit              | Crossref    | Mentions and discussions of Items on Reddit |
| [Twitter](sources/twitter)                | twitter             | Crossref    | Links to Items on Twitter |
| [Web](sources/web)                    | web                 | Crossref    | Links of Items on web pages |
| [Wikipedia](sources/wikipedia)              | wikipedia           | Crossref    | References of Items on Wikipedia |
| [Wordpress.com](sources/wordpress-dot-com)          | wordpressdotcom     | Crossref    | References of Items on Wordpress.com blogs |
