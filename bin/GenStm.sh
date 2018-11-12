#!/bin/bash

# see function usage for script details

Version="1"

checkJava() {
  inst=`which java`
  if [ -z $inst ]; then
    echo "Unable to find java, Please install java! Abort"
    exit 1
  fi
}

checkRefurbishStm() {
  #inst=`which RefurbishStm.pl`
  inst=`which RefurbishStmPcm.pl`
  if [ -z $inst ]; then
    echo "Unable to find RefurbishStm.pl, Please install! Abort"
    exit 1
  fi
}

deleteFiles() {
   rm -rv "${stmPath}"
}

# how to use the script
function usage
{
  echo "$0 Version $Version"
  echo "Uses stmgen to generate a statemachine from an EA export file in a temporary"
  echo "directory. Then the generated source code is adapted with the script"
  echo "'RefurbishStm.pl'. The adapted code is created in the working directory and the"
  echo "temporary directory is deleted after adaption."
  echo "usage:"
  echo "\> $0 <Namespace> <Path2Stm> <NameStm>"
  echo "Namespace Full qualified C++ namespace that is used for the stm."
  echo "Path2Stm  Path to the statemachine in the EA export file."
  echo "NameStm   The name of the statemachine in the EA export file."
  echo ""
  echo "The following environment variable have to be set:"
  echo "PATH_STMGEN_JAR : The absolute path to the stmgen jar file."
  exit 1
}

# check if input is allright
if [ -z "$STMGEN_JAR_PATH" ]; then # env
  usage
fi

if (( $# != 3  )); then # number of arguments
   usage
fi

checkJava
checkRefurbishStm

# taken from config file and differ between state machines
namespace=$1 # "tsd::bt::manage"
stmPath=$2 # "stm"
stmName=$3 # "StatusStm"

# global variables
# path2Stmgen="/home/user/sw/stmgen/tsd.common.tools.stmgen.jar"
numberXmls=`ls *.xml | egrep -c "xml"`
inputFile=`find . -name "*.xml"`
outputPath=`pwd`

if [[ "1" -ne "${numberXmls}" ]]; then
  echo "Unable to determine input file:"
  echo $inputFile
  echo "Abort"
  exit 2
fi

echo "Start stmgen for file '${inputFile}'"
myJavaCall="java -jar ${STMGEN_JAR_PATH} -show-error-location -name=${stmPath}/${stmName} -import-format=sparxea -i=${inputFile} -o=${outputPath}"
/bin/bash -c "$myJavaCall"
# java -jar ${STMGEN_JAR_PATH} -show-error-location -name="${stmPath}/${stmName}" -import-format=sparxea -i="${inputFile}" -o="${outputPath}"

if [ -d $stmPath ]; then
  echo "Refurbish generated code in '${stmPath}'"
  RefurbishStm.pl $namespace $stmPath $stmName
else
  echo "Java generation failed. Abort"
  exit 3
fi

echo "Delete old files in '${stmPath}'"
deleteFiles

exit 0
