// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StreakChain {
    struct CheckIn {
        string habit;
        uint256 timestamp;
    }

    mapping(address => CheckIn[]) public checkIns;

    event CheckedIn(address indexed user, string habit, uint256 timestamp);

    function logCheckIn(string calldata habit) external {
        checkIns[msg.sender].push(CheckIn(habit, block.timestamp));
        emit CheckedIn(msg.sender, habit, block.timestamp);
    }

    function getCheckIns(address user) external view returns (CheckIn[] memory) {
        return checkIns[user];
    }

    function getCheckInCount(address user) external view returns (uint256) {
        return checkIns[user].length;
    }

    function getCurrentStreak(address user) external view returns (uint256) {
        CheckIn[] storage history = checkIns[user];
        if (history.length == 0) return 0;

        uint256 streak = 1;
        uint256 oneDay = 1 days;

        for (uint256 i = history.length - 1; i > 0; i--) {
            uint256 gap = history[i].timestamp - history[i - 1].timestamp;
            if (gap <= oneDay * 2) {
                streak++;
            } else {
                break;
            }
        }

        return streak;
    }
}
