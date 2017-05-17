# Reports

The Event Data system monitors the activity of Agents and external data sources. It also monitors Events as they are created. These are collected into daily Reports.

When using Events you may want to know a bit more about how the system was behaving when they were collected. For example, if you find a dip in Wikipedia activity you may want to check to see if we were receiving data from Wikipedia at the normal rate over that period, or whether their APIs returned elevated rates of error codes. If you notice that references from a particular website suddenly dry up, you may want to check whether not not they changed their robots policy and we were suddenly unable to collect data from this source.

The Status Service monitors heartbeats and other actions from all components of the system and generates daily reports. It also analyses the output of Event Data and generates information. We use these reports internally to monitor the performance of the system and quality of data, but they are open. Entries with an asterisk may be of interest to consumers of Event Data. 

We will develop the Reports feature during the Beta period.

See the [Reports Service](../service/reports-service) for details on how to access Reports.