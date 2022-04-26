version development

#
# Datasets
# https://cloud.google.com/bigquery/docs/reference/rest/v2/datasets
#
struct DatasetReference {
  String projectId
  String datasetId
}

struct RoutineReference {
  String projectId
  String datasetId
  String routineId
}

# https://cloud.google.com/bigquery/docs/reference/rest/v2/TableReference
struct TableReference {
  String projectId
  String datasetId
  String tableId
}

struct AccessEntry {
  String role
  String? userByEmail
  String? groupByEmail
  String? domain
  String? specialGroup
  String? iamMember
  TableReference? view
  RoutineReference? routine
}

struct EncryptionConfiguration {
  String kmsKeyName
}

# https://cloud.google.com/bigquery/docs/reference/rest/v2/datasets
struct Dataset {
  String? kind
  String? etag
  String? id
  String? selfLink
  DatasetReference datasetReference
  String? friendlyName
  String? description
  String? defaultTableExpirationMs
  String? defaultPartitionExpirationMs
  Map[String, String]? labels
  Array[AccessEntry]? access
  String? creationTime
  String? lastModifiedTime
  String? location
  EncryptionConfiguration? defaultEncryptionConfiguration
  Boolean? satisfiesPzs
  String? type
}

struct PolicyTags {
  Array[String] names
}

struct TableFieldSchema2 {
  String name
  String type
  String? mode
  #Array[TableFieldSchema3] fields # create if necessary... 
  String? description
  PolicyTags? policyTags
  Int? maxLength
  String? precision
  String? scale
}

struct TableFieldSchema {
  String name
  String type
  String? mode
  Array[TableFieldSchema2]? fields # WDL does not allow circular, only going one-level deep
  String? description
  PolicyTags? policyTags
  Int? maxLength
  String? precision
  String? scale
}

struct TableSchema {
  Array[TableFieldSchema] fields
}

# https://cloud.google.com/bigquery/docs/reference/rest/v2/tables
struct Table {
  String? kind
  String? etag
  String? id
  String? selfLink
  String? friendlyName
  TableReference tableReference
  String? description
  Map[String, String]? labels
  TableSchema? schema
  String? numBytes
  String? numLongTermBytes
  String? numRows
  Int? numActiveLogicalBytes
  Int? numLongTermLogicalBytes
  Int? numTotalLogicalBytes
  String? creationTime
  String? expirationTime
  String? lastModifiedTime
  String? type
  String? location
}

struct ScriptOptions {
  String statementTimeoutMs
  String statementByteBudget
  String keyResultStatement
}

# Replace all places where these two variables are in the code
struct Config {
  File? credentials
  String gcpProject
  String jgcp
}

struct SlackConfig {
  String tokenUri
  String channel
  String message
}

struct MailerConfig {
  String apiUrl
  String apiUri
  String mailTo
  String message
  String subject
  String sender
}