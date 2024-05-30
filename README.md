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

### Running as a service
Running a powershell script as a windows service is possible by using NSSM.

Use the snippet below to install it as a service:
```
$serviceName = 'DedupExporter'
$nssm = "c:\path\to\nssm.exe"
$powershell = (Get-Command powershell).Source
$scriptPath = 'c:\program files\your_exporter\dedup.ps1'
$arguments = '-ExecutionPolicy Bypass -NoProfile -File """{0}"""' -f $scriptPath

& $nssm install $serviceName $powershell $arguments
Start-Service $serviceName

# Substitute the port below with the one you picked for your exporter
New-NetFirewallRule -DisplayName "My Exporter" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 9700
```
### Compile an exe-file from ps1-file
Or you can use various tools(like `ps2exe`) to compile an exe from ps1 file:
1. Open PowerShell with Administration Right
2. Execute:  `Install-Module -Name ps2exe -Scope CurrentUser`
3. Move to directory with the script: `cd path\to\script\dedup.ps1`
4. Execute command: `ps2exe.ps1 -inputFile dedup.ps1 -outputFile dedup.exe`
