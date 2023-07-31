// SPDX-License-Identifier: MIT

pragma solidity =0.5.16;

import "./ContractPair.sol";

contract HonorFactory is IHonorFactory {
    address public feeTo;
    address public feeToSetter;
    bytes32 public INIT_CODE_HASH = keccak256(abi.encodePacked(type(HonorPair).creationCode));

    mapping(address=>uint8) public whiteList;
    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function setTokenAccess(address _token,uint8 _access) public {
        require(msg.sender == feeToSetter, 'HonorSwap: FORBIDDEN');
        whiteList[_token]=_access;
    }


    function createPair(address tokenA, address tokenB) external returns (address pair) {
        uint8 t1Access=whiteList[tokenA];
        uint8 t2Access=whiteList[tokenB];
        require(t1Access>0 && t2Access>0,"HonorSwap: No Access");
        if(t1Access==2 || t2Access==2)
        {
            if(msg.sender!=feeToSetter)
            {
                revert("HonorSwap: No Access");
            }
        }
        require(tokenA != tokenB, 'HonorSwap: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'HonorSwap: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'HonorSwap: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(HonorPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IHonorPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'HonorSwap: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'HonorSwap: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }

    function setDevFee(address _pair, uint8 _devFee) external {
        require(msg.sender == feeToSetter, 'HonorSwap: FORBIDDEN');
        require(_devFee > 0, 'HonorSwap: FORBIDDEN_FEE');
        HonorPair(_pair).setDevFee(_devFee);
    }
    
    function setSwapFee(address _pair, uint32 _swapFee) external {
        require(msg.sender == feeToSetter, 'HonorSwap: FORBIDDEN');
        HonorPair(_pair).setSwapFee(_swapFee);
    }

    function setAllDevFee(uint8 _devFee) external {
        require(msg.sender == feeToSetter, 'HonorSwap: FORBIDDEN');
        for(uint i=0;i<allPairs.length;i++)
        {
            HonorPair(allPairs[i]).setDevFee(_devFee);
        }
    }

    function setAllSwapFee(uint8 _swapFee) external {
        require(msg.sender == feeToSetter, 'HonorSwap: FORBIDDEN');
        for(uint i=0;i<allPairs.length;i++)
        {
            HonorPair(allPairs[i]).setSwapFee(_swapFee);
        }
    }
}