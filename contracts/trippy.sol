// Copyright (c) Kernel
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import 'https://raw.githubusercontent.com/w1nt3r-eth/hot-chain-svg/main/contracts/SVG.sol';
import 'https://raw.githubusercontent.com/w1nt3r-eth/hot-chain-svg/main/contracts/Utils.sol';
import 'https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.7.2/contracts/utils/Base64.sol';
import 'https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.7.2/contracts/token/ERC721/extensions/ERC721Enumerable.sol';

contract SeedNFT is ERC721Enumerable {
    string constant nftName = 'Infinity Reimagined';
    string constant nftSymbol = 'TRIPPY';

    constructor() ERC721(nftName, nftSymbol) payable {}

    function mint() public payable {
     require(msg.value >= (0.088 ether), 'Ether value sent is not correct');
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
                '<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300" style="background:#000">',
                svg.linearGradient(
                    string.concat(svg.prop('id', 'topGradient'),svg.prop('gradientTransform', 'rotate(90)')),
                    string.concat(svg.gradientStop(80, 'white',svg.prop('stop-opacity', '0')),svg.gradientStop(100, 'white', svg.prop('stop-opacity', '1')))
                ),
                svg.filter(
                    svg.prop('id','room'),
                    string.concat(
                        svg.el('feTurbulence', string.concat(svg.prop('baseFrequency', '0.0973'),svg.prop('seed', '193280'), svg.prop('result', 'turb'))),
                        svg.el('feColorMatrix', svg.prop('values', '10 23 31 -62 1 12 18 2 -32 1 2 31 29 8 1 -35 23 25 64 1'))
                    )
                ),
                svg.filter(
                    svg.prop('id', 'stars'),
                    string.concat(
                        svg.el('feTurbulence', string.concat(svg.prop('type', 'fractalNoise'), svg.prop('numOctaves', '1'), svg.prop('baseFrequency', '0.192'), svg.prop('seed', '505206'), svg.prop('result', 'turb'))),
                        svg.el('feColorMatrix', svg.prop('values', '15 0 0 0 0 0 15 0 0 0 0 0 15 0 0 0 0 0 -15 5'))
                    )
                ),
                svg.rect(
                    string.concat(
                        svg.prop('width', '300'),
                        svg.prop('height', '300'),
                        svg.prop('filter', 'url(#room)'),
                        svg.prop('transform', 'translate(0,-284)') 
                    )
                ),
                svg.rect(
                    string.concat(
                        svg.prop('width', '300'),
                        svg.prop('height', '300'),
                        svg.prop('filter', 'url(#room)'),
                        svg.prop('transform', 'translate(0,376) scale(-1,1) rotate(180)')
                    )
                ),
                svg.rect(
                    string.concat(
                        svg.prop('width', '300'),
                        svg.prop('height', '300'),
                        svg.prop('fill', 'url(#topGradient)'),
                        svg.prop('transform', 'translate(0,-254)')
                    )
                ),
                svg.rect(
                    string.concat(
                        svg.prop('width', '300'),
                        svg.prop('height', '300'),
                        svg.prop('fill', 'url(#topGradient)'),
                        svg.prop('transform', 'translate(0,346) scale(-1,1) rotate(180)')
                    )
                ),
                svg.rect(
                    string.concat(
                        svg.prop('width', '300'),
                        svg.prop('height', '300'),
                        svg.prop('fill', 'url(#stars)'),
                        svg.prop('transform', 'translate(0,-284)')
                    )
                ),
                svg.rect(
                    string.concat(
                        svg.prop('width', '300'),
                        svg.prop('height', '300'),
                        svg.prop('fill', 'url(#stars)'),
                        svg.prop('transform', 'translate(0,376) scale(-1,1) rotate(180)')
                    )
                ),
                '</svg>'
            );
    }

    function debug() external pure returns (string memory) {
        return render(10);
    }
}


// To match Simon's original work, you would need to include these polygon's too
// However, doing so results in a 'stack too deep' error with solidity compiler v0.8.16
// svg.el(
//     'polygon',
//     string.concat(
//         svg.prop('points', '41,0 0,0 0,41 110,46'),
//         svg.prop('fill', 'none'),
//         svg.prop('stroke', 'white')
//     )
// ),
// svg.el(
//     'polygon',
//     string.concat(
//         svg.prop('points', '0,259 0,300 41,300 110,46'),
//         svg.prop('fill', 'none'),
//         svg.prop('stroke', 'white')
//     )
// ),
// svg.el(
//     'polygon',
//     string.concat(
//         svg.prop('points', '259,0 300,0 300,41 110,46'),
//         svg.prop('fill', 'none'),
//         svg.prop('stroke', 'white')
//     )
// ),
// svg.el(
//     'polygon',
//     string.concat(
//         svg.prop('points', '300,259 300,300 259,300 110,46'),
//         svg.prop('fill', 'none'),
//         svg.prop('stroke', 'white')
//     )
// ),