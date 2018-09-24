# Evidence Logs Service

Every action that is taken in the process of producing an Event, including actions that did not eventually lead to an Event, are saved in the Evidence Logs. These are archived daily. 

Evidence Logs are available in two formats: newline-separated JSON objects and CSV. They both contain the same data, and are presented in both formats for ease of use. 

For dates before 10 September 2018, Evidence Logs are available on a per-day basis. 

  - CSV: `https://evidence.eventdata.crossref.org/log/«YYYY-MM-DD».csv`
  - Newline-separated JSON: `https://evidence.eventdata.crossref.org/log/«YYYY-MM-DD».txt`

e.g.

	https://evidence.eventdata.crossref.org/log/2018-09-01.txt

After that date, the size of the logs have dictated that each day is split into chunks of one hour. The hour from 00 to 23 should be used:

  - CSV: `https://evidence.eventdata.crossref.org/log/«YYYY-MM-DD»T«HH».csv`
  - Newline-separated JSON: `https://evidence.eventdata.crossref.org/log/«YYYY-MM-DD»T«HH».txt`

e.g. 

	https://evidence.eventdata.crossref.org/log/2018-09-20T18.txt

Note that each file can be several gigabytes of data.

Full documentation is provided in the [Evidence Logs](../data/evidence-logs) page.