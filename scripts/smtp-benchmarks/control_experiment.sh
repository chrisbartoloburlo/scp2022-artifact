#!/bin/bash
iterations=$1
experiments=$2
type=$3

run=1
wd=`pwd`

while [ "$experiments" -ne 0 ] ; do
  echo "Running SMTP $type Control Experiment $run with $iterations emails..."

  if [ "$type" = "smtp-python" ]; then
    port=1025
  else
    port=25
  fi

  /usr/bin/time --format="%P,%M,%K" java -cp ./examples/target/scala-2.12/examples-assembly-0.0.3.jar examples.smtp.Client ~/capsule/results/ ${iterations} ${run} ${port} control 2>> ~/capsule/results/control_${iterations}_cpu_mem_run.txt

  sleep 1

  echo "Finished SMTP $type Control Experiment $run.\n"

  run=$((run+1))
  experiments=$((experiments-1))
done