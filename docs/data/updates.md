# Updates to Events

Events are never *removed* from the system, but they are sometimes updated. Because immutability and stability are important design principles, we will avoid doing this where possible. We will make changes to existing Events under the following circumstances:

 - Where we are contractually obliged to. For example, Twitter requires us to monitor deleted tweets and update our data to remove the deleted material accordingly.
 - Where Events have been produced as the result of a bug. For example, if Events are issued for DOIs that don't exist and the Event is therefore invalid.
 - Where we have added new features or enhancements, to bring old Events into line with new ones.

For example, if an Agent has a bug that generates Events with invalid DOIs, and we are able to clean them up and mark the Events as edited, we will update those Events. If it generates non-existent DOIs, we may mark those Events as deleted. If a user deletes a tweet that's referenced from an Event, we will erase the tweet ID and author ID from the Event, leaving the rest untouched, and mark it as deleted.

If an Event is updated, three fields will be set:

 - `updated` - will have a value of `deleted` or `edited`
 - `updated_reason` - optional, may point to an announcement page explaining the edit
 - `updated_date` - ISO8601 date string for when the event was updated.
 
Here are real examples of changes we have made to Events:

 - `deleted` to remove data from Twitter Events for tweets that have been deleted.
 - `deleted` to remove Events we produced in error, that were not matched to valid DOIs.
 - `deleted` to remove Events that now know we should not have created, because the subject of the Event was a piece of Registered Content.
 - `edited` to back-port Canonical URLs to old Events. This means that new Events can be deduplicated with respect to old Events by their `subj_ids`. Not doing this would have left old Events with inconsistent URLs.

The web is ephemeral, and some webpages may have been changed or disappeared since we observed them. An Event is the record of an observation at some point in time. This means that under normal circumstances, **a changing webpage will not result in an Event being updated**.

By default, the Query API **will not** serve Events that have been already been `deleted`, but **will** serve Events that have been `edited`. See the [Query API documentation](/service/query-api) for more details.
