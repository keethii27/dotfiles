#!/bin/sh

git branch --merged | grep -vE "(^\*|master|develop)" | xargs git branch -d
