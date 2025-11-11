// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

/**
 1.Voting 的合约
    
 */
contract Voting {
    address public owner;

    // 候选人得票数
    mapping(string => uint256) public candidateVotes;

    string[] public candidates;

    mapping(address => bool) public hasVotes;

    event VotesReset(address indexed resetBy);

    constructor() {
        owner = msg.sender;
    }

    function addCandidate(string memory name) public {
        require(bytes(name).length > 0, "name cannot be empty");
        require(candidateVotes[name] >= 0, "name had same");
        candidateVotes[name] = 0;
        // Vote vote = Vote({name: name, vote: false});
        // candidates.push(vote);
        candidates.push(name);
    }
    function vote(string memory candidate) public {
        // 检查是否投票
        require(!hasVotes[msg.sender], "You have already vote");
        // 查找候选人
        require(candidateVotes[candidate] >= 0, "Candidate cannot  find");

        hasVotes[msg.sender] = true;
        candidateVotes[candidate] += 1;
        // return string.concat(candidates,String(candidateVotes[candidates]));
    }
    function getVotes(string memory candidate) public view returns (uint256) {
        return candidateVotes[candidate];
    }

    function restVotes() public {
        // 只有合约所有者可以重置
        require(owner == msg.sender, "Only owner can reset votes");

        for (uint i = 0; i < candidates.length; i++) {
            candidateVotes[candidates[i]] = 0;
        }
        emit VotesReset(msg.sender);
    }
}

contract Test {
    uint256[] public numberValues;
    string[] public romanValues;
    mapping(bytes1 => uint256) public romanMapping;

    constructor() {
        numberValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
        romanValues = [
            "M",
            "CM",
            "D",
            "CD",
            "C",
            "XC",
            "L",
            "XL",
            "X",
            "IX",
            "V",
            "IV",
            "I"
        ];
        romanMapping["I"] = 1;
        romanMapping["V"] = 5;
        romanMapping["X"] = 10;
        romanMapping["L"] = 50;
        romanMapping["C"] = 100;
        romanMapping["D"] = 500;
        romanMapping["M"] = 1000;
    }
    // 2.反转字符串
    function reverseString(
        string memory str
    ) public pure returns (string memory) {
        // 需要将输入的字符串转换成 bytes 类型操作
        bytes memory strBytes = bytes(str);
        uint256 len = strBytes.length;
        bytes memory reversed = new bytes(len);

        for (uint256 i = 0; i < len; i++) {
            reversed[i] = strBytes[len - i - 1];
        }
        return string(reversed);
    }

    // 3.实现整数转罗马数字
    function romanToInt(uint256 num) public view returns (string memory) {
        require(num >= 1 && num <= 3999, "Number must be between 1 and 3999");

        string memory result;
        uint256 temp = num;

        for (uint256 i = 0; i < numberValues.length; i++) {
            while (temp >= numberValues[i]) {
                result = string(abi.encodePacked(result, romanValues[i]));
                temp -= numberValues[i];
            }
        }
        return result;
    }

    // 4.罗马数字转整数
    function intToRoman(string memory str) public view returns (uint256) {
        bytes memory strBytes = bytes(str);
        uint256 len = strBytes.length;
        // 减成负数会导致交易回滚
        uint256 _result = 1000;
        for (uint256 i = 0; i < len; i++) {
            uint256 currentValue = romanMapping[strBytes[i]];

            // 如果还有向下一个字符且当前值小于下一个值,则减去当前值
            if (i + 1 < len) {
                uint256 nextValue = romanMapping[strBytes[i + 1]];
                if (currentValue < nextValue) {
                    _result -= currentValue;
                } else {
                    _result += currentValue;
                }
            } else {
                _result += currentValue;
            }
        }
        return _result - 1000;
    }

    // 5.合并连个有序数组
    function merge(
        uint[] memory arr1,
        uint[] memory arr2
    ) public pure returns (uint[] memory) {
        uint len1 = arr1.length;
        uint len2 = arr2.length;
        uint len = len1 + len2;
        uint[] memory newArray = new uint[](len);
        uint p1 = 0;
        uint p2 = 0;
        while (p1 < len1 || p2 < len2) {
            uint val;
            if (p1 == len1) {
                val = arr2[p2++];
            } else if (p2 == len2) {
                val = arr1[p1++];
            } else if (arr1[p1] < arr2[p2]) {
                val = arr1[p1++];
            } else {
                val = arr2[p2++];
            }
            newArray[p1 + p2 - 1] = val;
        }
        return newArray;
    }

    //  6.二分查找
    function binarySearch(
        int[] memory arr1,
        int target
    ) public pure returns (int) {
        uint len = arr1.length;
        if (len == 0) {
            return -1;
        }
        uint left = 0;
        uint right = len - 1;
        while (left <= right) {
            uint mid = left + (right - left) / 2;
            if (arr1[mid] == target) {
                return int(mid);
            } else if (arr1[mid] < target) {
                left = mid + 1;
            } else {
                if(mid == 0) break;
                right = mid - 1;
            }
        }
        return -1;
    }


}
