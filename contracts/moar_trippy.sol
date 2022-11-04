// Copyright (c) Kernel
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import 'https://raw.githubusercontent.com/w1nt3r-eth/hot-chain-svg/main/contracts/SVG.sol';
import 'https://raw.githubusercontent.com/w1nt3r-eth/hot-chain-svg/main/contracts/Utils.sol';
import 'https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.7.2/contracts/utils/Base64.sol';
import 'https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.7.2/contracts/token/ERC721/extensions/ERC721Enumerable.sol';

contract SeedNFT is ERC721Enumerable {
    string constant nftName = 'Infinity Re-reimagined';
    string constant nftSymbol = 'X-TRIPPY';
    mapping (uint256 => bytes) public hashes;

    constructor() ERC721(nftName, nftSymbol) payable {}

    function mint() public payable {
     require(msg.value >= (0.014 ether), 'Ether value sent is not correct');
     uint256 tokenId = totalSupply();
     hashes[tokenId]= bytes(abi.encodePacked(keccak256(abi.encodePacked(tokenId, block.timestamp, msg.sender))));
     _safeMint(msg.sender, tokenId);
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
      string memory svgImage = render(tokenId);
      string memory metadata = string.concat('{"name":"', nftName, ' #', Strings.toString(tokenId), '","attributes":[],"image":"data:svg+xml;base64,', Base64.encode(bytes(svgImage)), '"}');

      return string.concat('data:application/json;base64,', Base64.encode(bytes(metadata)));
    }

    function render(uint256 _tokenId) public view returns (string memory) {
        bytes memory hash = hashes[_tokenId];
        uint256 midPoint = uint256(toUint8(hash,0))*300/256; // this is the line that triggers the ethers error in your console

        return
            string.concat(
                '<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300" style="background:#000">',
                svg.text(
                    string.concat(
                        svg.prop('x', '20'),
                        svg.prop('y', '40'),
                        svg.prop('font-size', '22'),
                        svg.prop('fill', 'white')
                    ),
                    string.concat(
                        svg.cdata('This trips ethers up #'),
                        utils.uint2str(_tokenId)
                    )
                ),
                '</svg>'
            );
    }

    // this is the offending function
    function toUint8(bytes memory _bytes, uint256 _start) internal pure returns (uint8) {
        require(_start + 1 >= _start, "toUint8_overflow");
        require(_bytes.length >= _start + 1 , "toUint8_outOfBounds");
        uint8 tempUint; 

        assembly {
            tempUint := mload(add(add(_bytes, 0x1), _start))
        }
        return tempUint;
    }

    function debug() external view returns (string memory) {
        return render(10);
    }
}
