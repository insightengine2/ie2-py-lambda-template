#!/bin/bash

declare output="./dist/${CODEBUILD_WEBHOOK_TRIGGER}/${CODEBUILD_BUILD_NUMBER}"

echo ${output}

mkdir ../build

