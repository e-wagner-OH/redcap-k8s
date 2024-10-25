#!/bin/bash

# Array of namespaces and pod names for port-forwarding
# Each element contains 'namespace pod_name local_port:remote_port'
PORT_FORWARDING_TARGETS=(
  "default mailhog 8025:8025"
  "default mailhog 1025:1025"
  "default debug-pod 8080:8080"
)

# Loop through the targets and create a port-forward for each
for TARGET in "${PORT_FORWARDING_TARGETS[@]}"
do
  # Split the target into components
  NAMESPACE=$(echo $TARGET | awk '{print $1}')
  POD=$(echo $TARGET | awk '{print $2}')
  PORT_MAPPING=$(echo $TARGET | awk '{print $3}')

  # Start a port-forward in the background
  echo "Port-forwarding for pod $POD in namespace $NAMESPACE on ports $PORT_MAPPING"
  kubectl port-forward -n $NAMESPACE pod/$POD $PORT_MAPPING &

  # Wait a bit to ensure port-forward is established
  sleep 2
done

# Wait for all port-forward processes to complete
wait
