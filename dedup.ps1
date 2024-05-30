$ErrorActionPreference = "Stop"

# Установка и импорт модуля PrometheusExporter
Install-Module -Name PrometheusExporter -Force
Import-Module -Name PrometheusExporter

# Определение метрик
$DedupQueue = New-MetricDescriptor -Name "dedup_queue_count" -Type gauge -Help "Total current dedup tasks"
$DedupProcess = New-MetricDescriptor -Name "dedup_process_count" -Type gauge -Help "Total current dedup processes" -Labels "process"
$DedupProgress = New-MetricDescriptor -Name "dedup_progress_count" -Type gauge -Help "Current progress of dedup jobs" -Labels "volume"
$DedupSavedSpace = New-MetricDescriptor -Name "dedup_saved_space_count" -Type gauge -Help "Count of saved space" -Labels "volume"
$DedupOptimizedFiles = New-MetricDescriptor -Name "dedup_optimized_files_count" -Type gauge -Help "Count of optimized files" -Labels "volume"
$DedupInpolicyFiles = New-MetricDescriptor -Name "dedup_inpolicy_files_count" -Type gauge -Help "Count of in-policy files" -Labels "volume"

function collector {
    # Получение информации о состоянии дедупликации
    $DedupJobs = Get-DedupJob -Type Optimization
    $QueueCount = (($DedupJobs).Type).Count

    $DedupVolume = Get-DedupVolume
    $DedupStatus = Get-DedupStatus

    $Metrics = @()

    foreach ($Volume in $DedupVolume) {
        $VolumeName = $Volume.Volume
        $SavedSpace = [float]($Volume.SavedSpace)
        $OptimizedFiles = [float]($DedupStatus | Where-Object { $_.Volume -eq $VolumeName }).OptimizedFilesCount
        $InpolicyFiles = [float]($DedupStatus | Where-Object { $_.Volume -eq $VolumeName }).InPolicyFilesCount
        $Progress = [float]($DedupJobs | Where-Object { $_.Volume -eq $VolumeName }).Progress

        $Metrics += New-Metric -MetricDesc $DedupProgress -Value $Progress -Labels $VolumeName
        $Metrics += New-Metric -MetricDesc $DedupSavedSpace -Value $SavedSpace -Labels $VolumeName
        $Metrics += New-Metric -MetricDesc $DedupOptimizedFiles -Value $OptimizedFiles -Labels $VolumeName
        $Metrics += New-Metric -MetricDesc $DedupInpolicyFiles -Value $InpolicyFiles -Labels $VolumeName
    }

    $Metrics += New-Metric -MetricDesc $DedupQueue -Value $QueueCount

    # Подсчет количества процессов с именем fsdmhost.exe
    $ProcessCount = (Get-Process -Name "fsdmhost" -ErrorAction SilentlyContinue).Count
    $Metrics += New-Metric -MetricDesc $DedupProcess -Value $ProcessCount -Labels "fsdmhost"

    return $Metrics
}

# Запуск Prometheus Exporter
$exp = New-PrometheusExporter -Port 9700
Register-Collector -Exporter $exp -Collector $Function:collector
$exp.Start()
