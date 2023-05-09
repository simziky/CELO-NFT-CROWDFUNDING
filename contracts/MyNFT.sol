// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    struct Campaign {
        uint256 goal;
        uint256 totalFunding;
        address payable creator;
        uint256 deadline;
        mapping(address => uint256) donations;
        bool goalReached;
        bool fundsWithdrawn;
    }

    mapping(uint256 => Campaign) private _campaigns;

    event CampaignCreated(
        uint256 indexed tokenId,
        uint256 goal,
        uint256 deadline
    );
    event DonationReceived(
        uint256 indexed tokenId,
        address indexed donor,
        uint256 amount
    );
    event Withdrawal(
        uint256 indexed tokenId,
        address indexed creator,
        uint256 amount
    );
    event Refund(
        uint256 indexed tokenId,
        address indexed donor,
        uint256 amount
    );

    constructor() ERC721("CeloNFTCrowdfunding", "CNFT") {}

    /**
     * @dev Creates a new campaign for an NFT with the given goal and URI.
     * @param goal The funding goal for the campaign.
     * @param uri The URI of the NFT metadata.
     * @param deadline The deadline for the campaign.
     * @return The ID of the new token created for the NFT.
     */
    function createCampaign(
        uint256 goal,
        string calldata uri,
        uint256 deadline
    ) public returns (uint256) {
        require(goal > 0, "Goal should be greater than 0");
        require(deadline > block.timestamp, "Deadline should be in the future");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);

        Campaign storage campaign = _campaigns[tokenId];
        campaign.goal = goal;
        campaign.creator = payable(msg.sender);
        campaign.deadline = deadline;

        emit CampaignCreated(tokenId, goal, deadline);

        return tokenId;
    }

    /**
     * @dev Allows a user to donate to an existing campaign for an NFT.
     * @param tokenId The ID of the token representing the NFT.
     */
    function donate(uint256 tokenId) public payable {
        Campaign storage campaign = _campaigns[tokenId];

        require(
            campaign.deadline >= block.timestamp,
            "Campaign deadline has passed"
        );
        require(msg.value > 0, "Donation should be greater than 0");

        address tokenOwner = ownerOf(tokenId);
        require(tokenOwner != address(0), "Token has been burned");
        require(tokenOwner == msg.sender, "Only the token owner can donate");

        campaign.donations[msg.sender] += msg.value;
        campaign.totalFunding += msg.value;

        emit DonationReceived(tokenId, msg.sender, msg.value);
    }

    /**
     * @dev Allows the creator of a campaign to withdraw the funds raised for the NFT.
     * @param tokenId The ID of the token representing the NFT.
     */
    function withdraw(uint256 tokenId) public {
        Campaign storage campaign = _campaigns[tokenId];
        require(
            campaign.creator == msg.sender,
            "Only the campaign creator can withdraw"
        );
        require(
            campaign.deadline <= block.timestamp,
            "Campaign deadline has not passed"
        );
        require(!campaign.fundsWithdrawn, "Funds have already been withdrawn");

        uint256 amount = campaign.totalFunding;
        campaign.totalFunding = 0;
        campaign.fundsWithdrawn = true;

        campaign.creator.transfer(amount);

        emit Withdrawal(tokenId, msg.sender, amount);
    }

    /**
     * @dev Allows donors to get a refund if the campaign goal is not met.
     * @param tokenId The ID of the token representing the NFT.
     */
    function refund(uint256 tokenId) public {
        Campaign storage campaign = _campaigns[tokenId];
        require(
            campaign.deadline <= block.timestamp,
            "Campaign deadline has not passed"
        );
        require(!campaign.goalReached, "Campaign goal has been reached");

        uint256 amount = campaign.donations[msg.sender];
        require(amount > 0, "No donation to refund");

        campaign.donations[msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit Refund(tokenId, msg.sender, amount);
    }

    /**
     * @dev Returns whether the campaign goal has been reached.
     * @param tokenId The ID of the token representing the NFT.
     * @return True if the campaign goal has been reached, false otherwise.
     */
    function isGoalReached(uint256 tokenId) public view returns (bool) {
        Campaign storage campaign = _campaigns[tokenId];
        return campaign.totalFunding >= campaign.goal;
    }

    /**
     * @dev Returns whether the campaign deadline has passed.
     * @param tokenId The ID of the token representing the NFT.
     * @return True if the campaign deadline has passed, false otherwise.
     */
    function hasDeadlinePassed(uint256 tokenId) public view returns (bool) {
        Campaign storage campaign = _campaigns[tokenId];
        return campaign.deadline <= block.timestamp;
    }

    /**
     * @dev Returns the Campaign struct for the given token ID.
     * @param tokenId The ID of the token representing the NFT.
     * @return The Campaign struct for the given token ID.
     */
    function getCampaign(uint256 tokenId)
        public
        view
        returns (
            uint256,
            uint256,
            address,
            uint256,
            bool,
            bool
        )
    {
        Campaign storage campaign = _campaigns[tokenId];
        return (
            campaign.goal,
            campaign.totalFunding,
            campaign.creator,
            campaign.deadline,
            campaign.goalReached,
            campaign.fundsWithdrawn
        );
    }

    // Overrides

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
