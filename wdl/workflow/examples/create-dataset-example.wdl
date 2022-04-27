version development

import "../utility-wrappers/jgcp/bigquery.wdl" as bigQuery

workflow CreateDatasetExample {
    input {
        File? credentials
        String projectId
        String dockerImage
        Boolean? drop
        Dataset dataset
    }

    call bigQuery.CreateDataset as ExampleDataset {
        input:
            credentials = credentials,
            projectId = projectId,
            dockerImage = dockerImage,
            drop = drop,
            dataset = dataset
    }

    output {
        Dataset exampleDataset = ExampleDataset.createdDataset
    }
}