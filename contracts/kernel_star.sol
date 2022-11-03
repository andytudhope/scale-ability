// Copyright (c) Kernel
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import 'https://raw.githubusercontent.com/w1nt3r-eth/hot-chain-svg/main/contracts/SVG.sol';
import 'https://raw.githubusercontent.com/w1nt3r-eth/hot-chain-svg/main/contracts/Utils.sol';
import 'https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.7.2/contracts/utils/Base64.sol';
import 'https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.7.2/contracts/token/ERC721/extensions/ERC721Enumerable.sol';

contract SeedNFT is ERC721Enumerable {
    string constant nftName = 'Kernel Stars';
    string constant nftSymbol = 'ASTRA';

    constructor() ERC721(nftName, nftSymbol) payable {}

    function mint() public payable {
     require(msg.value >= (0.014 ether), 'Ether value sent is not correct');
     uint256 tokenId = totalSupply();
     _safeMint(msg.sender, tokenId);
    }

    function tokenURI(uint256 tokenId) override public pure returns (string memory) {
      string memory svgImage = render(tokenId);
      string memory metadata = string.concat('{"name":"', nftName, ' #', Strings.toString(tokenId), '","attributes":[],"image":"data:svg+xml;base64,', Base64.encode(bytes(svgImage)), '"}');

      return string.concat('data:application/json;base64,', Base64.encode(bytes(metadata)));
    }

    function render(uint256 _tokenId) public pure returns (string memory) {
        return
            string.concat(
                '<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300">',
                svg.image(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7CNBtpov50DsrOBeXg2WzjzLnYQBPb8Ss9uqlV9Ikg6gzNH4_kYbeTlk1jM7xmIBFmwQ&usqp=CAU',svg.prop('height','300')
                ),
                svg.text(
                    string.concat(
                        svg.prop('x', '20'),
                        svg.prop('y', '40'),
                        svg.prop('font-size', '22'),
                        svg.prop('fill', 'white')
                    ),
                    string.concat(
                        svg.cdata('Kernel Star #'),
                        utils.uint2str(_tokenId)
                    )
                ),
                svg.rect(
                    string.concat(
                        svg.prop('fill', '#FFBA44'),
                        svg.prop('x', '20'),
                        svg.prop('y', '50'),
                        svg.prop('width', utils.uint2str(160)),
                        svg.prop('height', utils.uint2str(10))
                    ),
                    utils.NULL
                ),
                svg.el(
                    'polygon',
                    string.concat(
                        svg.prop('points', '100,10 40,180 190,60 10,60 160,180'),
                        svg.prop('fill', '#FFBA44'),
                        svg.prop('transform', 'translate(45,80)')
                    )
                ),
                '</svg>'
            );
    }

    function debug() external pure returns (string memory) {
        return render(10);
    }
}
