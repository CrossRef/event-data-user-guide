# Keep up-to-date with Event Data

Once an Event has been created, we won't remove it from our system. However, there are some circumstances where we may edit it or mark it as deleted. We try to avoid editing Events once they are created but in some cases, notably Twitter, we routinely do this because of our obligations.

If you retrieve Events from Event Data, or if you perform calculations based on data from Event Data, you should check back to make sure the original data hasn't changed. Examples of when you might like to check:

 - If you are publishing a research paper, make a final check before publication.
 - If you producing on-going data derived from Event Data, you may want to re-check every month or so.

Data can change for a number of reasons:

 - If a tweet was deleted by its author, we are obliged to remove it from Event Data.
 - If we ran a report that indicated we produced obviously incorrect data as a result of a software bug, we may mark Events as having been deleted or edited.

When an Event is updated, we will add the an `updated` field, an `updated-date` field and an `updated-reason`. The `updated` field will have a value of:

 - `deleted`
   - When a tweet is deleted. We will remove the tweet content (tweet ID and author) but retain all other parts of the Event.
   - When we identified obviously faulty data.
 - `edited`
   - When we identified obviously faulty data but it can be corrected.

For further discussion see [updates](/data/updates). For more details of how to do this check the [Query API](/service/query-api/) documentation.
