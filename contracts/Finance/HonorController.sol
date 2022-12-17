// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "./helpers/Ownable.sol";
import "./helpers/SafeBEP20.sol";
import "./helpers/SafeMath.sol";

interface IMasterChef {
    function getHonorForFinance(uint256 _amount) external;
}

contract HonorController is Ownable {
    using SafeMath for uint256;

    IMasterChef public _masterChef;
    IBEP20 public _honor;

    struct UserControls {
        uint256 limit;
        uint256 totalMint;
        uint256 stopped;
    }

    mapping(address => UserControls) public user_controls;

    constructor(address masterchef,address honor) public {
        _masterChef=IMasterChef(masterchef);
        _honor=IBEP20(honor);
    }

    function addControl(address control,uint256 limit) public onlyOwner {
        UserControls storage user=user_controls[control];
        user.limit=limit;
        user.totalMint=0;
        user.stopped=1;
    }

    function getHonor(uint256 amount) public {
        UserControls storage user=user_controls[msg.sender];
        require(user.limit>=amount && user.stopped>=1,"Not Access");
        
        _masterChef.getHonorForFinance(amount);

        SafeBEP20.safeTransfer(_honor, msg.sender, amount);
        user.totalMint=user.totalMint.add(amount);
        user.limit=user.limit.sub(amount);
    }

    function addLimit(address control,uint256 amount) public onlyOwner {
        UserControls storage user=user_controls[control];
        user.limit=user.limit.add(amount);
    }

    function stopControl(address control) public onlyOwner {
        UserControls storage user=user_controls[control];
        user.stopped=0;
    }
}