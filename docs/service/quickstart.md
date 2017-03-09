# Quick Start

Please ensure you have read [The Service](service) and [Concepts](concepts) before using this data for anything serious! Additionally, you should consult the documentation for each Source you intend to use.

Most of the time you will want to grab the dataset in bulk, or for a paricular source, or a particular DOI prefix. You can then filter it, load it into your own data store, etc. Check the [Crossref blog](https://www.crossref.org/categories/event-data/) for ideas. We collect a few tens of thousands of Events per day, so that can weigh in at over 10MB of data per day. Bear this in mind if you point a browser at the URLs.

This quick start is going to show you how to fetch data and then do some rudimentary querying with it using the popular [JQ tool](https://stedolan.github.io/jq/).

Data is available on a per-day basis. To fetch everything that was collected on the 21st of February 2017 (14,815 Events):

      curl https://query.eventdata.crossref.org/collected/2017-02-27/events.json > 2017-02-21.json

That gives us all 10,760 events that were collected on that day.

If you're only interested in Reddit (25 Events), you can filter that:

    curl https://query.eventdata.crossref.org/collected/2017-02-27/sources/reddit/events.json > 2017-02-21-reddit.json

If you're only interested in PLOS articles (981 Events), you can filter by their prefix:

    curl  https://query.eventdata.crossref.org/collected/2017-02-27/prefixes/10.1371/events.json > 2017-02-21-plos.json

Now you've got a day's worth of data to crunch. Let's continue with the whole day's worth.

We can pipe it through `jq` to format it nicely. I've cut its head off at 28 lines:

    $ jq . 2017-02-21.json | head -n 28
    {
      "meta": {
        "status": "ok",
        "message-type": "event-list",
        "total": 14815,
        "total-pages": 1,
        "page": 1,
        "previous": "https://query.eventdata.crossref.org/collected/2017-02-26/events.json",
        "next": "https://query.eventdata.crossref.org/collected/2017-02-28/events.json"
      },
      "events": [
        {
          "obj_id": "https://doi.org/10.1007/s00266-017-0820-4",
          "source_token": "45a1ef76-4f43-4cdc-9ba8-5a6ad01cc231",
          "occurred_at": "2017-02-27T19:06:32.000Z",
          "subj_id": "http://twitter.com/Ulcerasnet/statuses/836291446168817665",
          "id": "00001916-bbf6-4698-b8b8-26dbd885afa9",
          "action": "add",
          "subj": {
            "pid": "http://twitter.com/Ulcerasnet/statuses/836291446168817665",
            "title": "Tweet 836291446168817665",
            "issued": "2017-02-27T19:06:32.000Z",
            "author": {
              "url": "http://www.twitter.com/Ulcerasnet"
            },
            "original-tweet-url": "http://twitter.com/UrgoTouch_es/statuses/836203902781517829",
            "original-tweet-author": "http://www.twitter.com/UrgoTouch_es"
          },

Note the previous and next links. You can use these to navigate your query back and forward through time on the API.

I'm going to use JQ to select the `events`, then I'm going to return all of the distinct source names.

    jq '.events | map(.source_id) | unique ' 2017-02-21.json
    [
      "reddit",
      "twitter"
    ]

We were only collecting for those two sources on that day. Now let's group by the DOI and count how many Events we got for each DOI. Again, I've snipped a long output.

    $ jq '.events | group_by(.obj_id) | map ([.[0].obj_id, length]) ' 2017-02-21.json  | head -n 17
    [
      [
        "https://doi.org/10.1001/journalofethics.2017.19.2.pfor1-1702",
        1
      ],
      [
        "https://doi.org/10.1001/journalofethics.2017.19.2.stas1-1702",
        3
      ],
      [
        "https://doi.org/10.1001/virtualmentor.2010.12.9.imhl1-1009",
        11
      ],
      [
        "https://doi.org/10.1001/virtualmentor.2013.15.5.imhl1-1305",
        4
      ],
      [

That's all for now. The [Query API](query-api) page describes the Query API and connected services in depth.

