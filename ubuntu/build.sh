#!/bin/bash -ex

yq -n 'load("autoinstall.yml") *+ load("autoinstall.home.yml")' >./public/home.yml
yq -n 'load("autoinstall.yml") *+ load("autoinstall.work.yml")' >./public/work.yml
