#!/usr/bin/env bash

if [ -x "$(command -v nc)" ]; then
  echo "Checking port 31337"

  check_port=$(nc -z localhost 31337)

  if ! $check_port; then
    echo "Seems like port 31337 is already in use?"
  else
    echo "port 31337 available"
  fi
fi

echo
echo "Trying to run Nginx from docker.io/library/nginx..."

kubectl create deployment nginx --image=nginx:alpine

echo
echo "Waiting until the pod is up"

kubectl wait deployment nginx --for condition=Available=True --timeout=90s

echo
echo "Creating service"

##CHANGING to expose deployment

kubectl expose deployment nginx --port=31377 --target-port=80 --type=NodePort --name=nginx-svc

if [ $? -eq 0 ]; then
  determine_ip=$(kubectl get svc nginx -o jsonpath="{.spec.clusterIP}")

  echo
  echo "Our nginx app is ready. Probably you check your app at $determine_ip:31337"
fi

echo
echo "Since I can't collect any errors, if you believe the error is on my end please hit me up at fariz@delman.io, thank you."
echo
echo "Now it's your turn. GLHF!"
echo
