# Appendix: NISO Altmetrics Code of Conduct <a name="appendix-niso-coc"></a>

### 1: List all available data and metrics (providers and aggregators) and altmetric data providers from which data are collected (aggregators).

Event Data is a system for collecting Events and also a platform to allow other providers to publish their own Events. The data are gathered through a combination of actively collecting data from non-scholarly sources and allowing scholarly sources to send data. It focuses on Events ("these things happened") not aggregations ("this many things happened") or metrics ("you got this score"). You can find the list of Sources in [Sources](service#data-sources).

### 2: Provide a clear definition of each metric.

Crossref Event Data reports raw Events, not metrics. The [Sources in Depth](sources-in-depth) provides a detailed discussion of each Source and exactly what Events from the Source means.

### 3: Describe the method(s) by which data are generated or collected and how data are maintained over time.

The Data Contributors section of the User Guide provides a detailed discussion of each Source and exactly what Events from the Source means. 

### 4: Describe all known limitations of the data.

The Data Contributors section of the User Guide provides a detailed discussion of each Source and the limits of the data it produces.

### 5: Provide a documented audit trail of how and when data generation and collection methods change over time and list all known effects of these changes. Documentation should note whether changes were applied historically or only from change date forward.

The [Evidence In Depth](evidence-in-depth) section describes the complete audit trail of data, from input to Events, via Evidence Records. It also describes how the Artifact Service shows the complete environment under which an Event was generated. The [Evidence Logs](data/evidence-logs) provide a very high level of detail about every activity and process that took place, including negative results. 

### 6: Describe how data are aggregated

Data is not aggregated. Events are provided as links are found.

### 7: Detail how often data are updated.

Each Event has a timestamp which describes when the Event was collected. The [Occurred at vs Collected At](concepts#concept-timescales) section explains that the 'collected' view in the Query API is updated daily, and once a day's data is provided, it never changes. It also details the 'occurred at' view and how to tell when Event Data was updated. The [Evidence Service](evidence-in-depth) automatic documentation of when Artifacts were updated.

### 8: Describe how data can be accessed

The [Service](#the-service) section details the Query API, which is used for accessing Event Data and the Evidence API, which is used for accessing audit data.

### 9: Confirm that data provided to different data aggregators and users at the same time are identical and, if not, how and why they differ.

There is only one version of the data. All consumers receive the same data regardless of audience.

### 10: Confirm that all retrieval methods lead to the same data and, if not, how and why they differ.

There is only one version of the data. All consumers receive the same data regardless of retrieval method.

### 11: Describe the data-quality monitoring process.

The Evidence Service allows anyone to perform audits on Event Data. The Status Service monitors the performance and activity of all parts of the system. We will run an automatic service to analyze the outputs to ensure they correlate to the inputs. In addition to this, the Evidence Logs provide all the information required for an external party to monitor data quality.

### 12: Provide a process by which data can be independently verified.

All data is available on the Query API and Evidence API.

### 13: Provide a process for reporting and correcting data or metrics that are suspected to be inaccurate

Crossref support will be able to handle requests. We can attempt to reprocess raw data to re-generate Events. We can back-fill missing Events with appropriate date-stamps. As we are not aggregating Events into metrics or scores, we will not provide scores which might later need adjustment.

If there are any interruptions or other notices, they will be recorded via the Status Service.
