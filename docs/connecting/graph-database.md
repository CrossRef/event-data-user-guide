# Connecting CED to a Graph Database

Content to follow.

<!--

TODO excluded from index for now.

This page builds on the concepts introduced in ['Event Data as a Graph Structure'](/data/graph).


## Example code

The example code, which you can find TODO is written in Python and interacts with Neo4J. You will need to install Neo4J and make sure Python is available on your system. The script will connect to the Event Data Query API and ingest all the Events that occurred in a given date range, including start and end date. You should start with one day for your first experiments.

There are two modes, 'simple' and 'full'. Simple takes Model 1. 'Full' represents every possible relationship in the graph database. In both cases it includes a core set of properties on each node.

Set the `NEO4J_USERNAME`, `NEO4J_PASSWORD` and `NEO4J_URL` environment variables.

To ingest a date range worth of data, e.g. between the first of March and and the first of April, run:

TODO

    NEO4J_USERNAME=neo4j NEO4J_PASSWORD=neo4j NEO4J_URL=localhost:1234 python ingest.py 2017-03-01 2017-04-01

When the script has started running you will begin to see data in the database.

### Example Neo4J Queries

Here are some queries to get you going. They all include LIMIT clauses, because the queries might otherwise return an overwhelming amount of data.

For `simple` mode:

1. Find some tweets.
2. Find some DOIs.
3. Find some DOIs that are mentioned by one or more tweets.
4. Find some tweets that mention two DOIs.
5. Find some DOIs that are mentioned both by a tweet and by a reddit comment.

For `full` mode:

1. Find the landing page for this DOI.
2. Find the Agent that asserted that this landing page is for this DOI.
3. Find all Events that are connected to this DOI, but via its landing page URL.
4. Find all Tweets that are connected to this DOI, but via its DOI.

-->