
compile: 
"truffle compile",

установить тестовую сеть:

truffle migrate --network testnet
testrpc: 
"ganache-cli --deterministic --gasLimit 10000000",

test: 
"truffle test",

test:verbose: 
"VERBOSE=true truffle test",

coverage: 
"yarn solidity-coverage",

lint: 
"eslint .",

lint:contracts: 
"solhint contracts/*.sol"




