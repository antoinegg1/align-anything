MODEL_NAME_OR_PATH="/data/models/llava-v1.6-mistral-7b-hf" # model path
TRAIN_DATASETS="/data/changye/data/alpaca" # dataset path
TRAIN_TEMPLATE="Alpaca" # dataset template
TRAIN_SPLIT="train" # split the dataset
OUTPUT_DIR="/data/changye/model/llava-alpaca" # output dir

# Source the setup script
source ./setup.sh

usage(){
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "--model_name_or_path"
    echo "--train_datasets"
    echo "--output_dir"
    echo "--train_template"
    echo "--train_split"
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --model_name_or_path) MODEL_NAME_OR_PATH="$2"; shift ;;
        --train_datasets) TRAIN_DATASETS="$2"; shift ;;
        --output_dir) OUTPUT_DIR="$2"; shift ;;
        --train_template) TRAIN_TEMPLATE="$2"; shift ;;
        --train_split) TRAIN_SPLIT="$2"; shift ;;
        --help) usage; exit 0 ;;
        *) echo "Unknown parameter: $1"; usage; exit 1 ;;
    esac
    shift
done

deepspeed \
	--master_port ${MASTER_PORT} \
	--module align_anything.trainers.text_image_to_text.sft \
	--model_name_or_path ${MODEL_NAME_OR_PATH} \
	--train_datasets ${TRAIN_DATASETS} \
	--train_template ${TRAIN_TEMPLATE} \
	--train_split ${TRAIN_SPLIT} \
	--output_dir ${OUTPUT_DIR}