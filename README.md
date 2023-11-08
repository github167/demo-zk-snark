Original: https://github.com/web3-master/zksnark-sudoku

1. update node
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install node

```
2. git clone to desktop
```
git clone -b sudoku-client https://github.com/github167/demo-zk-snark
cd demo-zk-snark

```
3. install
```
npm install
npm run dev

```
2. surf to http://localhost:3000
3. New puzzle->Solve puzzle->Save puzzle
4. Generate proof->Save proof
5. Load puzzle->Load proof->Verify proof
