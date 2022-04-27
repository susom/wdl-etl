version development

import "workflow/examples/create-dataset-example.wdl" as createDatasetExample
import "workflow/examples/create-table-example.wdl" as createTableExample
import "workflow/examples/query-table-example.wdl" as queryTableExample

workflow Main {
    input {
        GcpConfig gcpConfig
        Table sourceTable
        String targetProjectId
        String? prefix
        String version
        String release = "~{prefix}~{version}"
        String releaseGroup
        Array[AccessEntry]? mainAccessEntries
    }

    call createDatasetExample.CreateDatasetExample as ExampleDataset {
        input:
            credentials = gcpConfig.credentials, projectId = gcpConfig.apiProjectId, dockerImage = gcpConfig.jgcpVersion,
            drop = true,
            dataset = object {
                description: "WDL example dataset, built from the Big Query public datasets",
                datasetReference: { "projectId": "~{targetProjectId}", "datasetId": "~{release}" },
                labels: { "release_name": "~{release}", "release_group": "~{releaseGroup}", "archive" : "all" },
                access: baselineAccessEntries
            }
    }

    call createTableExample.CreateTableExample as ExampleTable {
        input: 
            gcpConfig = gcpConfig,
            exampleDataset = ExampleDataset.createdDataset.datasetReference
    }

    call queryTableExample.QueryTableExample as PopulateTable {
        input: 
            gcpConfig = gcpConfig,
            exampleTable = ExampleTable.table,
            exampleDataset = ExampleDataset.createdDataset.datasetReference,
            sourceTable = sourceTable
    }

    output {
        DatasetReference datasetOut = ExampleDataset.createdDataset
    }
}