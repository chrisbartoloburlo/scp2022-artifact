#!/bin/bash
iterations=$1
experiments=$2
type=$3
log=$4

run=1
wd=`pwd`

while [ "$experiments" -ne 0 ] ; do
  if [ "$type" = "smtp-python" ]; then
    port=1025
  else
    port=25
  fi

  if [ "$log" = "false" ]; then
    echo "Running SMTP $type Detached Monitored without logging Experiment $run with $iterations emails..."
    screen -S stmonbench -dm bash -c "/usr/bin/time --format=\"%P,%M,%K\" java -cp ./examples/target/scala-2.12/examples-assembly-0.0.3.jar examples.smtp.MonWrapper $port 1025 $log 2>> ~/capsule/results/detached_monitored_${iterations}_cpu_mem_run.txt"
  elif [ "$log" = "true" ]; then
    echo "Running SMTP $type Detached Monitored with logging Experiment $run with $iterations emails..."
    screen -S stmonbench -dm bash -c "/usr/bin/time --format=\"%P,%M,%K\" java -cp ./examples/target/scala-2.12/examples-assembly-0.0.3.jar examples.smtp.MonWrapper $port 1025 $log 2>> ~/capsule/results/detached_monitored_logging_${iterations}_cpu_mem_run.txt"
  else
    echo "Error in logging flag"
    exit
  fi


  sleep 1

  if [ "$log" = "false" ]; then
    java -cp ./examples/target/scala-2.12/examples-assembly-0.0.3.jar examples.smtp.Client ~/capsule/results/ ${iterations} ${run} 1025 detached_monitored
  else
    java -cp ./examples/target/scala-2.12/examples-assembly-0.0.3.jar examples.smtp.Client  ~/capsule/results/ ${iterations} ${run} 1025 detached_monitored
  fi

  screen -S stmonbench -p 0 -X stuff "^C" > /dev/null 2>&1
  echo "Finished SMTP $type Detached Monitored Experiment $run.\n"

  run=$((run+1))
  experiments=$((experiments-1))
done