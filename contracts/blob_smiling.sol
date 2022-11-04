// Copyright (c) Kernel
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import 'https://raw.githubusercontent.com/w1nt3r-eth/hot-chain-svg/main/contracts/SVG.sol';
import 'https://raw.githubusercontent.com/w1nt3r-eth/hot-chain-svg/main/contracts/Utils.sol';
import 'https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.7.2/contracts/utils/Base64.sol';
import 'https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.7.2/contracts/token/ERC721/extensions/ERC721Enumerable.sol';

contract Blobby is ERC721Enumerable {
    string constant nftName = 'Bee the Blob';
    string constant nftSymbol = 'BOB';

    constructor() ERC721(nftName, nftSymbol) payable {}

    function mint() public payable {
     require(msg.value >= (0.042 ether), 'Ether value sent is not correct');
     uint256 tokenId = totalSupply();
     _safeMint(msg.sender, tokenId);
    }

    function tokenURI(uint256 tokenId) override public pure returns (string memory) {
      string memory svgImage = render(tokenId);
      string memory metadata = string.concat('{"name":"', nftName, ' #', Strings.toString(tokenId), '","attributes":[],"image":"data:svg+xml;base64,', Base64.encode(bytes(svgImage)), '"}');

      return string.concat('data:application/json;base64,', Base64.encode(bytes(metadata)));
    }

    function render(uint256 _tokenId) public pure returns (string memory) {
        string memory blobColour = _calcColour(_tokenId);
        return
            string.concat(
                '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400">',
                    svg.el(
                        'ellipse',
                        string.concat(
                            svg.prop('id','svg_1'),
                            svg.prop('ry','29.5'),
                            svg.prop('rx','29.5'),
                            svg.prop('cy','154.5'),
                            svg.prop('cx','181.5'),
                            svg.prop('stroke','#000'),
                            svg.prop('fill','#fff'),
                            svg.prop('stroke-width','3')
                        )
                    ),
                    svg.el(
                        'ellipse',
                        string.concat(
                            svg.prop('id','svg_3'),
                            svg.prop('ry','3.5'),
                            svg.prop('rx','2.5'),
                            svg.prop('cy','154.5'),
                            svg.prop('cx','173.5'),
                            svg.prop('stroke','#000'),
                            svg.prop('fill','#000'),
                            svg.prop('stroke-width','3')
                        )
                        
                    ),
                    svg.el(
                        'ellipse',
                        string.concat(
                            svg.prop('id','svg_5'),
                            svg.prop('ry','51.80065'),
                            svg.prop('rx','80'),
                            svg.prop('cy','211.80065'),
                            svg.prop('cx','204.5'),
                            svg.prop('stroke','#000'),
                            svg.prop('fill',blobColour),
                            svg.prop('stroke-width','3')
                        )
                    ),
                    svg.el(
                        'ellipse',
                        string.concat(
                            svg.prop('id','svg_2'),
                            svg.prop('ry','29.5'),
                            svg.prop('rx','29.5'),
                            svg.prop('cy','168.5'),
                            svg.prop('cx','209.5'),
                            svg.prop('stroke','#000'),
                            svg.prop('fill','#fff'),
                            svg.prop('stroke-width','3')
                        )
                    ),
                    svg.el(
                        'ellipse',
                        string.concat(
                            svg.prop('id','svg_4'),
                            svg.prop('ry','3.5'),
                            svg.prop('rx','3'),
                            svg.prop('cy','169.5'),
                            svg.prop('cx','208'),
                            svg.prop('stroke','#000'),
                            svg.prop('fill','#000'),
                            svg.prop('stroke-width','3')
                        )
                        
                    ),
                    svg.path(
                        svg.prop('d','M 138 240 Q 165 250 200 235'),
                        string.concat(
                            svg.prop('stroke','#000'),
                            svg.prop('fill','transparent'),
                            svg.prop('stroke-width','3')
                        )
                    ),
                '</svg>'
            );
    }

    function _calcColour(uint256 _tokenId) internal pure returns(string memory) {
        uint256 temp = 6176 - _tokenId;
        string memory tempStr = Strings.toString(temp);
        return string(abi.encodePacked('#',tempStr,'DC'));
    }

    function debug() external pure returns (string memory) {
        return render(10);
    }
}
