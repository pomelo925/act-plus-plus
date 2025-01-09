# Koch ACTPP

#### Local Environment
* Ubuntu 18.04 (or above)
* x86 arch

#### Usage
1. clone this repo.
    ```
    git clone https://github.com/pomelo925/koch-actpp.git
    cd koch-actpp
    ```

2. startup docker container.
   ```
   cd docker/gpu
   ./gpu_run.sh
   ```

3. Navigate to container.

   a. Train with sample episodes.
     
    ```sh
    ## download sample episodes (~50GB)
    # do not alter dataset_dir
    python3 record_sim_episodes.py --task_name sim_transfer_cube_scripted --dataset_dir /scr/datasets/sim_transfer_cube_scripted --num_episodes 50

    ## train with actpp model
    # you might need setup wandb
    python3 imitate_episodes.py --task_name sim_transfer_cube_scripted --ckpt_dir /scr/datasets/sim_transfer_cube_scripted/ckpt --policy_class ACT --kl_weight 10 --chunk_size 100 --hidden_dim 512 --batch_size 8 --dim_feedforward 3200 --num_steps 2000  --lr 1e-5 --seed 0
    ```

