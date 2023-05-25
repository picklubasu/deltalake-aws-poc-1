#!/bin/sh

build_application() {
	sam build --template-file ${PREBUILD_TEMPLATE_PATH}
}

package_application() {
	### YOU MUST SPECIFY A KMS KEY TO USE WHEN PACKAGING YOUR TEMPLATE ###
	sam package --template-file .aws-sam/build/template.yaml --kms-key-id alias/aws/s3 --s3-bucket ${S3_DEPLOY_BUCKET} --output-template-file ${TEMPLATE_PATH}
}

package_deploy() {
	#sam deploy --template-file ${CODEBUILD_SRC_DIR}/template.yml --stack-name llypharma-data-execution --parameter-overrides "$(jq -j 'to_entries[] | "\(.key)='\\\"'\(.value)'\\\"''\ '"' params.json)"
	#SAM_PARAMETERS=$( cat ${CODEBUILD_SRC_DIR}/param.json | jq -r ' .Parameters | to_entries[] | "\(.key)='\\\"'\(.value)'\\\"''\ '"' )
	sam deploy --template-file ${CODEBUILD_SRC_DIR}/prebuild_template.yml --stack-name 	deltalake-aws-poc-1
}

# Copy python packages

#CONFIG_PACKAGE_FOLDER="$CODEBUILD_SRC_DIR/config/package/"
#S3_PACKAGE_CONFIG_FOLDER=${S3_PACKAGE_CONFIG_FOLDER}
#echo "Copying package files..."
#aws s3 cp $CONFIG_PACKAGE_FOLDER $S3_PACKAGE_CONFIG_FOLDER --recursive

# Copy codes
#CODE_PACKAGE_FOLDER="$CODEBUILD_SRC_DIR/config/code/"
#S3_PACKAGE_CODE_FOLDER=${S3_PACKAGE_CODE_FOLDER}
#echo "Copying package files..."
#aws s3 cp $CODE_PACKAGE_FOLDER $S3_PACKAGE_CODE_FOLDER --recursive


#cd $STARTING_DIR
#unset STARTING_DIR
#echo "Completed pre_build - $(date)"

echo "Starting pre_build - $(date)"
STARTING_DIR=$PWD
set -xe
build_application
package_deploy
echo "Completed build - $(date)"