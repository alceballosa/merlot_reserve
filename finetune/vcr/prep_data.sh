#!/usr/bin/env bash

export NUM_FOLDS=256
export NUM_FOLDS_VAL=8
export DATA_DIR=/home/alberto/workspace/datasets/vcr
export MRESERVE_DIR=/home/alberto/workspace/datasets/mreserve-storage

mkdir -p logs
parallel -j $(nproc --all) --will-cite "python prep_data.py -fold {1} -base_fn ${MRESERVE_DIR} -data_dir ${DATA_DIR} -num_folds ${NUM_FOLDS} > logs/trainlog{1}.txt" ::: $(seq 0 $((${NUM_FOLDS}-1)))
parallel -j $(nproc --all) --will-cite "python prep_data.py -fold {1} -base_fn ${MRESERVE_DIR} -data_dir ${DATA_DIR} -num_folds ${NUM_FOLDS_VAL} -split=val > logs/vallog{1}.txt" ::: $(seq 0 $((${NUM_FOLDS_VAL}-1)))
parallel -j $(nproc --all) --will-cite "python prep_data.py -fold {1} -base_fn ${MRESERVE_DIR} -data_dir ${DATA_DIR} -num_folds ${NUM_FOLDS_VAL} -split=test > logs/testlog{1}.txt" ::: $(seq 0 $((${NUM_FOLDS_VAL}-1)))