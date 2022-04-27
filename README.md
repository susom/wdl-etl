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

# Steps to execute example workflow
* In the root folder, open a terminal window (VSCode or IDE of choice)
    * Run the "make" command
* Create a copy of input-example.json, name it input.json and place it in the "workflow" folder
* Fill in all of the fields specific to you
    * credentials file
    * API Project ID (the project ID that you will be doing work in)
    * target project ID (where the dataset, tables, etc. will be created)
    * Prefix (dataset prefix)
    * Version (suffix of the dataset)
    * Release Group (personal preference, can be anything)
    * Main Access Entries (emails of users/Service Accounts that will require access to the created datasets, tables, etc.)
* In your terminal window, navigate into the "wdl" folder
* Navigate down one more folder into "workflow"
* In the terminal/command line, run the following command `miniwdl run main.wdl -i input.json`
