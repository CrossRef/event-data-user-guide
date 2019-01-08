# Best practice for publishers

If you follow this best practice you will give Event Data the best chance of registering Events for your registered content. There are several factors that can impair, or completely prevent, us collecting Event Data. This is also all general good advice for running a website.

We collect data and generate reports about domains where we are prevented from gathering Events from. Please contact us for further information.

## Don't block Event Data Agents

The Event Data Agents often needs to visit URLs to work out if they have DOIs. It will visit a publisher site and look for metadata in the page that indicates it's for an article with a DOI. 

If you block the Event Data Agents from your site, we will be unable to collect Events for your DOIs.

**Action:** Don't block the Event Data Agents.

## Don't have a restrictive robots.txt

The Event Data Agents respects robots.txt files. If it is instructed not to collect content from a site, it won't. If you prevent the Agents from accessing your article pages, we will be unable to collect Events for your DOIs.

**Action:** Don't have a restrictive robots.txt, or provide an exception for `CrossrefEventDataBot`.

## Include the DC identifier

Including good metadata is general best practice for scholarly publishing. Follow the Dublin Core identifiers to include a DOI in each article page, so the Percolator can match your landing pages back to DOIs. 

**Action:** Include a DC identifier meta tag in each article page, e.g. 

    <head>
      <meta name="dc.identifier" content="10.1371/journal.pone.0160617" />
    </head>


## Don't require cookies

Some publisher sites don't allow browsers to visit them unless cookies are enabled, and they block visitors that don't accept them. If your site does this, we will be unable to collect DOIs for your Events.

**Action:** Allow your site to be accessed without cookies.

## Don't require JavaScript to read your pages

Some publisher sites require JavaScript to be enabled, and they don't show content to browsers that don't execute JavaScript. The Event Data Agent does not execute JavaScript when looking for a DOI. If your site does this, we will be unable to collect DOIs for your Events.

**Actions:**

- Allow your site to be accessed without JavaScript.
- If you are unable to do do this, at least include the `<meta name="dc.identifier">` tag in the HTML header.

## Review terms of use

You should be familiar with the [Terms of Use](https://www.crossref.org/services/event-data/terms/).
