#!/bin/bash
GPUS=${1}
CHANNELS=${2}
L=${3}
DATA=${4}
SUBSET=${5}
SEED=${6:-123}
SPIN_CHARGE=${7:-""}
SPIN_CHARGE=${SPIN_CHARGE//"SPACE"/" "}
LABEL=${8:-""}
BATCH_SIZE=$(( 1280 / GPUS ))
VALID_BATCH_SIZE=$(( 2 * BATCH_SIZE ))
BS_LABEL=$(( GPUS * BATCH_SIZE ))
echo "GPU "${GPUS}" / model size "${CHANNELS}" / data "${DATA}" / spin_charge "${SPIN_CHARGE}" / label "${LABEL}" / seed "${SEED}
NAME="MACE"${LABEL}"_"${CHANNELS}"_"${L}"_"${DATA}"-"${SUBSET}"_bs"${BS_LABEL}"_s"${SEED}
pscratch="/pscratch/sd/k/khegazy/"

if [[ ${SUBSET} =~ "chunk" ]]; then
    SUBSET_EVAL="full"
else
    SUBSET_EVAL=${SUBSET}
fi


#torchrun --standalone --nnodes 1 --nproc_per_node 4 ./scripts/run_train.py ${SPIN_CHARGE} \
python3 ./scripts/run_train.py ${SPIN_CHARGE} \
    --name="$NAME"\
    --wandb_name="$NAME"\
    --model="MACE" \
    --seed=${SEED} \
    --interaction_first="RealAgnosticResidualInteractionBlock" \
    --interaction="RealAgnosticResidualInteractionBlock" \
    --num_radial_basis=8 \
    --num_interactions=2 \
    --num_channels=${CHANNELS} \
    --max_L=${L} \
    --max_ell=3 \
    --MLP_irreps="16x0e" \
    --energy_weight=5.0 \
    --forces_weight=1000.0 \
    --swa_energy_weight=100 \
    --swa_forces_weight=100 \
    --r_max=5.0 \
    --train_file="${pscratch}datasets/molecular/radQM9/"${DATA}"/"${SUBSET}"/train" \
    --valid_file="${pscratch}datasets/molecular/radQM9/"${DATA}"/"${SUBSET_EVAL}"/val" \
    --test_file="${pscratch}/datasets/molecular/radQM9/"${DATA}"/"${SUBSET_EVAL}"/test" \
    --statistics_file="${pscratch}/datasets/molecular/radQM9/"${DATA}"/"${SUBSET}"/statistics.json" \
    --multi_processed_test \
    --atomic_numbers="[1, 6, 7, 8, 9]" \
    --total_charges="[-1, 0, 1]" \
    --spins="[1, 2, 3]" \
    --config_type_weights='{"Default":1.0}' \
    --distributed \
    --device=cuda \
    --amsgrad \
    --lr=0.001 \
    --clip_grad=100 \
    --batch_size=${BATCH_SIZE} \
    --valid_batch_size=${VALID_BATCH_SIZE} \
    --max_num_epochs=600 \
    --swa \
    --start_swa=500 \
    --eval_interval=1 \
    --num_workers=16 \
    --ema \
    --ema_decay=0.99 \
    --wandb \
    --wandb_project="radQM9" \
    --wandb_entity="kreme191" \
    --checkpoints_dir="${pscratch}projects/chemistry/radQM9/checkpoints/${NAME}"\
    --keep_checkpoints \
    --save_cpu \
    --restart_latest
    #--spin_charge_embeddings \
    #--spin_charge_multitask \
    #--E0s='{1:-13.663181292231226, 6:-1029.2809654211628, 7:-1484.1187695035828, 8:-2042.0330099956639}' \
    #--hidden_irreps=${CHANNELS}"x0e + "${CHANNELS}"x1o" \
