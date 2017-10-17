# Duplication and Redundancy

Event Data has a number of Agents which monitor different data sources. It also provides a pipeline through which other Agents can publish data. Crossref Agents will try to avoid producing redundant Events, but make no guarantee of uniqueness.

## Duplication in the Event Data Service

The Event Data Service places a unique constraint on Event IDs. This means that Event ID `49578f7c-9009-4a13-994a-9c251a4daafd`, for example, can only ever occur once. The services places **no other constraints** on the uniqueness of any aspect of the data.

This means that, for example, the following things are possible:

 - two Agents may report on the same thing that happened, producing two or more separate Events
 - an Agent may report on the same thing that happened twice, producing two or more separate Events
 - an Agent may re-process the same input, producing the repeated identical Events

## Interpreting meaning of duplicate Events

There are different meanings of 'duplicate', which might include:

 - two or more Events that are completely identical except for the ID
 - two or more Events that have the same subject and object IDs

In the first case, you could interpret two or more completely identical Events as duplicates and simply ignore the duplicates. In the second case, you have a choice about whether or not you treat them as duplicates, and what you do with them.

### Duplicate Events from the same input

Two Agents might have looked at the same piece of data and produced the same Event. They might have processed them under different circumstances. For example, an agent that specifically monitors Wikipedia may have generated an Event for a DOI that occurs on the page. A general purpose web agent might also have become aware of a page, and might have visited it and found the same DOI. In this situation you might find two Events for the same DOI in the page.

### Duplicate inputs

The same content may be served on separate domains on the web. For example, some sites offer desktop and mobile versions. If these are served on different domains, they will be found on different URLs. If the Web agent finds these, it will treat them as different pages, which may result in two Events that link to the desktop and mobile versions of the site respectively. Another example is Google's Blogspot service, which may publish the same blog on a number of different country domains.

### Canonical URLs

As described in [IDs and URls](ids-and-urls), if a webpage provides a Canonical URL we will use it to refer to that webpage. We also include the `subj.url`, which is the URL that was actually visited. The Newsfeed Agent may visit the same blogpost more than once, but if it does this you you filter out repeated observations of the same links by ignoring duplicate `subj_id`, `obj_id` pairs.

### DOIs vs Landing Pages

The Crosref Agents attempt to convert Every link or mention of an item to an Event. On some pages, for example Wikipedia, the same reference may be linked several different ways. An Agent treats each of these links independently, which means that you may see more than one link between a given Wikipedia page and an article by their `subj_id` field, but the `subj.url` will indicate different URLs.

How you interpret these is up to you. For some use-cases, it is important to be able to tell the difference between links via an Article Landing Page and the DOI. In some cases, for example component DOIs or DOIs that represent versioned content, the DOI could more specific than the Article Landing Page. In other cases, it's not so important, so duplicates can be removed based on the `subj_id` and `obj_id`.

## Duplication as Corroboration

Every source has different characteristics which must be taken into account when deciding how to interpret the data, including classification and mitigation of duplicates. However, you may find that between sources, the presence of a duplicate indicates something. For example, if two entirely different sources make the same assertion that links two things, and they are working from different data, you might wish to treat that duplication as a corroboration of the assertion. 

## Repeated Observations

The Web source Agent may check the same webpage more than once over time. In this case it may make the same observations repeatedly. If you find an Event that has a duplicate, or is very similar to another Event made a while ago, this may be the reason.

## Crossref Event Data tries not to produce duplicate Events.

All of the above said, all Agents operated by Crossref co-operate to avoid producing duplicate Events. 
