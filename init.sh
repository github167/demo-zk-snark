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

# prove that we know we are able to factorize c e.g. know a and b s.t. c==a*b
cat << EOF > circuit.circom
   template Multiplier() {
       signal private input a;
       signal private input b;
       signal output c;
       signal inva;
       signal invb;
       
       inva <-- 1/(a-1);
       (a-1)*inva === 1;
       
       invb <-- 1/(b-1);
       (b-1)*invb === 1;    
       
       c <== a*b;
   }
   component main = Multiplier();
EOF

cat << EOF > input-ok.json
{"a": 2, "b": 17}
EOF

cat << EOF > input-err.json
{"a": 1, "b": 34}
EOF

# gen circuit
circom circuit.circom --r1cs --wasm --sym
snarkjs r1cs info circuit.r1cs
snarkjs r1cs print circuit.r1cs circuit.sym
snarkjs r1cs export json circuit.r1cs circuit.json

# gen proof and verification keys
snarkjs zkey new circuit.r1cs powersOfTau28_hez_final_10.ptau circuit_final.zkey

#extract verification key
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json

# gen proof.json public.json
snarkjs groth16 fullprove input-ok.json circuit.wasm circuit_final.zkey

# verify, should be ok
snarkjs groth16 verify verification_key.json public.json proof.json

# use err input, should fail
snarkjs groth16 fullprove input-ok.json circuit.wasm circuit_final.zkey
snarkjs groth16 verify verification_key.json public.json proof.json

# c change to 35 and so a*b <> c, proof fail
cat << EOF > public-34.json
[
 "35"
]
EOF

snarkjs groth16 verify verification_key.json public-35.json proof.json

# gen sol
snarkjs zkey export solidityverifier circuit_final.zkey verifier.sol

# gen witness
snarkjs wtns calculate circuit.wasm input-ok.json witness.wtns
snarkjs wtns export json witness.wtns witness.json
cat witness.json

# gen proof.json and public.json through witness.wtns
snarkjs groth16 prove circuit_final.zkey witness.wtns proof.json public.json

# gen data for solidity for testing
snarkjs zkey export soliditycalldata public.json proof.json
