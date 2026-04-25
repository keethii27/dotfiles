#!/bin/sh

git branch --merged | grep -vE "(^\*|main|master|develop)" | xargs git branch -d
