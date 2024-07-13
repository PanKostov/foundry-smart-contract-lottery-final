source .env
echo SEPOLIA_RPC_URL

forge-test --match-test testName -vvv -fork-url $SEPOLIA_RPC_URL - to run test on sepolia url ( anvil will simulate our transaction as if they were on sepolia env)

with $MAINNET_RPC_URL - runs the test on a forked mainnet - (Forking the mainnet will simulate having the same state as mainnet, but it will work as a local development network. 
That way you can interact with deployed protocols and test complex interactions locally.)


forge snapshot - to run tests with shown gas costs

forge inspect `contarctName` storageLayout

cast sig "nameofFunction()" to get the bytes code

anvil

cast wallet import defaultKey --interactive - saves a private key

cast wallet list - show saved private keys

forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url http://localhost:8545 --account defaultKey --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266  --broadcast -vvvv 

-The above will deploy on Anvil by using the stored private key via cast ( for the first Anvil private key and account address - I copied them from there)


cast --to-base 0x714c2 dec - from bytes to decimal

(check cast send and cast call to interact with smart contract via CLI)



2. Installing zksyncup
after installing https://github.com/matter-labs/foundry-zksync

run this command - founrdyup-zksync

to go back to vanilla foundry run - foundryup