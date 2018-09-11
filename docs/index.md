# Crossref Event Data (Beta)

Version 1.0.0 - Beta

## A note about Beta

Crossref Event Data has now launched as a production service, but is currently still in Beta. This means:

- **If you have feedback or a specific use case to share, we'd love to hear from you**. You can email eventdata@crossref.org .
- The Beta service is freely available, but we recommend you contact us to register as a Beta tester so we can keep you in the loop.
- The Beta service isn't feature-complete and there may be functionality mentioned in this Guide that is not yet implemented.
- All data you collect from Event Data during Beta is licensed for public sharing and reuse, according to our [Terms of Use](https://www.crossref.org/services/event-data/terms/).
- Event Data is now in production mode, this means we do not anticipate making any breaking changes to the code and you are encouraged to build customer facing tools with Event Data.
- As always, it is possible you may find bugs. If you do, please contact us.

## This guide is for everyone

Welcome to the Crossref Event Data User Guide. It's written for **everyone**, and covers everything you need to know (and maybe a little more) from the top-level concepts down to the nuts and bolts. When it gets too technical, stop reading! However, if you plan to integrate Event Data into your service, database or research, you should read the guide in its entirety.

This Guide is a living document, and if you have questions or suggestions you can email eventdata@crossref.org or create issues and pull requests on the Github repository, which is linked at the top of every page.

## Quick Start

If you're keen to get your hands on the data, you can jump straight to the [Quick Start](https://www.eventdata.crossref.org/guide/service/quickstart/) page. Please bear in mind that the service is in Beta.

All data collected from Event Data is licensed for public sharing and reuse, according to our [Terms of Use](https://www.crossref.org/services/event-data/terms/). Every Event will include a `license` link so you know which licence applies to the data, as well as a `terms` link which points to our Terms of Use page where all the information and links you need regarding re-use will be available. Please ensure you read the [Terms of Use](https://www.crossref.org/services/event-data/terms/) before using Event Data.

If after the Quick Start you decide to use Event Data, you are strongly encouraged to read the entire Guide. Event Data is an open, flexible service that gathers data from a range of sources. It's important that you understand where the data comes from, how it's processed, and what you should bear in in mind when using it.

Click the 'Next' button at the bottom of this page to get started...

# Revision history

| Date              | Version | Author                      |                                                   |
|-------------------|---------| ----------------------------|---------------------------------------------------|
| 18-April-2016     | 0.1     | Joe Wass jwass@crossref.org | Initial MVP release                               |
| 19-April-2016     | 0.2     | Joe Wass jwass@crossref.org | Add 'Contributing to Event Data'                  |
| 16-August-2016    | 0.3     | Joe Wass jwass@crossref.org | Remove Relations & Deposits, update new Query API |
| 08-September-2016 | 0.4     | Joe Wass jwass@crossref.org | Complete rewrite using new concepts and components|
| 27-September-2016 | 0.5     | Joe Wass jwass@crossref.org | Updated Evidence Record information |
| 09-November-2016  | 0.5.1   | Joe Wass jwass@crossref.org | Adjusted query API syntax |
| 22-Feb-2017       | 0.6.1   | Joe Wass jwass@crossref.org | Pre-beta adjustments. Reflects major refactor of services. |
| 09-Mar-2017       | 0.7.0   | Joe Wass jwass@crossref.org | Complete review of all documentation. Most of it overhauled. |
| 06-May-2017       | 1.0.0   | Joe Wass jwass@crossref.org | Beta! |
| 06-May-2017       | 1.0.1   | Joe Wass jwass@crossref.org | Add Canonical URLs, Evidence Logs |
