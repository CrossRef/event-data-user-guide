# Getting started

So you've read and understood the Event Data user guide, but how do you actually get started using Crossref Event Data?

## Intentions

1. Decide which sources you are interested in. You may want to build a map of everything, or you may only want a certain source.
2. Decide which DOIs you are interested in. You may be a publisher with a prefix, an author with a specific DOI, or a researcher who wants all the data.
3. Decide how you want to process it. Are you ingesting it into one big database or maybe performing analysis in batches?
4. Decide what timeframe you're interested in.
    - If you want to do a one-off query, you may be interested in the `occurred` view.
    - If you want to maintain an up-to-date database, you may be interested in the `collected` view.
    - If you are interested in on-going data, you should decide how often you want to pull data from the API.
    - If you use the `occurred` view for a particular date, you should be aware that Events that occurred on that date may be collected in future.
3. Decide what you want to actually do with the data.
    - If you want to monitor for Events, a time-series database may be of use.
    - If you want to collect data for later, a JSON document store may be of use.
    - If you want to look at links between things, a graph store may be of use.

## Preparation

1. Create an appropriate data management plan, if necessary.
    - If you're retaining Events for a period of time, you should plan to re-run update queries every few months.
    - If you're going to publish research, you should aim to update the data before publication to ensure the data you're working with is as accurate as possible.
    - If you're creating derivative one-off results, you should consider if it's important to keep these up-to-date.
2. Decide on an appropriate data transparency plan.
    - If you're deriving further analysis, such as for research or for an open platform, you should consider traceability of your outputs back to the Events you received.
3. Select an appropriate query for the Query API based on what data you want to get.

## Collect data

1. Create the appropriate integration for your use case. This may be:
    - a one-off import
    - a daily job to ingest the new data
1. Remember to stick to your data management plan and poll for updated data.
2. If you are performing analysis, consult the Status Service for any background issues or factors that may have affected the collection of data.

## Review terms of use

You should be familiar with the [terms of use](https://www.crossref.org/services/event-data/terms/).

## Feedback

We would love to know how you are using Crossref Event Data and what you're doing with it. We are also happy to discuss your plans and give advice where useful.
