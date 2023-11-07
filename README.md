
Goto: https://www.katacoda.com/scenario-examples/courses/environment-usages/nodejs

Original: https://github.com/weijiekoh/zkmm

1. install
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install node

git clone -b mastermind https://github.com/github167/demo-zk-snark
cd demo-zk-snark
npm install
tsc

```

2. test from official js
```
npm run build

```

3. generate our own keys and test
```
npm run mybuild

```
lesson learn

1. circuitJson=circom(circuit.circom)
2. circuit=snarkjs.circuit(circuitJson) -> setup=snarkjs.groth.setup(circuit) -> extract setup.vk_proof and setup.vk_verifier
3. prepare testInput -> witness=snarkjs.Circuit(circuitDef).calculateWitness(testInput) -> {proof, publicsignals}=snarkjs.groth.genProof(pk.json, witness)
4. answer=snarkjs.groth.isValid(vk.json, proof, publicSignals)
