1. https://github.com/MarcusWentz/zkSnarks_circom_snarkj
2. git clone to your desktop
3. npm install
   
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
snarkjs wtns export json witness.wtns witness.json
cat witness.json
```
