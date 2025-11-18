// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

//https://sepolia.etherscan.io/token/0x2De4Bb54e0B0300Cd5e07d0FBa13e6aAa359aD3c
contract MyNft is ERC721Enumerable {
  mapping(uint256 => string)internal tokenURIs;

  constructor(string memory _name, string memory _symbol) ERC721 (_name, _symbol){}

  function mint(string memory _tokenURI)external {
    uint256 tokenId = totalSupply() + 1;
    tokenURIs[tokenId] = _tokenURI;
    _safeMint(msg.sender, tokenId);
  } 

  function tokenURI(uint256 tokenId)public view override returns(string memory){
    _requireOwned(tokenId);
    return tokenURIs[tokenId];
  }
}