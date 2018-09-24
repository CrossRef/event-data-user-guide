# Quality Assurance and Feedback

Event Data has built-in feedback and monitoring mechanisms. These observe the flow of data through the system, ensure that scheduled tasks have been performed, and help to maintain and improve the quality of data in the system. 

The results of all of the feedback mechanisms are included in the Evidence Log, which is freely available for anyone to view and analyze. Like all of the software that makes Event Data work, the quality assurance code is open source.

There are three categories of feedback:

 - **Daily checks** automatically monitor and report on the data.
 - **Patches** are actions we manually take to improve the data.
 - **Support queries** can feed back into our datasets.

All the results are published in the Evidence Log. See the [Evidence Log page](/guide/data/evidence-logs/) for the description of all of the Evidence Log Message types.

We are currently handling support queries manually. If you want to raise an issue, suggest a new data source or change to any of our Artifacts, please contact eventdata@crossref.org

## Daily Checks

These run every day. If there is an interruption of service and a day is missed, it will be automatically filled in later. The results of daily checks are published in the Evidence Record.

### Archive / Query API Integrity Check

Internally, the Event Bus stores every Event in the Bus Archive. Events are made available via the Query API. This check compares the content of the Event Bus Archive with the Query API, to ensure that every Event exists.

Errors will be logged in the Evidence Log if an Event is present in the Archive but not in the Query API, and vice versa.

### Evidence Log Dump Check

The Evidence Log is archived every day, available as a CSV and a JSON file. The presence of this file is checked, and an error is logged if either are missing.

### Twitter Compliance

Around 5% of Tweets that we capture are subsequently deleted. When this happens, we will update the Event to remove the Twitter-specific data (`subj_id`, which contains the Tweet ID and `subj` metadata which also contains the author) and mark the Event as having been deleted. This is documented in the [updates](/guide/data/updates) section.

Checks run every day. They will check every Tweet mentioned in an Event three times:
 
 - the day after the Tweet was published
 - one month after the Tweet was published
 - one year after the Tweet was published

When an Event is updated for Twitter compliance reasons, the Evidence Record will also be updated to mirror the Event.

## Patches

From time to time we need to make manual updates to Events. Reasons for past updates include:

 - bugs in our software produced incorrect data
 - we wanted to add Canonical URLs to all of our Events
 - we wanted to change the data model for Wikipedia Events and apply this to previous data (during Beta)

The software that makes these changes is open source. This means that when an Event is updated you can see exactly what source code produced the change.

You can find the list of patches we have applied in the Investigator source code.

