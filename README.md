# WDL ETL Workflow example
The goal of this repository is to establish common patterns and teach new users/developers how to create a WDL workflow.
Additionally, this repo can be used as a starting point for expansion into new WDL applications.

# Structure
## Python Scripts and Docker
Inside of "utilities/src/main":
* The Dockerfile for creating the image where the python lives
* The python scripts that interact with the GCP BigQuery API
* Python for common utilities that have corresponding wrappers in WDL

Inside of "wdl":
* Example workflows for creating a dataset, populating a table, and querying a table
* WDL Wrappers for the python utilities mentioned above
* WDL Wrapper for the Big Query API python utility

