#!/bin/bash
GPUS=${1}
NNODES=$(( GPUS / 4 ))
CHANNELS=${2}
L=${3}
DATA=${4}
SUBSET=${5}
OPT_SPIN_CHARGE=${6}
LR=0.001
if (( $OPT_SPIN_CHARGE == 0 )) ; then
    SPIN_CHARGE="--spin_charge_embeddingsSPACE--spin_charge_multitask"
    LABEL="_embed_mtask"
    #LR=0.001
elif (( $OPT_SPIN_CHARGE == 1 )) ; then
    SPIN_CHARGE="--spin_charge_embeddings"
    LABEL="_embed"
    #LR=0.0001
elif (( $OPT_SPIN_CHARGE == 2 )) ; then
    SPIN_CHARGE="--spin_charge_multitask"
    LABEL="_mtask"
    #LR=0.0001
else
    SPIN_CHARGE=""
    LABEL=""
    #LR=0.001
fi
SEED=${7:-501}
JOBNAME=${LABEL}${CHANNELS}"-"${L}"_"${NNODES}"_"${DATA}"-"${SUBSET}

#gpu&hbm80g
sbatch <<EOT
#!/bin/bash
#SBATCH -A m4298 # Account
#SBATCH -C gpu      # Constraint (type of resource)
#SBATCH -q regular  # Queue
#SBATCH -o slurm_logs/job_%j.out  # send stdout to OUTPUT_FILE
#SBATCH -e slurm_logs/job_%j.out  # send stderr to OUTPUT_FILE
#SBATCH -J $JOBNAME
#SBATCH --mail-type=end           # send email when job ends
#SBATCH -G ${GPUS}
#SBATCH -N ${NNODES}
#SBATCH --ntasks=${GPUS}
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=16
#SBATCH --time=23:00:00
#SBATCH --exclusive
#SBATCH --dependency=singleton

module load pytorch/1.13.1
module load gcc/12.2.0
module load darshan
export SLURM_CPU_BIND="cores"
srun sh run_scripts/run_multiGPU_train.sh ${GPUS} ${CHANNELS} ${L} ${DATA} ${SUBSET} ${SEED} ${SPIN_CHARGE} ${LABEL}
EOT
