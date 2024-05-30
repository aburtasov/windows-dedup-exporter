## windows_dedup_exporter
This repository contains a Prometheus Exporter for gathering deduplication metrics on Windows systems. The exporter collects various metrics related to the deduplication process and exposes them for Prometheus to scrape.

### Features

* Collects deduplication job metrics from Windows servers
* Provides information on deduplication queue length, progress, saved space, optimized files, and in-policy files
* Counts the number of active fsdmhost.exe processes
* Exposes metrics via a Prometheus-compatible endpoint

### Metrics Collected

   * `dedup_queue_count`: Total current deduplication tasks
   * `dedup_process_count`: Total current deduplication processes (fsdmhost.exe)
   * `dedup_progress_count`: Current progress of deduplication jobs by volume
   * `dedup_saved_space_count`: Amount of space saved by deduplication by volume
   * `dedup_optimized_files_count`: Number of optimized files by volume
   * `dedup_inpolicy_files_count`: Number of in-policy files by volume

### Usage
1. Clone the repository
2. Run the script:
```
.\dedup.ps1
```
If you now open http://localhost:9700 in your browser, you will see the metrics displayed.
```
# HELP dedup_progress_count Current progress of dedup jobs
# TYPE dedup_progress_count gauge
dedup_progress_count{volume="E:"} 0
# HELP dedup_saved_space_count Count of saved space
# TYPE dedup_saved_space_count gauge
dedup_saved_space_count{volume="E:"} 0
# HELP dedup_optimized_files_count Count of optimized files
# TYPE dedup_optimized_files_count gauge
dedup_optimized_files_count{volume="E:"} 0
# HELP dedup_inpolicy_files_count Count of in-policy files
# TYPE dedup_inpolicy_files_count gauge
dedup_inpolicy_files_count{volume="E:"} 0
# HELP dedup_progress_count Current progress of dedup jobs
# TYPE dedup_progress_count gauge
dedup_progress_count{volume="F:"} 0
# HELP dedup_saved_space_count Count of saved space
# TYPE dedup_saved_space_count gauge
dedup_saved_space_count{volume="F:"} 9.470072E+08
# HELP dedup_optimized_files_count Count of optimized files
# TYPE dedup_optimized_files_count gauge
dedup_optimized_files_count{volume="F:"} 20
# HELP dedup_inpolicy_files_count Count of in-policy files
# TYPE dedup_inpolicy_files_count gauge
dedup_inpolicy_files_count{volume="F:"} 20
# HELP dedup_queue_count Total current dedup tasks
# TYPE dedup_queue_count gauge
dedup_queue_count 0
# HELP dedup_process_count Total current dedup processes
# TYPE dedup_process_count gauge
dedup_process_count{process="fsdmhost"} 0
```
You can use various tools to compile an exe from a ps1 file or simply run the script.