// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudyGroupNFT {

    // ERC-721-like NFT Data
    string public name = "StudyGroupAchievement";
    string public symbol = "SGA";
    uint256 public nextTokenId; // Keeps track of the next token ID to mint
    address public owner; // Owner of the contract
    uint256 public attendanceThreshold = 5; // Attendance threshold to mint an NFT
    
    // Mappings to track student attendance and token ownership
    mapping(address => uint256) public studentSessions; // Sessions attended by each student
    mapping(uint256 => address) private tokenOwners; // Mapping of tokenId to the owner (student)
    mapping(address => uint256[]) private ownedTokens; // Mapping from owner address to list of tokenIds

    // ERC-20-like token to reward attendance (can be expanded to full ERC-20 functionality)
    mapping(address => uint256) public rewardTokens;

    // Modifier to restrict access to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Minting an NFT for the student
    function mintNFT(address to) public onlyOwner {
        uint256 tokenId = nextTokenId;
        tokenOwners[tokenId] = to; // Assign the token to the student
        ownedTokens[to].push(tokenId); // Add token to the student's list
        nextTokenId++; // Increment the nextTokenId for future minting
    }

    // Awarding an NFT based on the student's attendance
    function awardNFT(address student) public onlyOwner {
        studentSessions[student]++;
        if (studentSessions[student] >= attendanceThreshold) {
            mintNFT(student); // Mint an NFT if attendance threshold is met
        }
    }

    // Mark attendance for a student (used to simulate attendance marking)
    function markAttendance(address student) public onlyOwner {
        studentSessions[student]++;
        if (studentSessions[student] >= attendanceThreshold) {
            awardNFT(student); // Award an NFT when the student reaches the attendance threshold
        }
    }

    // Get the owner of a specific token by tokenId
    function ownerOf(uint256 tokenId) public view returns (address) {
        return tokenOwners[tokenId];
    }

    // Get the list of tokenIds owned by a specific address
    function tokensOfOwner(address ownerAddr) public view returns (uint256[] memory) {
        return ownedTokens[ownerAddr];
    }

    // Rewarding tokens (optional functionality, can be expanded to full ERC-20 functionality)
    function rewardStudent(address student, uint256 amount) public onlyOwner {
        rewardTokens[student] += amount; // Add reward tokens to student's balance
    }

    // Check how many sessions a student has attended
    function getAttendance(address student) public view returns (uint256) {
        return studentSessions[student];
    }
}
