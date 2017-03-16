# IDs, URLs and the Web

Event Data tracks relationships between research objects. Some are objects out on the web, like tweets and blog posts. Some are items of registered content with DOIs, like articles. Some of them have DOIs. All of them have URLs.

## We look for DOIs as well as Landing Pages

Event Data Agents are on the look out for Registered Content Items. Every Item has a DOI, and people may use it when referencing an article. Every Agent works slightly differently, but where possible, they look for doi.org domain in hyperlinks, as well as text that looks like DOIs (e.g. something that starts with `10.5555/`).

Registered Content Items have Landing Pages, occasionally more than one. Landing Pages are URLs that typically live on Publishers' websites or platforms. When you click on a DOI you are directed toward the landing page.

Because DOIs redirect to landing pages, most of the time when someone shares an article, they do it from the landing page, not from the DOI. Because people tend to discuss articles using their landing pages, CED Agents are on the look out for those too. 

We maintain a list of domain names that belong to publishers (see the [Artifact](../service/artifact-registry) page for more information) and track and query for those domains. When we see a URL that could be a Landing Page, we attempt to match it a DOI.

## Landing page matching isn't perfect

If we can't deduce that a landing page is for one of our items of registered content, then we won't generate an Event. After all, not every page on every Publisher's site is a Article.

If someone discusses an article on Twitter and uses its DOI, and that DOI exists, there's an almost certain chance that we will match it and produce an Event. If they discuss an article on Twitter and use its landing page URL, there's a very good chance that we will match it, but the matching process isn't perfect. 

You should therefore be aware of the difference between Events that were matched using the DOI and those that were matched using the Landing Page URL, and that we may have a better rate of matching for DOIs.

Matching also varies from Publisher to Publisher. For some landing pages domains we can easily match the DOI. For some we need to do a bit more work. For some, it's impossible. 

We produce a full trace of **every attempt** in the Evidence Registry. We also generate reports of which domains we attempted to match, and the success rates. See the Service pages for information on how to access these.

If you are a publisher, refer to the [Best Practice for Publishers](../best-practice/publishers-best-practice) to ensure we have the best chance at matching Events for your content.

## You might want to know the difference

When we match an Event because someone discussed an Item using its DOI, the only processing that takes place is normalising the DOI and checking that it exists. You can see the full process in the Evidence Record for that Event, even though there's not much to it.

When we match an Event because someone used a Landing Page, the Agent has to do some work to match it to a DOI. When we do this, we are making an implicit assertion that "this landing page is for this DOI". We are confident in the accuracy of our Agents, but it's important to understand that this is an automated process and might not be 100% reliable.

You can put Event Data to different uses. You might want to know:

 - how often do people Tweet DOIs compared to Landing Pages URLs?
 - I'm only interested in data where I can be 100% sure that only the DOI is used
 - I want to know about these articles. I don't care what URL was used to refer to them

When an Event links to a piece of Registered Content (nearly all most Events do) they will use its DOI as the `subj_id` or `obj_id`. The corresponding optional `subj` or `obj` metadata may contain a `PID` field (which is always the same) but additionally it may contain a `URL` field.

If the URL field is the same as the PID field (i.e. a DOI) then you know that the Event was collected because its DOI was mentioned. If the URL field is different, (e.g. a landing page URL) then you know it was collected because the landing page domain was mentioned.


## It's always not one-to-one

DOIs can be assigned to books and book chapters, articles and figures within them. Each Agent will do its job as accurately as possible, with minimal cleaning-up, which could affect interpretation. 

This means that if someone Tweets the DOI for a figure within an Article, we will record that figure's DOI. If they Tweet the Landing Page URL for that figure, we will do our best to match it to a DOI. Depending on the method used, and what the Publisher landing page tells us, we may match the Article's DOI or the Figure's DOI.

Sometimes two pages may claim to be about the same DOI. This could happen if a publisher runs two different sites about the same content. It's also possible that a Landing Page has no DOI metadata, so we can't match it to an Event.

The reverse is true: sometimes two DOIs point to the same landing page. This can happen by accident. It is rare, but does happen. This has no material effect on the current methods for reporting Events.

### Landing Page data can be out of date

We periodically scan our DOIs, take a sample and find the domains that are used by Publishers. This is documented in our Artifacts, which have versions and date stamps. We therefore might miss events in the time between a new domain being used and the Artifact being updated.

If a publisher stops using an article landing page domain we will not remove it from the list. Agents may at any time go back and re-process old data, or receive dumps of historical data. People may retweet old tweets that point to old landing pages. We still want to attempt to match these if possible. Therefore the domain list Artifact only grows.

### We don't match all domains

Some DOIs have been registered to domains such as `youtube.com`. We have no way of matching these. So, for the small number of domains that we can never match and produce a high volume of unusable input, we maintain the `exclude-domains` Artifact that lists domains that we explicitly won't check.

### We don't know all of the landing page URLs, and it's not possible to discover them all

Every DOI has a Resource URL, which is where you are sent when you click on a DOI hyperlink. However, in a large number of cases, this is not the final destination URL. Many publishers operate their own internal linking and redirecting services. You may end up following a large number of hops to find the landing page.

Let's take a simple example of a Crossref demonstration DOI. The Crossref DOI `10.5555/12345678` has the Resource URL `http://psychoceramics.labs.crossref.org/10.5555-12345678.html`, which you can see in the [article metadata](http://api.crossref.org/works/10.5555/12345678/transform/application/vnd.crossref.unixsd+xml). If we follow the DOI we see only one redirect, that from the DOI link.

| URL | Comment |
|-----|---------|
| `http://doi.org/10.5555/12345678` | Initial DOI redirect from Resource link |
| `http://psychoceramics.labs.crossref.org/10.5555-12345678.html` | Finished |

In cases like this, the Landing Page is known to Crossref, as it's the same as the Resource link.

Let's take another example, the PLoS DOI `10.1371/journal.pone.0160106`. The Resource link, which you can see in the [article metadata](http://api.crossref.org/works/10.1371/journal.pone.0160106/transform/application/vnd.crossref.unixsd+xml) is `http://dx.plos.org/10.1371/journal.pone.0160106`.

If we follow the DOI URL, we see the following chain of redirects.

| URL | Comment |
|-----|---------|
| `http://doi.org/10.1371/journal.pone.0160106` | Initial DOI redirect from Resource link |
| `http://dx.plos.org/10.1371/journal.pone.0160106` | Internal redirect within PLoS Site |
| `http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0160106` | Internal redirect within PLoS Site |
| `http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0160106` | Finished |

In cases like this, the final Landing Page is different to that registered with Crossref, so we can't know without following it. 


In some cases, Publisher sites implement checks which prevent automated access, such as requiring cookies and performing redirects using JavaScript. For example, trying to resolve the anonymised DOI `10.XXX/YYY.06.008` without cookies enabled produces:

| URL | Comment |
|-----|---------|
| `http://doi.org/10.XXX/YYY.06.008` | Initial DOI redirect|
| `http://FFF.AAA.com/retrieve/pii/DDD` | Internal redirect |
| `http://FFF.AAA.com/retrieve/articleSelectPrefsTemp?Redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&key=71835a2ddc744fbddf6d9a5a9003a4aced4b81a1` | Internal redirect |
| `http://www.CCC.com/retrieve/pii/DDD` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&rc=0&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=1&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=2&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=3&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=4&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=5&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=6&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=7&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=8&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=9&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `https://secure.BBB.com/action/getSharedSiteSession?rc=10&redirect=http%3A%2F%2Fwww.CCC.com%2Fretrieve%2Fpii%2FDDD&code=EEE` | Internal redirect |
| `http://secure.BBB.com/action/cookieAbsent` | Final error page |

The final step in this chain is an error page stating that cookies are required and it is therefore impossible to resolve the DOI using HTTP.

Crossref [Membership rules #10](http://www.crossref.org/02publishers/59pub_rules.html) state that 

> links enabled by Crossref must resolve to a response page containing no less than complete bibliographic information about the target content

Where publishers break these rules, we will alert them.

We have no automatic way to knowing when we do know the landing page. This means that if we wanted to collect every Landing Page URL, we would have to follow every single Resource link to discover where it leads.

In order to find the Landing Page for every DOI, we would have to follow each and every individual link. This is not practical at scale, and impossible in some cases. **We therefore can't, and don't attempt to discover every landing page URL ahead of time.** Our process instead tries to look for possible landing pages and then connect them back to DOIs.

<a href="concept-external-doi-mappings"></a>
### External Parties Matching Content to DOIs 

Crossref Agents are not the only ones creating Events, and therefore not the only ones that produce DOI to URL mappings.

It is possible for an external party to store activity around Items and use their own systems to match Items to DOIs, Landing Pages and other Identifiers. Although their APIs can be queried using DOIs, they might have recorded activity against the Item using its Landing Page or another Identifier. The internal mappings between various identifiers may change from time to time, which may mean that certain activity may be reported against one Item at one point in time and then against another Item at another point in time. Data may therefore change over time and this may be caused by algorithms being updated rather than user activity.

CED provides all available Evidence for all Events, but is unable to provide visibility of mappings within external services. Data from these sources of this type should be interpreted with this in mind.
