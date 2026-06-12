package require ::quartus::project
package require ::quartus::flow

set base_dir [pwd]

project_open -revision ap_core src/fpga/build/sms_pocket.qpf
set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL
execute_flow -compile
project_close

# project_open changes cwd to the project directory; restore it
cd $base_dir

# Run custom STA report for detailed timing path analysis.
# (sta_custom_report.tcl verifies its own report outputs.)
file mkdir build_output/reports
post_message "Running custom STA report..."
if {[catch {qexec "quartus_sta -t scripts/sta_custom_report.tcl"} result]} {
    post_message -type warning "Custom STA report failed: $result"
} else {
    post_message "Custom STA completed successfully."
}
