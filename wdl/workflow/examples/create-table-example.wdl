version development

import "../utility-wrappers/jgcp/bigquery.wdl" as bigQuery
import ".create-table-example.yaml.wdl" as yaml

workflow CreateTableExample {
    input {
        GcpConfig gcpConfig
        DatasetReference exampleDataset
    }

    call yaml.GetYaml {
        input: 
            project = exampleDataset.projectId,
            dataset = exampleDataset.datasetId
    }
    Map[String, Table] tables = read_json(GetYaml.yaml)

    Table exampleTable = tables["name_table"]
    call bigQuery.CreateTable as CreateExampleTable {
        input:
            credentials = gcpConfig.credentials, projectId = gcpConfig.apiProjectId, dockerImage = gcpConfig.jgcpVersion,
            table = exampleTable,
            drop = true
    }

    output {
        Table createdExampleTable = CreateExampleTable.createdTable
    }
}