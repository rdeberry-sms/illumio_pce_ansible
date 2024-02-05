# /etc/hosts

${join("\n", [for host, ip in pce_core_nodes : "${ip}    ${host}"])}
${join("\n", [for host, ip in pce_data_nodes : "${ip}    ${host}"])}
${join("\n", [for host, ip in pce_lb_nodes : "${ip}    ${host}"])}
${load_balancer != "" ? "${load_balancer}    ${load_balancer_host_name}" : ""}
