# Wikipedia

| Property                  | Value          |
|---------------------------|----------------|
| Name                      | Wikipedia |
| Matches by                | DOI |
| Consumes Artifacts        |  |
| Produces relation types   | `references` |
| Freshness                 | continual |
| Data Source               | Wikipedia Recent Changes Stream, Wikipedia RESTBase |
| Coverage                  | All Wikimedia properties. DOI URL references only. |
| Relevant concepts         | [Matching by DOIs](#concept-matching-dois)|
| Operated by               | Crossref |
| Agent                     | event-data-wikipedia-agent |

### Methodology

1. The agent subscribes to the Recent Changes Stream using the wildcard "`*`". This includes all Wikimedia properties. 
2. The Recent Changes Stream server sends the Agent every change to a page. Every change event includes the page title, the old and new revision and other data.
3. For every change, the Agent fetches the HTML of the old and the new pages using the RESTBase API.
    1. For every URL in the old version, the Agent looks for those that are DOI URLs.
    2. For every URL in the new version, the Agent looks for those that are DOI URLs.
4. DOIs are split into those that were added and those that were removed.
    1. For every DOI that was removed an Event with the `action: "delete"` is produced.
    2. For every DOI that was added an Event with the `action: "add"` is produced.


### Example Event

    {
      obj_id: "https://doi.org/10.1093/EMBOJ/20.15.4132",
      occurred_at: "2016-09-25T23:58:58Z",
      subj_id: "https://es.wikipedia.org/wiki/Se%C3%B1alizaci%C3%B3n_paracrina",
      total: 1,
      id: "d24e5449-7835-44f4-b7e6-289da4900cd0",
      subj: {
        pid: "https://es.wikipedia.org/wiki/Se%C3%B1alizaci%C3%B3n_paracrina",
        title: "Señalización paracrina",
        issued: "2016-09-25T23:58:58.000Z",
        URL: "https://es.wikipedia.org/wiki/Se%C3%B1alizaci%C3%B3n_paracrina",
        type: "entry-encyclopedia"
      },
      message_action: "create",
      source_id: "wikipedia",
      timestamp: "2016-09-26T00:03:52Z",
      relation_type_id: "references"
    }

### Example Evidence Record

[http://archive.eventdata.crossref.org/evidence/d8043c407165bd3e07d11c5ca0d74955](http://archive.eventdata.crossref.org/evidence/d8043c407165bd3e07d11c5ca0d74955)

    {
      artifacts: [ ],
      agent: {
        name: "wikipedia",
        version: "0.1.5"
      },
      input: {
        stream-input: {
          bot: false, user: "J3D3",
          id: 133112611,
          timestamp: 1474847938,
          wiki: "eswiki",
          revision: {
            new: 93906371, old: 93391161
          },
          server_script_path: "/w",
          minor: false,
          server_url: "https://es.wikipedia.org",
          server_name: "es.wikipedia.org",
          length: {
            new: 51542, old: 51700
          },
          title: "Señalización paracrina",
          type: "edit",
          namespace: 0,
          comment: "Traduciendo otra pequeña parte"
        },
        old-revision-id: 93391161,
        new-revision-id: 93906371,
        old-body: "<!DOCTYPE html> <html prefix="dc: http://purl.org/dc/terms/ mw: http://mediawiki.org/rdf/" about="http://es.wikipedia.org/wiki/Special:Redirect/revision/93391161">« ... removed ... »</html>",
        new-body: "<!DOCTYPE html> <html prefix="dc: http://purl.org/dc/terms/ mw: http://mediawiki.org/rdf/" about="http://es.wikipedia.org/wiki/Special:Redirect/revision/93906371">« ... removed ... »</html>"
      },
      processing: {
        canonical: "https://es.wikipedia.org/wiki/Se%C3%B1alizaci%C3%B3n_paracrina",
        dois-added: [
        « ... removed ... »
        {
          action: "add",
          doi: "10.1016/S1097-2765(01)00421-X",
          event-id: "48de8c32-a901-4cc5-b911-544c959332f5"
        }
      ],
      dois-removed: [ ]
      },
        deposits: [
        « ... removed ... »
        {
          obj_id: "https://doi.org/10.1016/s1097-2765(01)00421-x",
          source_token: "36c35e23-8757-4a9d-aacf-345e9b7eb50d",
          occurred_at: "2016-09-25T23:58:58.000Z",
          subj_id: "https://es.wikipedia.org/wiki/Se%C3%B1alizaci%C3%B3n_paracrina",
          action: "add",
          subj: {
            title: "Señalización paracrina",
            issued: "2016-09-25T23:58:58.000Z",
            pid: "https://es.wikipedia.org/wiki/Se%C3%B1alizaci%C3%B3n_paracrina",
            URL: "https://es.wikipedia.org/wiki/Se%C3%B1alizaci%C3%B3n_paracrina",
            type: "entry-encyclopedia"
          },
          uuid: "48de8c32-a901-4cc5-b911-544c959332f5",
          source_id: "wikipedia",
          relation_type_id: "references"
        }
      ]
    }

### Failure modes

 - The stream has no catch-up. If the agent is disconnected (which can happen from time to time), then edit events may be missed.
 - The RESTBase API occasionally does not contain the edit mentioned in the change. Although the Agent will retry several times, if it repeatedly receives an error for retriving either the old or the new versions, no event will be returned. This will be recorded in the Evidence Record as an empty input.
