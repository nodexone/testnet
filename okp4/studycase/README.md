<h3><p style="font-size:14px" align="right">Founder :
<a href="https://discord.gg/bDUAwZhqBb" target="_blank">NodeX Capital Discord Community</a></p></h3>
<h3><p style="font-size:14px" align="right">Visit Our Website :
<a href="https://nodexcapital.com" target="_blank">NodeX Capital Official</a></p></h3>
<h3><p style="font-size:14px" align="right">Hetzner :
<a href="https://hetzner.cloud/?ref=bMTVi7dcwSgA" target="_blank">Deploy Hetzner VPS Get 20€ Bonus!</a></h3>
<hr>

<p align="center">
  <img height="100" height="100"  src="https://raw.githubusercontent.com/kj89/cosmos-images/main/logos/okp4.png">
</p>

## Description

This study highlighting gas consumption relevancy in relation with elements at your disposal (e.g. Memory and CPU usage). Argued with curated data from your running Node, provide us feedback and suggestions to help us ensuring a fair cost.

We use [okp4-objectarium](https://github.com/okp4/contracts/tree/main/contracts/okp4-objectarium) and [okp4-law-stone](https://github.com/okp4/contracts/tree/main/contracts/okp4-law-stone) smart contracts. Only Druid's delegator addresses can instantiate those contracts, through the code id 2 for cw-storage and 3 for cw-law-stone!

You can also use your current node without recompiling to complete this task

## Gas Consumption Phase 4 **lughnasad**

### Equipment
- Hetzner AX-41 NVMe
- AMD Ryzen™ 5 3600
- RAM 64 GB DDR4
- Disk:	2 x 512GB NVMe
- Bandwidth	1 GBit/s port


## Objecatirum
The `okp4-objectarium` smart contract enables the storage of arbitrary `objects` in any [Cosmos blockchains](https://cosmos.network/) using the [CosmWasm](https://cosmwasm.com/) framework.

This contract allows for storing `objects`, pinning and unpinning `objects` for a given sender address, and it also includes the ability to remove (forget) `objects` if they are no longer pinned.

| Hardware | Action | Hash | Gas |
| ----- | ----------- | ---------------------------------------------------------------- | ------- |
| AX-41 NVMe | Instantiate | 9477924A7882DA319304DFFFE0870EF723016E60F57D7F6853FBA9ADB67940D2 | 178 341 |
| AX-41 NVMe | Execute     | 4E756B5BDAE62892DB8C5B552FB06C9B6B9A7DD552E22B0B737351237640799A | 193 408 |
| AX-41 NVMe | Pin         | 0403E29DA13E068F664330236410E020462B4C060263733F0D5DAC4AAA9DD81E | 149 097 |
| AX-41 NVMe | Unpin       | BCB5528F98E569CD5823048001F6D4A070A84EFFDBB84AC64AA49A45B41BE985 | 167 450 |
| AX-41 NVMe | Forget      | 6ED2766B2A66DE37E817FD73F42BDFBD6204BCEB7044E23E9B31BDE4567C89BF | 170 527 |

The `okp4-objectarium` can be instantiated as follows, refer to the schema for more information on configuration, limits and pagination configuration:

### Variable
- WALLET="your-wallet-address"

```bash
okp4d tx wasm instantiate 2 \
    --label "my-storage" \
    --from $WALLET \
    --admin $WALLET \
    --gas 1000000 \
    --broadcast-mode block \
    '{"bucket":"my-bucket","limits":{}, "config": {}, "pagination": {}}'
```

### Execute
Make test file whatever you want e.g (hello.txt, hello.html) and put on `$HOME` directory 

```bash
okp4d tx wasm execute $CONTRACT \
    --from $WALLET \
    --gas 1000000 \
    --broadcast-mode block \
    "{\"store_object\":{\"data\": \"$(cat $HOME/hello.txt | base64)\",\"pin\":true}}"
```

The object id is stable as it is a hash, we can't store an object twice.

With the following commands we can pin and unpin existing objects:

```bash
okp4d tx wasm execute $CONTRACT \
    --from $WALLET \
    --gas 1000000 \
    --broadcast-mode block \
    "{\"pin_object\":{\"id\": \"$OBJECT_ID\"}}"

okp4d tx wasm execute $CONTRACT \
    --from $WALLET \
    --gas 1000000 \
    --broadcast-mode block \
    "{\"unpin_object\":{\"id\": \"$OBJECT_ID\"}}"
```

And if an object is not pinned, or pinned by the sender of transaction, we can remove it:

```bash
okp4d tx wasm execute $CONTRACT \
    --from $WALLET \
    --gas 1000000 \
    --broadcast-mode block \
    "{\"forget_object\":{\"id\": \"$OBJECT_ID\"}}"
```

### Query Object

Query an object by its id:

```bash
okp4d query wasm contract-state smart $CONTRACT \
    "{\"object\": {\"id\": \"$OBJECT_ID\"}}"
```

Or its data:

```bash
okp4d query wasm contract-state smart $CONTRACT \
    "{\"object_data\": {\"id\": \"$OBJECT_ID\"}}"
```

We can also list the objects, eventually filtering on the object owner:

```bash
okp4d query wasm contract-state smart $CONTRACT \
    "{\"objects\": {\"address\": \"$WALLET\"}}"
```

And navigate in a cursor based pagination:

```bash
okp4d query wasm contract-state smart $CONTRACT \
    "{\"objects\": {\"first\": 5, \"after\": \"32MUGxHoR66M4HT8ga7haKS6tLkJ1w5P4du6q3X9tZqvdSuSHNoUzwQCPwPyW8u5xLxso1Qx99GexVGfLGep1Wfv\"}}"
```

We can also query object pins with the same cursor based pagination:

```bash
okp4d query wasm contract-state smart $CONTRACT \
    "{\"object_pins\": {\"id\": \"$OBJECT_ID\", \"first\": 5, \"after\": \"32MUGxHoR66M4HT8ga7haKS6tLkJ1w5P4du6q3X9tZqvdSuSHNoUzwQCPwPyW8u5xLxso1Qx99GexVGfLGep1Wfv\"}}"

```

## Single Source
The `okp4-law-stone` smart contract aims to provide GaaS (i.e. Governance as a Service) in any [Cosmos blockchains](https://cosmos.network/) using the [CosmWasm](https://cosmwasm.com/) framework and the [Logic](https://docs.okp4.network/modules/next/logic) OKP4 module.

| Hardware | Action | Hash | Gas |
| ----- | ----------- | ---------------------------------------------------------------- | ------- |
| AX-41 NVMe | Instantiate | 404AB3F907EB53E5430828FD4306A98CB6DB18706E276D2D49C8B368F96ED0BA | 542 752 |
| AX-41 NVMe | Break     | 7AC2E6EE3DEB74C056EF9813995589D754C722A5E4DF50E27EE7EF0C6440A277 | 132 160 |

### Download gov.pl
```
wget -0 gov.pl https://raw.githubusercontent.com/okp4/contracts/main/contracts/okp4-law-stone/examples/single-source/gov.pl 
```
You'll find in the [gov.pl](gov.pl) Prolog program some predicates defining the rules allowing to perform some typical Dataspaces actions. make sure u've change the `address` on [gov.pl](gov.pl) with your own address!

### Instantiate

The instantiate will take as parameters the base64 encoded program and the address of a `okp4-objectarium` contract, on which the program will be stored and pinned to prevent its removal and thus ensure its availability:

```bash
okp4d tx wasm instantiate 3 \
    --label "nodex-single-source" \
    --from $WALLET \
    --admin $WALLET \
    --gas 1000000 \
    --broadcast-mode block \
    "{\"program\":\"$(cat gov.pl | base64 -w 0)\", \"storage_address\": \"$CONTRACT\"}"
```

You can retrieve the new `okp4-law-stone` smart contract address in the `_contract_address` instantiate attribute of the transaction.

### Query

By using the `Ask` query we can provide Prolog predicates to be evaluated againsts the underlying program:

```bash
okp4d query wasm contract-state smart $CONTRACT \
    "{\"ask\": {\"query\": \"can('change_governance', 'did:key:$WALLET').\"}}"
```

### Break

Only the smart contract admin can break the stone, if any.

The program stored in the `okp4-objectarium` smart contract will be removed, or at least un-pinned.

By breaking the stone, you will not be able to query it anymore.

```bash
okp4d tx wasm execute $CONTRACT \
    --from $WALLET \
    --gas 1000000 \
    --broadcast-mode block \
    '"break_stone"'
```
