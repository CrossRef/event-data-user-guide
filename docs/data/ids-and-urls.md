# IDs, URLs and the Web

In most cases an Event is generated when an Agent visits a webpage and notices a link between that webpage and a piece of Crossref Registered Content. The result is an Event where the Subject is the webpage and the Object is the Registered Content. We use the 'best possible' URL to refer to both the Subject and the Object.

When we say 'best' URL, we are trying to find the URL that uniquely represents the content. This allows people using the data to find Events that correspond to the same content. If a particular piece of content is referred to using a range of different URLs, it can be difficult or impossible to find Events that refer to it.

Broadly speaking, the best URL for a piece of Registered Content (i.e. the Object, such as a journal article) is a DOI. The best URL for a webpage (i.e. the Subject, such as a blog post) is its Canonical URL. 

## Canonical URLs for Subjects

When an Agent visits a webpage, it records the URL that it visited. The webpage itself may indicate the 'best' URL to use via a [Canonical URL link](https://en.wikipedia.org/wiki/Canonical_link_element). Including a Canonical URL in a webpage's metadata is search engine best practice ([encouraged, for example, by Google](https://webmasters.googleblog.com/2009/02/specify-your-canonical.html)).

A webpage may be accessed via a number of different URLs. To take a real example, the following three URLs all correspond do the same content:

 - `https://arstechnica.com/?p=1177597`
 - `https://arstechnica.com/science/2017/09/new-evidence-would-push-life-back-to-at-least-3-95-billion-years-ago/`
 - `https://arstechnica.com/science/2017/09/new-evidence-would-push-life-back-to-at-least-3-95-billion-years-ago/?comments=1&post=34078349`

Whilst it's important to record exactly where we looked to find a particular link, it's also important that we represent content as consistently as possible. The above webpage has metadata indicating the Canonical URL. When we identify a Canonical URL we use this URL as the `subj_id` in the Event. We store the URL we visited in the `subj.url` so you always know which URL we visited in the first place.

## Removing tracking URLs

Not all webpages provide Canonical URLs. When this happens we use the next-best URL, which is the one we visited. We apply a couple of cleaning steps first:

If the URL we visited resulted in any redirection (for example some RSS aggregators include their own redirection URL) we will record the final URL that we arrived at. This means that the URL that the content was recorded against may be different from the URL that was visited from a Newsfeed. An example of this is:

 - URL found in newsfeed: `http://feedproxy.google.com/~r/blogspot/wCeDd/~3/4ut6cGJY2FM/cshardware-inview-multi-pix-camera.html`
 - URL destination: `http://nuit-blanche.blogspot.co.uk/2017/09/cshardware-inview-multi-pix-camera.html`

Secondly, some services (such as the above example) apply tracking URL parameters. These do not affect the content, but allow people to track how URLs are shared. Common examples include `utm_source`, `utm_medium`, `utm_campaign` which are used by Google Analytics. The presence of these URL parameters can be confusing, as they mean that one piece of content can be represented by an infinite number of different URLs.

To counteract this, we remove a known set of tracking parameters from URLs before using them in the `subj_id` field. Here is an example:

 - URL that we visited: `http://nuit-blanche.blogspot.co.uk/2017/09/cshardware-inview-multi-pix-camera.html?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed:+blogspot/wCeDd+(Nuit+Blanche)`
 - URL that we use to record the content: `http://nuit-blanche.blogspot.co.uk/2017/09/cshardware-inview-multi-pix-camera.html`

## Which URL is used for `subj_id`?

When picking a `subj_id`, we use the following options in order:

 1. The Canonical URL as indicated in the HTML metadata.
 2. Failing that, URL where we found the content (if there were redirects, then the final destination), with tracking parameters removed.
 3. Failing that (e.g. if there were errors removing the tracking parameters), the URL that the Agent visited.

## DOIs for Objects

In most cases, the Object of an Event is a piece of Crossref or DataCite Registered Content. For these, the best URL to unambiguously identify the content is the DOI. The process of matching a DOI also confirms that it is actually a piece of Registered Content. If we cannot find the DOI, we cannot verify that it is Crossref Registered Content, so we do not produce an Event.

## We look for DOIs as well as Landing Pages

Event Data Agents are on the look out for links to Registered Content Items, but people on the Web use a variety of methods to refer to them. They could use a hyperlinked DOI (one you can click), or a plain-text DOI (one you can't click). They could also use the Article Landing Page (the page you get to when you click on a DOI). Every source is different: we tend to see most people using Article Landing Pages on Twitter, but on Wikipedia DOIs are frequently used.

Every Agent will attempt to match Registered Content Items in as broad a manner as possible by looking for linked and unlinked DOIs and Article Landing Page URLs. We maintain a list of domain names that belong to publishers (see the [Artifact](../service/artifact-registry) page for more information) and track and query for those domains. When we see a URL that could be a Landing Page, we attempt to match it to a DOI.

## Landing page matching isn't perfect

If we can't deduce that a Landing Page is for one of our Registered Content Items, then we won't generate an Event. After all, not every URL on every Publisher's site corresponds to an article.

If someone discusses an article on Twitter and uses its DOI, and that DOI exists, there's an almost certain chance that we will match it and produce an Event. If they discuss an article on Twitter and use its Landing Page URL, there's a very good chance that we will match it, but the matching process isn't perfect. 

You should therefore be aware of the difference between Events that were matched using the DOI and those that were matched using the Landing Page URL, and that we may have a better rate of matching for DOIs.

Matching also varies from Publisher to Publisher. For some Landing Page domains we can easily match the DOI. For some we need to do a bit more work. For others, it's impossible. 

We produce a full trace of **every attempt** in Evidence Records and Evidence Logs. See the Service pages for information on how to access these.

If you are a Publisher, refer to the [Best Practice for Publishers](../best-practice/publishers-best-practice) to ensure we have the best chance at matching Events for your content.

## You might want to know the difference

When we match an Event because someone discussed an Item using its DOI, the only processing that takes place is normalizing the DOI and checking that it exists. You can see the full process in the Evidence Record for that Event, even though there's not much to it.

When we match an Event because someone used a Landing Page, the Agent has to do some work to match it to a DOI. When we do this, we are making an implicit assertion that 'this Landing Page is for this DOI'. Our Agents reflect the data they find, so it's important to understand that this automated process and might not be 100% reliable.

You can put Event Data to different uses. You might want to know:

 - How often do people Tweet DOIs compared to Landing Page URLs?
 - I'm only interested in data where I can be 100% sure that only the DOI is used.
 - I want to know about these articles. I don't care what URL was used to refer to them.

When an Event links to a Registered Content Item (nearly all Events do) it will use its DOI as the `subj_id` or `obj_id`. The corresponding optional `subj` or `obj` metadata may contain a `pid` field (which is always the same) but additionally it may contain a `url` field.

If the URL field is the same as the PID field (i.e. a DOI) then you know that the Event was collected because its DOI was mentioned. If the URL field is different, (e.g. a Landing Page URL) then you know it was collected because the Landing Page domain was mentioned.


## It's always not one-to-one

DOIs can be assigned to books and book chapters, articles and figures. Each Agent will do its job as accurately as possible, with minimal cleaning-up, which could affect interpretation. 

This means that if someone Tweets the DOI for a figure within an article, we will record that figure's DOI. If they Tweet the Landing Page URL for that figure, we will do our best to match it to a DOI. Depending on the method used, and what the Publisher Landing Page tells us, we may match the article's DOI or the figure's DOI.

Sometimes two pages may claim to be about the same DOI. This could happen if a publisher runs two different sites about the same content. It's also possible that a Landing Page has no DOI metadata, so we can't match it to an Event.

The reverse is true: sometimes two DOIs point to the same Landing Page. This can happen by accident. It is rare, but does happen. This has no material effect on the current methods for reporting Events.

### Landing Page data can be out of date

We periodically scan our DOIs, take a sample and find the domains that are used by publishers. This is documented in our Artifacts, which have versions and date stamps. We therefore might miss Events in the time between a new domain being used and the Artifact being updated.

If a publisher stops using an Article Landing Page domain, we will not remove it from the list. Agents may at any time go back and re-process old data, or work with dumps of historical data. People may retweet old tweets which point to old Landing Pages. We still want to attempt to match these if possible. Therefore the domain list Artifact only grows. As with all Artifacts, you can browse all past versions to see how it changes over time. 

### We don't match all domains

Some DOIs have been registered to domains such as `youtube.com`. We have no way of matching YouTube videos back to DOIs. So, we exclude this small number of domains that we can never match.

### We don't know all of the Landing Page URLs, and it's not possible to discover them all

Every DOI has a Resource URL, which is where you are sent when you click on a DOI hyperlink. This is known to Crossref and can be retrieved from the DOI system. However, in a large number of cases, this is not the final destination URL. Many publishers operate their own internal linking and redirecting services, which mean that when you click on a DOI you are sent through a series of redirects before ending up at the destination Article Landing Page.

Let's take a simple example of a Crossref demonstration DOI. The Crossref DOI `10.5555/12345678` has the Resource URL `http://psychoceramics.labs.crossref.org/10.5555-12345678.html`, which you can see in the [article metadata](http://api.crossref.org/works/10.5555/12345678/transform/application/vnd.crossref.unixsd+xml). If we follow the DOI we see only one redirect, that from the DOI link.

| URL | Comment |
|-----|---------|
| `https://doi.org/10.5555/12345678` | Initial DOI redirect from Resource link |
| `http://psychoceramics.labs.crossref.org/10.5555-12345678.html` | Finished |

In cases like this, the Landing Page is known to Crossref, as it's the same as the Resource link.

Let's take another example, the PLOS DOI `10.1371/journal.pone.0160106`. The Resource link, which you can see in the [article metadata](http://api.crossref.org/works/10.1371/journal.pone.0160106/transform/application/vnd.crossref.unixsd+xml) is `http://dx.plos.org/10.1371/journal.pone.0160106`, which is an internal link resolver operated by PLOS.

If we follow the DOI URL, we see the following chain of redirects.

| URL | Comment |
|-----|---------|
| `http://doi.org/10.1371/journal.pone.0160106` | Initial DOI redirect from Resource link |
| `http://dx.plos.org/10.1371/journal.pone.0160106` | Internal redirect within PLoS Site |
| `http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0160106` | Internal redirect within PLoS Site |
| `http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0160106` | Finished |

In cases like this, the final Landing Page is different to that registered with Crossref, so we can't know without following it. 


In some cases, Publisher sites implement checks which prevent automated access, such as requiring cookies and performing redirects using JavaScript. In this example the DOI has been anonymized, but it is based on a real example. Trying to resolve the DOI `10.XXX/YYY.06.008` without cookies enabled produces:

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

Crossref [Membership rules #7](https://www.crossref.org/02publishers/59pub_rules.html) state that: 

> You must have your DOIs resolve to a page containing complete bibliographic information for the content with a link to — or information about — getting the full text of the content.

Where publishers break these rules, we will alert them.

Because of restrictions like this, along with other practical constraints, we cannot and do not attempt to visit every DOI ahead of time to find its Landing Page. 

<a href="concept-external-doi-mappings"></a>
### External Parties Matching Content to DOIs 

Crossref Agents are not the only ones creating Events, and therefore not the only ones that produce DOI-to-URL mappings.

It is possible for an external party to store activity around Items and use their own systems to match Items to DOIs, Landing Pages and other identifiers. Although their APIs can be queried using DOIs, they might have recorded activity against the Item using its Landing Page URL or another identifier. The internal mappings between various identifiers may change from time to time, which may mean that certain activity may be reported against one Item at one point in time, and then against another Item at another point in time. Data may therefore change over time and this may be caused by algorithms being updated, rather than user activity.

Event Data provides all available Evidence for all Events, but is unable to provide visibility of mappings within external services. Data from these sources of this type should be interpreted with this in mind.
