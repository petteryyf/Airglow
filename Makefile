.PHONY: help render test deploy

help: ## 显示所有命令
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

render: ## （无需任何依赖）本地渲染第一帧「火星气辉」，生成 PNG/SVG
	python3 rasterize.py

test: ## 运行合约单测（需要 Foundry）
	forge test -vv

deploy: ## 部署到 BNB Chain 并渲染第一帧（需要 PRIVATE_KEY + BSC_RPC_URL）
	source .env && forge script script/DeployAirglow.s.sol:DeployAirglow --rpc-url $$BSC_RPC_URL --broadcast -vvvv
