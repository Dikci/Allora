#!/bin/bash
docker stop head-basic-eth-pred inference-basic-eth-pred worker updater-basic-eth-pred
docker rm head-basic-eth-pred inference-basic-eth-pred worker updater-basic-eth-pred
rm -rf allora.sh allora-chain/ basic-coin-prediction-node/  .allorad

BOLD="\033[1m"
UNDERLINE="\033[4m"
DARK_YELLOW="\033[0;33m"
CYAN="\033[0;36m"
GREEN="\033[0;32m"
RESET="\033[0m"

echo -e "\nОднострочнник сделал канал Dikci crypto🙈, все актуальные ноды там https://t.me/DikciCrypto"🔥🔥

execute_with_prompt() {
    echo -e "${BOLD}Executing: $1${RESET}"
    if eval "$1"; then
        echo "Command executed successfully."
    else
        echo -e "${BOLD}${DARK_YELLOW}Error executing command: $1${RESET}"
        exit 1
    fi
}

echo -e "${BOLD}${UNDERLINE}${DARK_YELLOW}Requirement for running allora-worker-node${RESET}"
echo
echo -e "${BOLD}${DARK_YELLOW}Operating System : Ubuntu 22.04${RESET}"
echo -e "${BOLD}${DARK_YELLOW}CPU : Min of 1/2 core.${RESET}"
echo -e "${BOLD}${DARK_YELLOW}RAM : 2 to 4 GB.${RESET}"
echo -e "${BOLD}${DARK_YELLOW}Storage : SSD or NVMe with at least 5GB of space.${RESET}"
echo

echo -e "${CYAN}Do you meet all of these requirements? (Y/N):${RESET}"
read -p "" response
echo

if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo -e "${BOLD}${DARK_YELLOW}Error: You do not meet the required specifications. Exiting...${RESET}"
    echo
    exit 1
fi

echo -e "${BOLD}${DARK_YELLOW}Updating system dependencies...${RESET}"
execute_with_prompt "sudo apt update -y && sudo apt upgrade -y"
echo

echo -e "${BOLD}${DARK_YELLOW}Installing jq packages...${RESET}"
execute_with_prompt "sudo apt install jq"
echo

echo -e "${GREEN}${BOLD}Request faucet to your wallet from this link:${RESET} https://faucet.testnet-1.testnet.allora.network/"
echo

echo -e "${BOLD}${UNDERLINE}${DARK_YELLOW}Installing worker node...${RESET}"
curl -sSL https://raw.githubusercontent.com/allora-network/allora-chain/main/install.sh | bash -s -- v0.3.0
allorad version
git clone https://github.com/allora-network/basic-coin-prediction-node
cd basic-coin-prediction-node
echo
read -p "Enter WALLET_SEED_PHRASE: " WALLET_SEED_PHRASE
echo
echo -e "${BOLD}${UNDERLINE}${DARK_YELLOW}Generating config.json file...${RESET}"
cat <<EOF > config.json
{
    "wallet": {
        "addressKeyName": "testkey",
        "addressRestoreMnemonic": "$WALLET_SEED_PHRASE",
        "alloraHomeDir": "",
        "gas": "auto",
        "gasAdjustment": 1.5,
        "nodeRpc": "https://rpc.ankr.com/http/allora_testnet",
        "maxRetries": 1,
        "delay": 1,
        "submitTx": true
    },
     "worker": [
       {
           "topicId": 1,
           "inferenceEntrypointName": "api-worker-reputer",
           "loopSeconds": 1,
           "parameters": {
               "InferenceEndpoint": "http://inference:8000/inference/{Token}",
               "Token": "ETH"
           }
       },
       {
           "topicId": 2,
           "inferenceEntrypointName": "api-worker-reputer",
           "loopSeconds": 3,
           "parameters": {
               "InferenceEndpoint": "http://inference:8000/inference/{Token}",
               "Token": "ETH"
           }
       },
       {
           "topicId": 3,
           "inferenceEntrypointName": "api-worker-reputer",
           "loopSeconds": 5,
           "parameters": {
               "InferenceEndpoint": "http://inference:8000/inference/{Token}",
               "Token": "BTC"
           }
       },
       {
           "topicId": 4,
           "inferenceEntrypointName": "api-worker-reputer",
           "loopSeconds": 2,
           "parameters": {
               "InferenceEndpoint": "http://inference:8000/inference/{Token}",
               "Token": "BTC"
           }
       },
       {
           "topicId": 5,
           "inferenceEntrypointName": "api-worker-reputer",
           "loopSeconds": 4,
           "parameters": {
               "InferenceEndpoint": "http://inference:8000/inference/{Token}",
               "Token": "SOL"
           }
       },
       {
           "topicId": 6,
           "inferenceEntrypointName": "api-worker-reputer",
           "loopSeconds": 5,
           "parameters": {
               "InferenceEndpoint": "http://inference:8000/inference/{Token}",
               "Token": "SOL"
           }
       },
       {
           "topicId": 7,
           "inferenceEntrypointName": "api-worker-reputer",
           "loopSeconds": 2,
           "parameters": {
               "InferenceEndpoint": "http://inference:8000/inference/{Token}",
               "Token": "ETH"
           }
       },
       {
           "topicId": 8,
           "inferenceEntrypointName": "api-worker-reputer",
           "loopSeconds": 3,
           "parameters": {
               "InferenceEndpoint": "http://inference:8000/inference/{Token}",
               "Token": "BNB"
           }
       },
       {
           "topicId": 9,
           "inferenceEntrypointName": "api-worker-reputer",
           "loopSeconds": 5,
           "parameters": {
               "InferenceEndpoint": "http://inference:8000/inference/{Token}",
               "Token": "ARB"
           }
       }
       
   ]
}

EOF

echo -e "${BOLD}${DARK_YELLOW}config.json file generated successfully!${RESET}"

sleep 30

cd basic-coin-prediction-node

cat <<EOF > .env
TOKEN=ETH
TRAINING_DAYS=30
TIMEFRAME=4h
MODEL=SVR
REGION=US
DATA_PROVIDER=binance
CG_API_KEY=
EOF

chmod +x init.config
./init.config
docker compose up --build -d
docker compose logs -f

