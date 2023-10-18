python3 ./scripts/run_train.py \
    --name="MACE_radqm9_testing_end" \
    --spin_charge_multitask \
    --spin_charge_embedding \
    --wandb_name="testing" \
    --train_file="/pscratch/sd/k/khegazy/datasets/molecular/radQM9/rad_qm9_60_20_20_train_debug.xyz" \
    --valid_file="/pscratch/sd/k/khegazy/datasets/molecular/radQM9/rad_qm9_60_20_20_valid_debug.xyz" \
    --test_file="/pscratch/sd/k/khegazy/datasets/molecular/radQM9/rad_qm9_60_20_20_test_debug.xyz" \
    --energy_weight=15.0 \
    --forces_weight=1000.0 \
    --eval_interval=1 \
    --config_type_weights='{"Default":1.0}' \
    --E0s='average' \
    --error_table='PerAtomRMSE' \
    --model="MACE" \
    --MLP_irreps="128x0e" \
    --interaction_first="RealAgnosticResidualInteractionBlock" \
    --interaction="RealAgnosticResidualInteractionBlock" \
    --num_interactions=2 \
    --max_ell=3 \
    --hidden_irreps='256x0e + 256x1o + 256x2e' \
    --num_cutoff_basis=5 \
    --lr=0.001 \
    --correlation=3 \
    --r_max=5.0 \
    --scaling='rms_forces_scaling' \
    --batch_size=32 \
    --valid_batch_size=32 \
    --max_num_epochs=2 \
    --patience=256 \
    --weight_decay=5e-7 \
    --ema \
    --ema_decay=0.999 \
    --amsgrad \
    --default_dtype="float32"\
    --clip_grad=10 \
    --device=cuda \
    --seed=3 
    #--wandb \
    #--wandb_project="radQM9" \
    #--wandb_entity="kreme191"
    #--radial_MLP="[128, 256, 512, 1024]" \
    #--restart_latest
    #--scaling="no_scaling" \
