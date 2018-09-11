# Introduction

Before the growth of the Web, most discussion around scholarly content stayed in scholarly content, with articles referencing each other. With the growth of online platforms for discussion, publication and social media, we have seen discussions occur in new, non-traditional places.

The Event Data service captures this activity and acts as a hub for the storage and distribution of this data. The service provides a record of instances where research has been bookmarked, linked, liked, shared, referenced, commented on etc, beyond publisher platforms. For example, when datasets are linked to articles, articles are mentioned on social media or referenced in Wikipedia.

This data is of interest to a wide range of people: Publishers may want to know how their articles are being shared, Authors might want to know when people are talking about their articles, Researchers may want to conduct bibliometrics research. And that's just the obvious uses.

When a relationship is observed between a Crossref-Registered Content Item and a specific web activity, the data is expressed in the service as an 'Event'. The Service provides Events from a variety of web sources. Each web source is referred to as a 'Data Contributor'. The Events, and all original data from the Data Contributor, are available via an API.

Registered Content is the name we give to items that are registered with Crossref, and to which DOIs have been assigned. This includes Articles, Books and Datasets. When the phrase 'Registered Content Item' is used, you can usually think of a journal article, but be aware that it can apply to any piece of content that was registered with Crossref.

Additionally, Event Data not only collects this data but also serves as an open platform for third parties to make their own activity data available to everyone. Anyone can build tools, services and research using this platform.

<img src='../images/overview.png' alt='Event Data Overview' class='img-responsive'>

## Events

Every time we notice that there is a new relationship between a piece of Registered Content and something out in the web, we record that as an individual Event. Examples include:

 - an article was linked from a DataCite dataset via its Crossref DOI
 - an article was referenced in Wikipedia using its Crossref DOI
 - an article was mentioned on Twitter using its Article Landing Page URL

In this illustration every arrow connects two 'things':

<img src='../images/overview-example.png' alt='Blogs, Tweets and Articles' class='img-responsive'>

1. A Tweet was published that discusses an Article 1.
2. A blog post was published that discusses Article 1.
3. The blog post also discusses Article 2.
4. A Wikipedia Article was published that referenced Article 2.

That makes four Events.

### Subject - Relation - Object

An Event connects two 'things' with a particular relation type, like 'discusses'. Just like a 'subject verb object' sentence, every Event has a Subject, Relation type and Object field. The subject and/or object of an Event is usually a Registered Content Item, referred to with its DOI.

For example:

| Field         | Value | Reads |
|---------------|-------|-------|
| subject       | http://blog.example.com/1 | "The blog post with the URL http://blog.example.com/1 ..." |
| relation type | discusses | " ... discusses ... " |
| object        | https://doi.org/10.5555/123456789 | " ... the article with the DOI http://doi.org/10.5555/123456789 ... " |
| occurred at   | 2017-01-01 | "... on the 1st of January 2017 ..." |
| timestamp     | 2017-02-02 | "... and we first knew about it on the 2nd of January 2017." |

Events vary from source to source, but they have a common set of fields:

 - the **subject** of the event, e.g. Wikipedia article on Fish
 - the **type of the relation**, e.g. "references"
 - the **object** of the event, e.g. article with DOI 10.5555/12345678
 - the date and time that the event **occurred**
 - the date and time that the event was **collected and processed**
 - a **total** for when an Event has a quantity
 - the **source** of the data, known in the service as the Data Contributor
 - optional **bibliographic metadata** about the **subject** (e.g. Wikipedia article title, author, publication date)
 - optional **bibliographic metadata** about the **object** (e.g. article title, author, publication date)

## Transparency and Data Quality

Data comes from sources all over the Web and each source is subject to different types of processing. Transparency of each piece of Event Data is crucial: *where* it came from, *why* it was selected, and *how* it was processed and by *whom*.

Every Event starts its journey somewhere, usually in an external source. Data from that external source is processed and analysed, and, if we're lucky, one or more Events are created. The entire process is transparent: what data we were working from, what we extracted and how, and how that relates to each Event. Nearly all Events that Crossref generate are linked back to an Evidence Record, which documents its journey.

<img src='../images/introduction-evidence-flow.png' alt='Event Data Evidence Flow' class='img-responsive'>

Crossref Event Data was developed alongside the NISO recommendations for Altmetrics Data Quality Code of Conduct, and we participated in the Data Quality working group. Event Data aims to be an example of openness and transparency. You can read the [Event Data Code of Conduct Self-Reporting table](app-niso.md) in the Appendix.

## Accessing the Data

Crossref Event Data is available via our Query API. The Query API allows you to make requests like:

 - give me all Events that were collected on 2017-12-08
 - give me all Events that occurred on 2016-12-08
 - give me all the Reddit Events that were collected on 2016-12-08
 - give me all the Events that occurred for this DOI on 2017-01-08
 - give me all the Twitter Events that occurred for this DOI on 2017-01-08

The Query API allows you to collect Event Data in bulk, to make sure you're up to date.

## Reliability and Monitoring

The Evidence Logs describe the activity undertaken during the process of creating Events. This includes external API access.

## Interpretation

Interpretation is a significant theme in Event Data, and it's something you must bear in mind when using the data. Every Event describes where it came from and who collected it. An Event can be interpreted several different ways. It's up to you to bear the origin and meaning of each Event in mind. This is discussed throughout the User Guide.

## Service Level Agreement

*This feature will be available once Event Data is a production service*

We will introduce a Service Level Agreement which will provide agreed service levels for responsiveness of the service. It will also include APIs for access to data.
