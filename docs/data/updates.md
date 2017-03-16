# Updates to Events

Events are never *removed* from the system, but they are sometimes updated. For example, if an Agent has a bug that generates Events with invalid DOIs, and we are able to clean them up and mark the Events as edited, we will update those Events. If it generates non-existent DOIs, we may mark those Events as deleted. If a user deletes a Tweet that's referenced from an Event, we will erase the tweet and author ID from the Event, leaving the rest untouched, and mark it as deleted.

If an Event is updated, three fields will be set:

 - `updated` - will have a value of `deleted` or `edited`
 - `updated-reason` - optional, may point to an announcement page explaining the edit
 - `updated-date` - ISO8601 date string for when the event was updated.

By default, the Query API **will not** serve Events that have been already been `deleted`, but **will** serve Events that have been `edited`.


You can fetch using the Query API, disregard if you find a deleted event or update if you find an edited one.
