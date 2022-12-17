// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IFinanceMaster {
    function widthdrawHNRUSD(uint256 amount) external returns(bool);
    function widthdrawBUSD(uint256 amount) external returns(bool);
    function widthdrawHonor(uint256 amount) external returns(bool);
    function depositHonor(uint256 amount) external ;
    function depositBUSD(uint256 amount) external ;
    function depositHNRUSD(uint256 amount) external ;
}