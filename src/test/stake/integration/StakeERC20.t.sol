//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {StakeBase} from "./StakeBase.t.sol";

contract StakeTest is StakeBase {
    function testGivenUserWithBalanceWhenStakeThenStakes() public {
        vm.startPrank(testUsers.alice);
        uint256 stakeAmount = token.balanceOf(testUsers.alice) / 10;
        token.approve(address(sut), stakeAmount);

        sut.stake(stakeAmount);

        (uint256 amount, ) = sut.stakes(testUsers.alice);
        assertEq(amount, stakeAmount, "Stake amount incorrect");
    }

    function testGivenLockPeriodNotPassedWhenUstakeThenReverts() public {
        vm.startPrank(testUsers.alice);
        uint256 stakeAmount = token.balanceOf(testUsers.alice) / 10;
        token.approve(address(sut), stakeAmount);
        sut.stake(stakeAmount);

        bytes4 errorSelector = bytes4(keccak256("TokensLocked()"));
        vm.expectRevert(abi.encodeWithSelector(errorSelector));

        sut.unstake();
    }

    function testGivenUserWithStakeWhenStakeThenReverts() public {
        vm.startPrank(testUsers.alice);
        uint256 stakeAmount = token.balanceOf(testUsers.alice) / 10;
        token.approve(address(sut), stakeAmount);
        sut.stake(stakeAmount);

        bytes4 errorSelector = bytes4(keccak256("AddressHasStake(address)"));
        vm.expectRevert(abi.encodeWithSelector(errorSelector, testUsers.alice));

        sut.stake(stakeAmount);
    }
}
