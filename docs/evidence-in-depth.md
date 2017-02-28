# Evidence in Depth

Every Event has an Evidence Record. Each Evidence Record corresponds to an input from an external source. Each Evidence Record has links to supporting data in the form of Artifacts.

The Evidence Service links Events to their Evidence.

## Artifacts

An Artifact is an input to an Agent that's required to process its External Input. It provides the necessary context or supporting data that enables an Agent to produce Events. 

The structure of each type of Artifact file is chosen to best suit the data, and is described per-source below.

### List of Artifact types

You can see the complete list of Artifacts that is currently in use at the API endpoint [http://evidence.eventdata.crossref.org/artifacts](http://evidence.eventdata.crossref.org/artifacts).

#### Currently Available

| Type name              | Description                      | Example URL                                                                                                |
|------------------------|----------------------------------|------------------------------------------------------------------------------------------------------------|
| doi-prefix-list        | List of DOI prefixes             | http://evidence.eventdata.crossref.org/artifacts/doi-prefix-list/versions/797e77470ed94b2f7b336adab4cbaf19 |
| domain-list            | Landing Page Domain list         | http://evidence.eventdata.crossref.org/artifacts/domain-list/versions/1b2bcc1f6e77196b9b40be238675101c     |
| newsfeed-list          | Newsfeed list                    | http://evidence.eventdata.crossref.org/artifacts/newsfeed-list/versions/41ac1c7ecf505785411b0e0b498c4cef   |

#### Planned

| Type name              | Description                      | Example URL                                                                                                |
|------------------------|----------------------------------|------------------------------------------------------------------------------------------------------------|
| high-dois              | High priority DOI list           | http://evidence.eventdata.crossref.org/artifact/high-dois-d41d8cd98f00b204e9800998ecf8427e                 |
| medium-dois            | Medium priority DOI list         | http://evidence.eventdata.crossref.org/artifact/medium-dois-d41d8cd98f00b204e9800998ecf8427e               |
| all-dois               | Entire DOI list                  | http://evidence.eventdata.crossref.org/artifact/entire-dois-d41d8cd98f00b204e9800998ecf8427e               |
| high-urls              | High priority URL-DOI mapping    | http://evidence.eventdata.crossref.org/artifact/high-urls-d41d8cd98f00b204e9800998ecf8427e                 |
| medium-urls            | Medium priority URL-DOI mapping  | http://evidence.eventdata.crossref.org/artifact/medium-urls-d41d8cd98f00b204e9800998ecf8427e               |
| entire-urls            | Low priority URL-DOI mapping     | http://evidence.eventdata.crossref.org/artifact/entire-urls-d41d8cd98f00b204e9800998ecf8427e               |
| «software-name»        | The name and version of software | http://github.com/crossref/event-data-facebook-agent/tags/v2.5                                             |

<a name="artifact-doi-prefix-list"></a>
#### DOI Prefix List

This is the list of DOI prefixes, e.g. `10.5555/`. It is used when looking for DOIs. It contains every DOI prefix for all Crossref Members.

<a name="artifact-newsfeed-list"></a>
#### Newsfeed List

This is a list of RSS and Atom newsfeed URLs. It is manually curated. Each part file contains a list of URLs that are RSS or Atom Newsfeeds. 

We run the Newsfeed Detector software on our DOI Resolution logs to find websites that refer to DOIs. For each website we find, we probe it to try and discover if it has an RSS or Atom newsfeed that we can subscribe to.

The list is manually curated from known blogs and updated every month or two with input from the Newsfeed Detector.

If you think a newsfeed is missing from the list, please contact eventdata@crossref.org .

<a name="artifact-domain-list"></a>
#### Domain List

This is a list of domains that DOIs resolve to. The list is created by the Thamnophilus service, which crawls every DOI to find its landing page, and records the domain. The Artifact Part files contain a list of domain names, one per line.

The data is generated automatically but manually curated to some extent. As some DOIs resolve to domains such as `google.com` and `youtube.com`, it is simply impractical to use them.

By providing the domain list as an Artifact, you can answer questions like "why wasn't this landing page matched". 

For context see [Pre-filtering Domains](concepts#concept-pre-filtering).

<a name="artifact-doi-list"></a>
#### High Priority, Medium Priority, Entire DOI List

This is a list of Crossref DOIs that are deemed to be high-priority, medium-priority respectively, and the list of all DOIs. The content of an Artifact Part File is a list of DOIs (expressed without a resolver, e.g. `10.5555/12345678`), one per line. 

For Agents that consume a list of DOIs (e.g. Mendeley) these constitute the list of DOIs that the Agent will query for. Every Evidence Record will contain a link to the Artifact that gave rise to the Event.

The High Priority list contains DOIs that have been recently published and for which it is likely we will find Events. Agents that use this list will poll using it on a regular basis.

The Medium list contains DOIs that have been less recently published. Agents that use this list will poll on a less regular basis.

The Entire list contains all DOIs, over 80 million. Agents will try to collect data for all of these, but are limited by the size of the list.

**Note:** Every crawl of a set of DOIs uses a DOI list Artifact ('high', 'medium' or 'all'). Therefore, if you get the Artifact that was used for a given Event ID, you can check the list of DOIs that was used as part of the crawl.

**Note:** DOI list Artifacts are used to generate crawls for certain Agents. You may find Events with DOIs that were not part of the list.

DOI Lists are produced by the Thamnophilus service.

<a name="artifact-url-list"></a>
#### High-priority, Medium Priority, Entire URL list

Every DOI resolves to a URL, at least in theory. The URL lists contain the mapping of DOIs to URLs (and vice versa) where there is a unique mapping. The content of the Part files are alternating lines of DOI, URL.

This file is generated by the Thamnophilus service, which maintains a list of all DOIs and follows each one to see where it leads. If two DOIs point to the same URL then then the mapping is considered ambiguous and it is not included in the Artifact.

The contents of this Artifact change over time for a number of reasons:

 - new DOIs are added
 - it can take time to resolve all of the DOIs, so not all may have been resolved at a different point in time
 - the landing page for a DOI may have changed, meaning the URL has changed
 - we discover an ambiguity that wasn't previously present so the DOI must be removed from the list

The lists are used in a number of places:

 - Agents that query by landing page URL, e.g. Facebook . Like the DOI list, the three URL lists are used to schedule scans at high, medium and low frequencies.
 - The [DOI Reversal Service](concepts#in-depth-doi-reversal), which transforms landing pages back into DOIS for Agents like Twitter

This may be used to answer questions like:

 - When you gathered data for this DOI, e.g from Facebook, which URL did you use to query it?
 - The landing page for a DOI changed. At what point did you start using the new URL to query for it?

**Note:** This Artifact is used by querying Agents such as the Facebook Agent. Other sources may report Events for mappings that are not on this list.



#### Software Name and Version

Every piece of software that's running as part of Event Data is an Artifact, including all of the Agents. An Agent will include a reference to it's currently running version in any Evidence Log records that it produces. Note that links will be to a tagged release in a source code repository (Github), therefore don't use the Artifact Record structure.

### Artifacts in the Evidence Service

The Evidence Service maintains a list of all of the Artifacts.

You can use the Evidence Service to retrieve the most recent version, or previous versions, of an Artifact.

 - To retrieve the current newsfeed list, for example, visit `http://evidence.eventdata.crossref.org/artifacts/newsfeed-list/current` and you will be directed to the current Artifact Record. 
 - To retrieve the list of versions of the newsfeed, and what date they were created, visit `http://evidence.eventdata.crossref.org/artifacts/newsfeed-list/versions` and you will be shown a list of all versions with date stamps.
 - To see when new versions of software components, e.g. Agents, were released.

### Finding Artifacts for an Event

Every Event has a corresponding Evidence Record, which contains a link to all of the Artifacts that were used to construct the Event. Therefore, to find the list of newsfeeds that was used to produce a blog reference Event:

 - Retrieve the ID from the Event, e.g. `06630d1f-3add-4478-a2c8-faa38728e0d8`
 - Query the Evidence Service to find the Evidence by visiting `http://evidence.eventdata.crossref.org/events/06630d1f-3add-4478-a2c8-faa38728e0d8/evidence`
 - You will see the list of Evidence Links in the response.

<a name="in-depth-evidence-records"></a>
## Evidence Records in Depth

An Agent is responsible for fetching data from an external Data Source and extracting Events from the input data. An Evidence Record is created by an Agent as the result of an input from an external Data Source. It contains the input, the resultant Events, and all the state and information necessary to support the resulting Events.

Every Evidence Record contains the following sections:

 - `input` - the data that entered the system from an external source
 - `artifacts` - the Artifacts that were used in processing
 - `agent` - the name and version of the Agent
 - `state` - any relevant pieces of state 
 - `working` - any internal working that is relevant to the processing of the input
 - `events` - any resulting Events

The precise content of each of these sections varies from Agent to Agent.

### Input

The Input contains the data input from the external source. It may contain the precise input an HTTP body, or some reduction of the input. The Input contains all information necessary to construct the Events.

### Artifacts

The Artifacts that were consumed by the Agent in the course of processing the Input.

### Agent

Internal data about the Agent, including the version number.

### State

Any extra state information necessary to process the Input. For example, because the Newsfeed Agent often checks newsfeeds more regularly than they are updated, it might see the same blog post URL in the Newsfeed twice. 

### Working

Any working data that the Agent produces in the course of generating the Event that might be useful to know. For example, the Newsfeed Agent provides the list of Blog URLs that it considered. If it is unable to retrieve a blog post URL, it will record it here.

### Events

All the Events that were produced. These are in Lagotto Deposit format, which is very similar to the Event format. Each event has an ID, which can be used to track it.
