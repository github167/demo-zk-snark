1. From: https://github.com/MarcusWentz/zkSnarks_circom_snarkjs
2. git clone to your desktop
3. install node modules
```
git clone -b minimal-snarkjs https://github.com/github167/demo-zk-snark
cd demo-zk-snark
npm install
```
4. test using command line
```
# create r1cs for keygen, wasm for proof
circom circuit.circom --r1cs --wasm

# generate keys: proof key and verification key
snarkjs g16s circuit.r1cs pot12_final.ptau circuit_final.zkey
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json

# generate proof and public input
snarkjs g16f input.json circuit.wasm circuit_final.zkey proof.json public.json

# verify proof
snarkjs g16v verification_key.json public.json proof.json

# generate sol and input data
snarkjs zkey export solidityverifier circuit_final.zkey verifier.sol
snarkjs zkey export soliditycalldata public.json proof.json

#==== Optional ========
# verify circuit and key
snarkjs zkey verify circuit.r1cs pot12_final.ptau circuit_final.zkey

# generate witness.wtns, and hence proof and public signal
snarkjs wtns calculate circuit.wasm input.json witness.wtns
snarkjs g16p circuit_final.zkey witness.wtns proof.json public.json

# view the wtns as json
snarkjs wtns check circuit.r1cs witness.wtns
snarkjs wtns export json witness.wtns witness.json
cat witness.json
```
5. test using javascript
```
node index.js
```
6. test using html
```
cp node_modules/snarkjs/build/snarkjs.min.js .
# launch index.htm in browser!
```
7. Reference: https://github.com/iden3/snarkjs

Playground

8. Goto: https://www.katacoda.com/scenario-examples/courses/environment-usages/nodejs
```
curl -LSfs https://raw.githubusercontent.com/github167/demo-zk-snark/minimal-snarkjs/init.sh | sh
cd demo-zk-snark
```
