#!/bin/bash

istioctl manifest generate -f ./manifest-prd.yaml > istio-prd.yaml