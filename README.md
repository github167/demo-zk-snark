1. https://github.com/MarcusWentz/zkSnarks_circom_snarkj
2. git clone to your desktop
3. npm install
   
```
circom circuit.circom --r1cs --wasm
snarkjs g16s circuit.r1cs pot12_final.ptau circuit_final.zkey
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json
snarkjs g16f input.json circuit.wasm circuit_final.zkey proof.json public.json
snarkjs g16v verification_key.json public.json proof.json
snarkjs zkey export solidityverifier circuit_final.zkey verifier.sol
snarkjs zkey export soliditycalldata public.json proof.json
```
