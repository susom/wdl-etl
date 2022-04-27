version development

import "workflow/utility-wrappers/jgcp/bigquery.wdl" as bigquery

workflow CreateDatasetExample {
    input {
        File? credentials
        String projectId
        String dockerImage
        Boolean? drop
        Dataset dataset
    }

    call bigquery.CreateDataset as ExampleDataset {
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