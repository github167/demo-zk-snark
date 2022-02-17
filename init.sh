# from https://github.com/iden3/circom_old/blob/master/TUTORIAL.md
# youtube: https://www.youtube.com/watch?v=Oaub9QwwgCA (Introduction to zk-SNARKs with circom and snarkjs examples)
# concept: https://media.consensys.net/introduction-to-zksnarks-with-examples-3283b554fc3b

git clone https://github.com/iden3/snarkjs
cd snarkjs
npm install
cd build

wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau

npm install -g circom
npm install -g snarkjs

cat << EOF > circuit.circom
template Multiplier() {
    signal private input a;
    signal private input b;
    signal output c;

    c <== a*b;
}
component main = Multiplier();
EOF
cat << EOF > input.json
{"a": 3, "b": 11}
EOF

# gen circuit
circom circuit.circom --r1cs --wasm --sym
snarkjs r1cs info circuit.r1cs
snarkjs r1cs print circuit.r1cs circuit.sym
snarkjs r1cs export json circuit.r1cs circuit.json

# gen proof and verification keys
snarkjs zkey new circuit.r1cs powersOfTau28_hez_final_10.ptau circuit_final.zkey

# gen sol
snarkjs zkey export solidityverifier circuit_final.zkey verifier.sol

# gen proof.json public.json
snarkjs groth16 fullprove input.json circuit.wasm circuit_final.zkey

#extract verification key
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json

# verify!
snarkjs groth16 verify verification_key.json public.json proof.json

# gen witness
snarkjs wtns calculate circuit.wasm input.json witness.wtns
snarkjs wtns export json witness.wtns witness.json
cat witness.json

# gen proof.json and public.json through witness.wtns

snarkjs groth16 prove circuit_final.zkey witness.wtns proof.json public.json
