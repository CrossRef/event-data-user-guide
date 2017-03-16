# Connecting CED to a Graph Database

*Content to follow.*

<!--

Event Data is a natural fit for a Graph Database. 


CED is a natural fit for a Graph Database. A Graph Database is a store for objects and relationships between them, which is exactly the kind of data that CED provides.

Whilst CED is a natural fit for a graph database, there are several ways that it can fit. There's no one true model for modelling CED as a graph. The way you represent the data depends entirely on the kind of questions you want to ask of it. Some representations make for easy querying, but don't capture all of the nuances of the data. 

Here are six models you might consider:

## 1 - Simple subjects and objects as nodes.

![Model 1: Simple subjects, objects and relations](/images/graph-1.png)

This is the most straightforward. It records the like as "this webapge mentioned this DOI". It's a good starting point for interrogating the data.

Allows you to answer:
 - allows for questions like "which webpages mention this DOI?"
 - how many DOIs are mentioned in this webpage

Pros:
 - simple and compact

Cons:
 - doesn't represent whether or not not the article was linked via its landing page or directly via the DOI
 - doesn't record the metadata of the relation, e.g. when it happened
 - doesn't record which Event caused the relation, so the evidence chain is lost

## 2 - URLs and PIDs as nodes, relations between URLs

![Model : ](/images/graph-2.png)

This model makes a separate node for the URL of an article and its PID, if they are different. 

## 3 - URLs and PIDs as nodes, relations between PIDs

![Model : ](/images/graph-3.png)



## 4 - The Event as a Node

![Model : ](/images/graph-4.png)



## 5 - The Event as a Node, PID to URL relationships

![Model : ](/images/graph-5.png)



## 6 - 

![Model : ](/images/graph-6.png)



The simplest way to 



Each Event records 

Content to follow.


# Gephi

https://gephi.org/

-->