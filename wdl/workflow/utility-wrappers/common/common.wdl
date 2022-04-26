version development

# Struct containing common config passed around to all workflows
struct GcpConfig {
    # Optional credentials JSON file for API calls
    File? credentials
    # Optional default project ID associated with API calls
    String apiProjectId
    String jgcpVersion
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

task StringReplace {
    input {
        String toReplace
        File? replacements
        GcpConfig config
    }

    command <<<
        python3 <<CODE
        import json
        strToReplace = "~{toReplace}"
        with open("~{replacements}") as replacements_file:
            replacements = json.load(replacements_file)
            for key, value in replacements.items():
                strToReplace = strToReplace.replace("{"+key+"}", value)
        print(strToReplace)
        CODE
    >>>

    runtime {
        docker: config.jgcpVersion
    }

    output {
        String replacedString = read_string(stdout())
    }
}

task Slacker {
    input {
        SlackConfig? slackConfig
        GcpConfig config
    }

    parameter_meta {
        slackConfig: {description: "The config for slack including the token uri, channel and message, specififed in the input.json file"}
        config: {description: "Specify the GCP config to use to acquire the slack API token", category: "required"}
    }

    command <<<
        slacker ~{"--project_id=" + config.apiProjectId} ~{"--credentials=" + config.credentials} ~{"--slack_uri=" + select_first([slackConfig]).tokenUri} ~{"--channel=" + select_first([slackConfig]).channel} ~{"--message=" + "'" + select_first([slackConfig]).message + "'"}
    >>>
    
    runtime {
        docker: config.jgcpVersion
    }
}

task Mailer {
    input {
        MailerConfig? mailerConfig
        GcpConfig config
        String replacedMessage
    }

    command <<<
        mailer ~{"--project_id=" + config.apiProjectId} ~{"--credentials=" + config.credentials} ~{"--mailgun_api_url=" + select_first([mailerConfig]).apiUrl} ~{"--mailgun_api_uri=" + select_first([mailerConfig]).apiUri} ~{"--mailto=" + "\"" + select_first([mailerConfig]).mailTo + "\"" }  ~{"--message=" + "\"" + replacedMessage + "\""} ~{"--subject=" + "\"" + select_first([mailerConfig]).subject + "\""} ~{"--sender=" + select_first([mailerConfig]).sender}
    >>>

    runtime {
        docker: config.jgcpVersion
    }
}