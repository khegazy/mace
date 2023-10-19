#!\bin\bash

python ./scripts/preprocess_data.py \
    --train_file="/pscratch/sd/k/khegazy/datasets/molecular/radQM9/rad_qm9_60_20_20_train_debug.xyz" \
    --valid_file="/pscratch/sd/k/khegazy/datasets/molecular/radQM9/rad_qm9_60_20_20_valid_debug.xyz" \
    --test_file="/pscratch/sd/k/khegazy/datasets/molecular/radQM9/rad_qm9_60_20_20_test_debug.xyz" \
    --num_process=4 \
    --atomic_numbers="[1, 6, 7, 8, 9, 15, 16, 17, 35, 53]" \
    --total_charges="[-1, 0, 1]" \
    --spins="[0, 1, 2, 3]" \
    --r_max=5.0 \
    --h5_prefix="h5_data_" \
    --seed=123 \
    --E0s="average" #WHAT IS THIS???? BREAKS IF REMOVED
    #--energy_key="energies" \
    #--forces_key="forces" \
