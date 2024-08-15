#!/bin/bash

rm -rf allora.sh allora-chain/ basic-coin-prediction-node/

BOLD="\033[1m"
UNDERLINE="\033[4m"
DARK_YELLOW="\033[0;33m"
CYAN="\033[0;36m"
GREEN="\033[0;32m"
RESET="\033[0m"

🔥🔥echo -e "\nОднострочнник сделал канал Dikci crypto🙈, все актуальные ноды там https://t.me/DikciCrypto"🔥🔥

echo -e "${BOLD}${DARK_YELLOW}Updating system dependencies...${RESET}"
execute_with_prompt "sudo apt update -y && sudo apt upgrade -y"
echo

echo -e "${BOLD}${DARK_YELLOW}Installing jq packages...${RESET}"
execute_with_prompt "sudo apt install jq"
echo

echo -e "${GREEN}${BOLD}Request faucet to your wallet from this link:${RESET} https://faucet.testnet-1.testnet.allora.network/"
echo

echo -e "${BOLD}${UNDERLINE}${DARK_YELLOW}Installing worker node...${RESET}"
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
        "gas": "1000000",
        "gasAdjustment": 1.0,
        "nodeRpc": "https://allora-rpc.testnet-1.testnet.allora.network/",
        "maxRetries": 1,
        "delay": 1,
        "submitTx": false
    },
    "worker": [
        {
            "topicId": 1,
            "inferenceEntrypointName": "api-worker-reputer",
            "loopSeconds": 5,
            "parameters": {
                "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                "Token": "ETH"
            }
        },
        {
            "topicId": 2,
            "inferenceEntrypointName": "api-worker-reputer",
            "loopSeconds": 5,
            "parameters": {
                "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                "Token": "ETH"
            }
        },
        {
            "topicId": 7,
            "inferenceEntrypointName": "api-worker-reputer",
            "loopSeconds": 5,
            "parameters": {
                "InferenceEndpoint": "http://inference:8000/inference/{Token}",
                "Token": "ETH"
            }
        }
    ]
}
EOF

echo -e "${BOLD}${DARK_YELLOW}config.json file generated successfully!${RESET}"
echo
mkdir worker-data
chmod +x init.config
sleep 2
./init.config

echo
echo -e "${BOLD}${UNDERLINE}${DARK_YELLOW}Building and starting Docker containers...${RESET}"
docker compose build
docker-compose up -d
echo
sleep 2
echo -e "${BOLD}${DARK_YELLOW}Checking running Docker containers...${RESET}"
docker ps
echo
execute_with_prompt 'docker logs -f worker'
echo
