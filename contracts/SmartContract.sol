//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TheLearnCollection is ERC721, Ownable {

    using Strings for uint256;
    using Counters for Counters.Counter;

    constructor() ERC721("Bored Geckos Tropical Club", "BGTC") {
    }

    string public baseExtension = ".json";
    uint256 public cost = 0.05 ether;
    uint256 public maxSupply = 10000;
    bool public saleIsActive = true;
    Counters.Counter private _tokenIds;

    // Low Res Base URI
    string baseURI;

    function _baseURI() internal view virtual override returns (string memory) {
        return "ipfs://QmaHwDXFF5dfroRNx6NC5cUgCnbd72hRkXm6vLiHr589aC";
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory base = _baseURI();
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString(), ".json"));

    }

    function mintToken() public payable {
        uint supply = _tokenIds.current() + 1;
        require(saleIsActive, "Sale must be active to mint token");
        require(supply <= maxSupply, "Purchase would exceed max supply of tokens");
        require(msg.value >= cost, "Ether value sent is not correct");
        _safeMint(msg.sender, supply);
        _tokenIds.increment();

    }

    function setCost(uint256 _newCost) public onlyOwner() {
        cost = _newCost;
    }


    function toString(uint256 value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}