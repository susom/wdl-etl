version development

import "examples/create-dataset-example.wdl" as createDatasetExample
import "examples/create-table-example.wdl" as createTableExample
import "examples/query-table-example.wdl" as queryTableExample

workflow Main {
    input {
        GcpConfig gcpConfig
        TableReference sourceTable
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
                access: mainAccessEntries
            }
    }

    call createTableExample.CreateTableExample as ExampleTable {
        input: 
            gcpConfig = gcpConfig,
            exampleDataset = ExampleDataset.exampleDataset.datasetReference
    }

    call queryTableExample.QueryTableExample as PopulateTable {
        input: 
            gcpConfig = gcpConfig,
            exampleTable = ExampleTable.createdExampleTable,
            exampleDataset = ExampleDataset.exampleDataset.datasetReference,
            sourceTable = sourceTable
    }

    output {
        DatasetReference datasetOut = ExampleDataset.exampleDataset.datasetReference
    }
}