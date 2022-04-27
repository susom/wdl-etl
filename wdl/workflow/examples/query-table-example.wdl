version development

import "workflow/utility-wrappers/jgcp/bigquery.wdl" as bigquery
import "workflow/utility-wrappers/common/common.wdl" as utilities
import ".query-table-examples.yaml.wdl" as yaml

workflow QueryTableExample {
    input {
        GcpConfig gcpConfig
        Table exampleTable
        Table sourceTable
        DatasetReference exampleDataset
    }

    call yaml.GetYaml
    Map[String, String] queries = read_json(GetYaml.yaml)

    call bq.Query as PopulateNameTable {
        input:
            credentials = gcpConfig.credentials, projectId = gcpConfig.apiProjectId, dockerImage = gcpConfig.jgcpVersion,
            query = queries["populate_data"],
            dependencies = {"sourceTable": sourceTable},
            destination = exampleTable,
            drop = true
    }

    output {
        Table populatedTable = PopulateNameTable.table
    }
}