# Best Practice for Publishers

If you follow this best practice you will give CED the best chance of registering Events for your registered content. There are several factors that can impair, or completely prevent, us collecting Event Data. This is also all general good advice for running a website.

We collect data and generate reports about domains for which we are prevented from gathering Event Data. Please contact us for further information.

## Don't block the Event Data Bot

The Event Data Bot often needs to visit URLs to work out if they have DOIs. It will visit a publisher site and look for metadata in the page that indicates it's for an article with a DOI. 

If you block the Event Data Bot from your site, we will be unable to collect Events for your DOIs.

**Action:** Don't block the Event Data Bot.

## Don't have a restrictive robots.txt

The Event Data Bot respects robots.txt files. If it is instructed not to visit a site, it won't. If you prevent the Bot from accessing your article pages, we will be unable to collect Events from your DOIs.

**Action:** Don't have a restrictive robots.txt, or provide an exception for `CrossrefEventDataBot`.

## Include the DC Identifier

Including good metadata is general best practice for scholarly publishing. Follow the Dublin Core identifiers to include a DOI in each article page so the Percolator can match your landing pages back to DOIs. 

**Action:** Include a DC identifier meta tag in each article page, e.g. 

    <head>
      <meta name="dc.identifier" content="10.1371/journal.pone.0160617" />
    </head>


## Don't require cookies

Some Publisher sites don't allow browsers to visit unless cookies are enabled, and block visitors that don't accept them. If your site does this, we will be unable to collect DOIs for your events.

**Action:** Allow your site to be accessed without cookies.

## Don't require JavaScript to read your pages

Some Publisher sites require JavaScript to be enabled, and don't show any content to browsers that don't execute JavaScript. The Event Data Bot does not execute JavaScript when looking for a DOI. If your site does this, we will be unable to collect DOIs for your events.

**Actions:**

- Allow your site to be accessed without JavaScript.
- If you are unable to do do this, at least include the <meta name="dc.identifier">` tag in the HTML header.


