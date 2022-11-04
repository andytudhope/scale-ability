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
        uint256 midPoint = uint256(toUint8(hash,0))*300/256; // 0 - 299
        uint256 shiftTopY = 300 - midPoint;
        uint256 shiftBottomY = 300 + midPoint;

        return
            string.concat(
                '<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300" style="background:#000">',
                definitions(hash),
                room(shiftTopY, shiftBottomY),
                gradientRects(shiftTopY, shiftBottomY),
                stars(shiftTopY, shiftBottomY),
                '</svg>'
            );
    }

    function definitions(bytes memory hash) public pure returns (string memory) {
        return string.concat(gradients(), filters(hash));
    }

    function gradients() public pure returns (string memory) {
        return string.concat(
                svg.linearGradient(
                    string.concat(svg.prop('id', 'topGradient'),svg.prop('gradientTransform', 'rotate(90)')),
                    string.concat(svg.gradientStop(80, 'white',svg.prop('stop-opacity', '0')),svg.gradientStop(100, 'white', svg.prop('stop-opacity', '1')))
                )
        );
    }

    function filters(bytes memory hash) public pure returns (string memory) {
        string memory roomBF = generateBaseFrequency(hash, 3, 4, ['0.0', '0.00', '0.000']);
        string memory starsBF = generateBaseFrequency(hash, 5, 6, ['0.', '0.0', '0.00']);
        string memory starsOctaves = utils.uint2str(1 + uint256(toUint8(hash,7))*4/256); // 1 - 4

        string memory roomSeed = utils.uint2str(uint256(toUint8(hash,8))*uint256(toUint8(hash,9))*uint256(toUint8(hash,10))); // 0 - 16581375
        string memory starSeed = utils.uint2str(uint256(toUint8(hash,11))*uint256(toUint8(hash,12))*uint256(toUint8(hash,13))); // 0 - 16581375

        // The feColorMatrix is the critical part here, and the heart of Simon's artwork. The OG contract generates a rich array for the color 
        // matrix, ultimately specified by what Simon calls a minimalism factor. This is an artistic construct which leads to particular kinds of rarity, 
        // and a particular kind of general aesthetic for the whole collection (as well as a limit to the number of paintings) which is worth studying.
        // However, trying to put this all in one contract means that it is too big for a single transaction, so I leave here a series of cool color
        // matrices you can experiment with yourself by changing them manually, re-compiling the contract and seeing the effect.
        // 12 15 31 19 1 -36 -33 6 14 1 -53 19 -39 -35 1 -43 16 17 64 1
        // -48 -39 -40 -45 1 21 -42 -44 7 1 5 -57 -36 -44 1 -61 8 30 64 1 
        // 30 12 25 -54 1 24 14 -47 -35 1 -38 -49 -38 31 1 7 -33 -32 64 1
        // roomBF: 0.0973 starsBF: 0.192
        // roomBF: 0.0848 starsBF: 0.379
        // roomBF: 0.000586 starsBF: 0.00735
        // roomSeed: 193280 starSeed: 0
        // roomSeed: 1285200 starSeed: 3852926
        // roomSeed: 28224 starSeed: 5420360
        return string.concat(
            svg.filter(
                svg.prop('id','room'),
                string.concat(
                    svg.el('feTurbulence', string.concat(svg.prop('baseFrequency', roomBF),svg.prop('seed', roomSeed), svg.prop('result', 'turb'))),
                    svg.el('feColorMatrix', svg.prop('values', '10 23 31 -62 1 12 18 2 -32 1 2 31 29 8 1 -35 23 25 64 1'))
                )
            ),
            svg.filter(
                svg.prop('id', 'stars'),
                string.concat(
                    svg.el('feTurbulence', string.concat(svg.prop('type', 'fractalNoise'), svg.prop('numOctaves', starsOctaves), svg.prop('baseFrequency', starsBF), svg.prop('seed', starSeed), svg.prop('result', 'turb'))),
                    svg.el('feColorMatrix', svg.prop('values', '15 0 0 0 0 0 15 0 0 0 0 0 15 0 0 0 0 0 -15 5'))
                )
            )
        );
    }

    function generateBaseFrequency(bytes memory hash, uint256 index1, uint index2, string[3] memory decimalStrings) public pure returns (string memory) {
        string memory strNr = utils.uint2str(1 + uint256(toUint8(hash,index1))*1000/256); // 1 - 997 (ish)
        uint256 dec = uint256(toUint8(hash, index2))*3/256; // 0 - 2
        string memory bf = string.concat(decimalStrings[dec], strNr);
        return bf;
    }

    function room(uint256 shiftTopY, uint256 shiftBottomY) public pure returns (string memory) {
        string memory rectProps = string.concat(
            svg.prop('width', '300'),
            svg.prop('height', '300'),
            svg.prop('filter', 'url(#room)')
        );
        string memory topTranslate = string.concat('translate(0,-',utils.uint2str(shiftTopY+30),')'); // move it up to horizon
        string memory bottomTranslate = string.concat('translate(0,', utils.uint2str(shiftBottomY+30),') scale(-1,1) rotate(180)'); // move it down to floor of horizon, flip and rotate to mirror

        return string.concat(
            svg.rect(
                string.concat(
                    rectProps,
                    svg.prop('transform', topTranslate) 
                )
            ),
            svg.rect(
                string.concat(
                    rectProps,
                    svg.prop('transform', bottomTranslate)
                )
            )
        );
    }

    function stars(uint256 shiftTopY, uint256 shiftBottomY) public pure returns (string memory) {
        string memory rectProps = string.concat(
            svg.prop('width', '300'),
            svg.prop('height', '300'),
            svg.prop('filter', 'url(#stars)')
        );
        string memory topTranslate = string.concat('translate(0,-',utils.uint2str(shiftTopY+30),')');
        string memory bottomTranslate = string.concat('translate(0,', utils.uint2str(shiftBottomY+30),') scale(-1,1) rotate(180)');
        return string.concat(
                svg.rect(
                    string.concat(
                        rectProps, 
                        svg.prop('transform', topTranslate)
                    )
                ),
                svg.rect(
                    string.concat(
                        rectProps, 
                        svg.prop('transform', bottomTranslate)
                    )
                )
        );
    }

    function gradientRects(uint256 shiftTopY, uint256 shiftBottomY) public pure returns (string memory) {
        return string.concat(
                svg.rect(string.concat(svg.prop('width', '300'), svg.prop('height', '300'), svg.prop('fill', 'url(#topGradient)'), svg.prop('transform', string.concat('translate(0,-',utils.uint2str(shiftTopY),')')))),
                svg.rect(string.concat(svg.prop('width', '300'), svg.prop('height', '300'), svg.prop('fill', 'url(#topGradient)'), svg.prop('transform', string.concat('translate(0,', utils.uint2str(shiftBottomY),') scale(-1,1) rotate(180)'))))
        );
    }

    function toUint8(bytes memory _bytes, uint256 _start) internal pure returns (uint8) {
        require(_start + 1 >= _start, "toUint8_overflow");
        require(_bytes.length >= _start + 1 , "toUint8_outOfBounds");
        uint8 tempUint; 

        assembly {
            tempUint := mload(add(add(_bytes, 0x1), _start))
        }
        return tempUint;
    }

    function debug() external returns (string memory) {
        mint();
        return render(0);
    }
}
