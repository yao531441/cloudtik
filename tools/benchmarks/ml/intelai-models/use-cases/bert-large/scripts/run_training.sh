#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../../../common/scripts/setenv.sh

BERT_HOME=$INTELAI_MODELS_WORKSPACE/bert
BERT_MODEL=$BERT_HOME/model
BERT_DATA=$BERT_HOME/data
BERT_OUTPUT=$BERT_HOME/output

PRECISION=fp32

function usage(){
    echo "Usage: run-training.sh  [ --precision fp32 | bf16 | bf32] "
    exit 1
}

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
    --precision)
        shift
        PRECISION=$1
        ;;
    *)
        usage
    esac
    shift
done


export OUTPUT_DIR=$BERT_OUTPUT
export DATASET_DIR=$BERT_DATA
export TRAIN_SCRIPT=${MODELS_HOME}/models/language_modeling/pytorch/bert_large/training/run_pretrain_mlperf.py
mkdir -p $OUTPUT_DIR


# For phase 1 get the bert config from <https://drive.google.com/drive/folders/1oQF4diVHNPCclykwdvQJw8n_VIWwV0PT>

export BERT_MODEL_CONFIG=$BERT_MODEL/bert_config.json

# Run the phase 1 quickstart script for fp32 (or bf16)
cd ${MODELS_HOME}/quickstart/language_modeling/pytorch/bert_large/training/cpu

# Remove dense_seq_output option
line_number=`grep -n "dense_seq_output" run_bert_pretrain_phase1.sh | cut -d: -f1`
sed -i -e $line_number"d" run_bert_pretrain_phase1.sh

bash run_bert_pretrain_phase1.sh $PRECISION
