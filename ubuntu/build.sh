#!/bin/bash -ex

yq -n 'load("autoinstall.yml") *+ load("autoinstall.home.yml")' >./build/autoinstall.home.yml
yq -n 'load("autoinstall.yml") *+ load("autoinstall.work.yml")' >./build/autoinstall.work.yml
