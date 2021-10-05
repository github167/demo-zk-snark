# https://github.com/Zokrates/ZoKrates
curl -LSfs get.zokrat.es | sh

cat << EOF >root.zok
def main(private field a, field b) -> bool:
  return a * a == b
EOF

# compile
zokrates compile -i root.zok
# perform the setup phase
zokrates setup
# execute the program
zokrates compute-witness -a 337 113569
# generate a proof of computation
zokrates generate-proof
# export a solidity verifier
zokrates export-verifier
# or verify natively
zokrates verify
