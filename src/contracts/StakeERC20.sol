// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract StakeERC20 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    IERC20 public stakingToken;
    uint256 public constant REWARD_RATE = 1e18; // 100%
    uint256 public constant LOCK_PERIOD = 7 days;

    struct Stake {
        uint256 amount;
        uint256 startTime;
    }

    mapping(address => Stake) public stakes;

    error ZeroAmountStaked();
    error TransferFailed();
    error TokensLocked();
    error NotEnoughTimePassed();
    error AddressHasStake(address staker);

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount, uint256 reward);
    event RewardClaimed(address indexed user, uint256 reward);

    function initialize(address _token) public initializer {
        stakingToken = IERC20(_token);

        __Ownable_init(_msgSender());
    }

    function stake(uint256 _amount) external {
        if (_amount == 0) revert ZeroAmountStaked();
        if (hasStake(_msgSender())) revert AddressHasStake(_msgSender());
        if (!stakingToken.transferFrom(_msgSender(), address(this), _amount))
            revert TransferFailed();

        stakes[_msgSender()] = Stake({
            amount: _amount,
            startTime: block.timestamp
        });

        emit Staked(_msgSender(), _amount);
    }

    function claimReward() external {
        Stake storage userStake = stakes[msg.sender];
        uint256 reward = calculateReward(
            userStake.amount,
            block.timestamp - userStake.startTime
        );

        userStake.startTime = block.timestamp;

        if (!stakingToken.transfer(msg.sender, reward)) revert TransferFailed();

        emit RewardClaimed(msg.sender, reward);
    }

    function unstake() external {
        Stake storage userStake = stakes[msg.sender];
        if (block.timestamp < userStake.startTime + LOCK_PERIOD)
            revert TokensLocked();

        uint256 reward = calculateReward(
            userStake.amount,
            block.timestamp - userStake.startTime
        );
        uint256 totalAmount = userStake.amount + reward;

        delete stakes[msg.sender];
        if (!stakingToken.transfer(msg.sender, totalAmount))
            revert TransferFailed();

        emit Unstaked(msg.sender, userStake.amount, reward);
    }

    function calculateReward(
        uint256 _amount,
        uint256 _stakeDuration
    ) private pure returns (uint256) {
        uint256 rewardRatePerSecond = REWARD_RATE / 365 days;
        return (_amount * rewardRatePerSecond * _stakeDuration) / 1e18;
    }

    function hasStake(address addr) public view returns (bool) {
        return stakes[addr].startTime != 0;
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}
}
