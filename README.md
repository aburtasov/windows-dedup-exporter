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
You can use various tools to compile an exe from a ps1 file or simply run the script.