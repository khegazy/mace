#!/bin/bash

DATA="trajectory"
SUBSET="full"
GPUS=20
NJOBS=2

for CHANNELS in 128;
do
    for SC_IDX in {0..3};
    do
        for L in 0 1;
        do
            if (( CHANNELS > 64  )) ; then
                if (( L > 1  )) ; then
                    GPUS=20
                elif (( L > 0 )) ; then
                    GPUS=12
                else
                    GPUS=8
                fi
            else
                if (( L > 1  )) ; then
                    GPUS=12
                else
                    GPUS=8
                fi
            fi
            for i in $(seq 1 ${NJOBS});
            do
                sh slurm_scripts/sbatch_submit.sh ${GPUS} ${CHANNELS} ${L} ${DATA} ${SUBSET} ${SC_IDX}
            done
        done
    done
done

#sbatch --job-name=${1} --dependency=singleton slurm_scripts/slurm_submit_gpu.sbatch
