# Evidence Logs Service

Every action that is taken in the process of producing an Event, including actions that did not eventually lead to an Event, are saved in the Evidence Logs. These are archived daily. 

Evidence Logs are available in two formats: newline-separated JSON objects and CSV. They both contain the same data, and are presented in both formats for ease of use. 

The following URL patterns should be used:

  - CSV: `https://evidence.eventdata.crossref.org/log/«YYYY-MM-DD».csv`
  - Newline-separated JSON: `https://evidence.eventdata.crossref.org/log/«YYYY-MM-DD».txt`

Note that each file can be several gigabytes of data.

Full documentation is provided in the [Evidence Logs](../data/evidence-logs) page.