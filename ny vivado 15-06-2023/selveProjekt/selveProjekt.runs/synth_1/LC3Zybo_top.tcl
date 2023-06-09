# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7z010clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.cache/wt} [current_project]
set_property parent.project_path {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo {c:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/alle filer fra learn/BtnToggle.vhd}
  {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/Skrivebord/CounterenTilASM.vhd}
  {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/alle filer fra learn/debounce.vhd}
  {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/alle filer fra learn/lc3_wrapper_multiplexers.vhd}
  {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/new/ram.vhd}
  {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/ch04/list_ch04_11_mod_m.vhd}
  {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/ch07/list_ch07_01_uart_rx.vhd}
  {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/ch04/list_ch04_20_fifo.vhd}
  {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/ch07/list_ch07_03_uart_tx.vhd}
  {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/ch07/list_ch07_04_uart.vhd}
  {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/alle filer fra learn/lc3_computer.vhd}
  {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/alle filer fra learn/lc3_debug.vhd}
  {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/alle filer fra learn/student_code.vhd}
  {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/alle filer fra learn/zybovios_wrapper.vhd}
  {C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/alle filer fra learn/top.vhd}
}
read_edif {{C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/alle filer fra learn/ZyboVIO_SE.edif}}
read_edif {{C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/sources_1/imports/alle filer fra learn/lc3.edif}}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/constrs_1/imports/alle filer fra learn/ZyboVIO.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/abdul/OneDrive/Skrivebord/ny vivado 15-06-2023/selveProjekt/selveProjekt.srcs/constrs_1/imports/alle filer fra learn/ZyboVIO.xdc}}]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top LC3Zybo_top -part xc7z010clg400-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef LC3Zybo_top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file LC3Zybo_top_utilization_synth.rpt -pb LC3Zybo_top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
