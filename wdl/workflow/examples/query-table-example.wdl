version development

import "../utility-wrappers/jgcp/bigquery.wdl" as bigQuery
import "../utility-wrappers/common/common.wdl" as utilities
import ".query-table-example.yaml.wdl" as yaml

workflow QueryTableExample {
    input {
        GcpConfig gcpConfig
        Table exampleTable
        TableReference sourceTable
        DatasetReference exampleDataset
    }

    call yaml.GetYaml
    Map[String, String] queries = read_json(GetYaml.yaml)

    call bigQuery.Query as PopulateNameTable {
        input:
            credentials = gcpConfig.credentials, projectId = gcpConfig.apiProjectId, dockerImage = gcpConfig.jgcpVersion,
            query = queries["populate_data"],
            replacements = {"sourceProjectId": sourceTable.projectId, "sourceDatasetId": sourceTable.datasetId, "sourceTableId": sourceTable.tableId},
            destination = exampleTable,
            drop = true
    }

    output {
        Table populatedTable = PopulateNameTable.table
    }
}