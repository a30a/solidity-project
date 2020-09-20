## Quick start

Install dependencies:
```
npm install
```

build contract:
```
truffle compile
```

deploy contract:
```
truffle migrate
```

## 컨트랙트 간단한 설명

* AToken: EUST에 대응하는 토큰
* BToken: ELUNA에 대응하는 토큰
* DAIOracle: AToken-DAI와 BToken-DAI 페어의 TWAP을 저장하는 컨트랙트 (Note: AToken-DAI가 거꾸로 저장되어 있음)
* SWAP: DAIOracle이 제공하는 값을 바탕으로 AToken<->BToken을 교환하는 컨트랙트 (Note: Swap 기능 정상 동작하지 않음)

deployed contracs:
  * [AToken](https://ropsten.etherscan.io/address/0xD40377f45cfDa5FA6d3C2BF3aA4DD92a6033e301): `0xD40377f45cfDa5FA6d3C2BF3aA4DD92a6033e301`
  * [BToken](https://ropsten.etherscan.io/address/0x0c3cc276478e3298941fd8b59f9753930f39c273): `0x0c3cc276478e3298941Fd8b59f9753930f39C273`
  * [oracle](https://ropsten.etherscan.io/address/0xD9950c3ad1b243A91f2EA7948d41aE5625025fC5): `0xD9950c3ad1b243A91f2EA7948d41aE5625025fC5`
  * [swap](https://ropsten.etherscan.io/address/0x0C595075b69cA988A0329f39380635dD6a77F1ee): `0x0C595075b69cA988A0329f39380635dD6a77F1ee`



## 유사 Frontend

Auto generated functions that read and write to smart contract

* oracle: https://oneclickdapp.com/quality-index/