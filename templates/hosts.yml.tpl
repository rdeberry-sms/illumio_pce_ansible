all:
  hosts:
  children:
%{ if create_lb == true ~}
    lbnodes:
      hosts:
%{ for lb in pce_lb_nodes ~}
        ${lb}:
%{ endfor ~}
%{ endif ~}
    pce:
      children:
        mnc:
          hosts:
%{ for core in pce_core_nodes ~}
            ${core}:
%{ endfor ~}
%{ for data in pce_data_nodes ~}
            ${data}:
%{ endfor ~}
        corenodes:
          children:
%{ for index, core in pce_core_nodes ~}
            core${format(index)}:
              hosts:
                ${core}:
%{ endfor ~}
        datanodes:
          children:
%{ for index, data in pce_data_nodes ~}
            data${format(index)}:
              hosts:
                ${data}:
%{ endfor ~}
