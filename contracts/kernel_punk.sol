//SPDX-License-Identifier: MIT

// This is largely taken from the CryptoPunksData contract here: https://etherscan.io/address/0x16f5a35647d6f03d5d3da7b35409d65ba03af3b2#code
// All attribtuion to them, all faults my own. 
// This is really just intended as educational material - actually adding all the punks and assets needed to make the contract work is a great
// deal of detail work not relevant to the guild this was built for.

pragma solidity 0.8.17;

import 'https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.7.2/contracts/utils/Base64.sol';
import 'https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.7.2/contracts/token/ERC721/extensions/ERC721Enumerable.sol';

contract KERN_PUNK is ERC721Enumerable {
    string constant nftName = 'Kernel Punks';
    string constant nftSymbol = 'KNUP';

    string internal constant SVG_HEADER = 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" version="1.2" viewBox="0 0 24 24">';
    string internal constant SVG_FOOTER = '</svg>';

    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
    bytes private palette;

    mapping(uint8 => bytes) private assets;
    mapping(uint8 => string) private assetNames;
    mapping(uint64 => uint32) private composites;
    mapping(uint8 => bytes) private punks;

    constructor() ERC721(nftName, nftSymbol) payable {}

    function setPalette(bytes memory _palette) external {
        palette = _palette;
    }

    function addAsset(uint8 index, bytes memory encoding, string memory name) external {
        assets[index] = encoding;
        assetNames[index] = name;
    }

    function addComposites(uint64 key1, uint32 value1, uint64 key2, uint32 value2, uint64 key3, uint32 value3, uint64 key4, uint32 value4) external {
        composites[key1] = value1;
        composites[key2] = value2;
        composites[key3] = value3;
        composites[key4] = value4;
    }

    function addPunks(uint8 index, bytes memory _punks) public {
        punks[index] = _punks;
    }

    function mint() public payable {
     uint256 index = totalSupply();
     _safeMint(msg.sender, index);
    }

    function tokenURI(uint256 index) override public view returns (string memory) {
      string memory svgImage = punkImageSvg(uint16(index));
      string memory metadata = string.concat('{"name":"', nftName, ' #', Strings.toString(index), '","attributes":[],"image":"data:svg+xml;base64,', Base64.encode(bytes(svgImage)), '"}');

      return string.concat('data:application/json;base64,', Base64.encode(bytes(metadata)));
    }

    /**
     * The Cryptopunk image for the given index.
     * The image is represented in a row-major byte array where each set of 4 bytes is a pixel in RGBA format.
     * @param index the punk index, 0 <= index < 10000
     */
    function punkImage(uint16 index) public view returns (bytes memory) {
        require(index >= 0 && index < 10000);
        bytes memory pixels = new bytes(2304);
        for (uint j = 0; j < 8; j++) {
            uint8 asset = uint8(punks[uint8(index / 100)][(index % 100) * 8 + j]);
            if (asset > 0) {
                bytes storage a = assets[asset];
                uint n = a.length / 3;
                for (uint i = 0; i < n; i++) {
                    uint[4] memory v = [
                        uint(uint8(a[i * 3]) & 0xF0) >> 4,
                        uint(uint8(a[i * 3]) & 0xF),
                        uint(uint8(a[i * 3 + 2]) & 0xF0) >> 4,
                        uint(uint8(a[i * 3 + 2]) & 0xF)
                    ];
                    for (uint dx = 0; dx < 2; dx++) {
                        for (uint dy = 0; dy < 2; dy++) {
                            uint p = ((2 * v[1] + dy) * 24 + (2 * v[0] + dx)) * 4;
                            if (v[2] & (1 << (dx * 2 + dy)) != 0) {
                                bytes4 c = composite(a[i * 3 + 1],
                                        pixels[p],
                                        pixels[p + 1],
                                        pixels[p + 2],
                                        pixels[p + 3]
                                    );
                                pixels[p] = c[0];
                                pixels[p+1] = c[1];
                                pixels[p+2] = c[2];
                                pixels[p+3] = c[3];
                            } else if (v[3] & (1 << (dx * 2 + dy)) != 0) {
                                pixels[p] = 0;
                                pixels[p+1] = 0;
                                pixels[p+2] = 0;
                                pixels[p+3] = 0xFF;
                            }
                        }
                    }
                }
            }
        }
        return pixels;
    }

    /**
     * The Cryptopunk image for the given index, in SVG format.
     * In the SVG, each "pixel" is represented as a 1x1 rectangle.
     * @param index the punk index, 0 <= index < 10000
     */
    function punkImageSvg(uint16 index) public view returns (string memory svg) {
        bytes memory pixels = punkImage(index);
        svg = string(abi.encodePacked(SVG_HEADER));
        bytes memory buffer = new bytes(8);
        for (uint y = 0; y < 24; y++) {
            for (uint x = 0; x < 24; x++) {
                uint p = (y * 24 + x) * 4;
                if (uint8(pixels[p + 3]) > 0) {
                    for (uint i = 0; i < 4; i++) {
                        uint8 value = uint8(pixels[p + i]);
                        buffer[i * 2 + 1] = _HEX_SYMBOLS[value & 0xf];
                        value >>= 4;
                        buffer[i * 2] = _HEX_SYMBOLS[value & 0xf];
                    }
                    svg = string(abi.encodePacked(svg,
                        '<rect x="', Strings.toString(x), '" y="', Strings.toString(y),'" width="1" height="1" shape-rendering="crispEdges" fill="#', string(buffer),'"/>'));
                }
            }
        }
        svg = string(abi.encodePacked(svg, SVG_FOOTER));
        return svg;
    }

    function composite(bytes1 index, bytes1 yr, bytes1 yg, bytes1 yb, bytes1 ya) internal view returns (bytes4 rgba) {
        uint x = uint(uint8(index)) * 4;
        uint8 xAlpha = uint8(palette[x + 3]);
        if (xAlpha == 0xFF) {
            rgba = bytes4(uint32(
                    (uint(uint8(palette[x])) << 24) |
                    (uint(uint8(palette[x+1])) << 16) |
                    (uint(uint8(palette[x+2])) << 8) |
                    xAlpha
                ));
        } else {
            uint64 key =
                (uint64(uint8(palette[x])) << 56) |
                (uint64(uint8(palette[x + 1])) << 48) |
                (uint64(uint8(palette[x + 2])) << 40) |
                (uint64(xAlpha) << 32) |
                (uint64(uint8(yr)) << 24) |
                (uint64(uint8(yg)) << 16) |
                (uint64(uint8(yb)) << 8) |
                (uint64(uint8(ya)));
            rgba = bytes4(composites[key]);
        }
    }

    function debug() external returns (string memory) {
        addPunks(0, '021b3500000000000236431300000000021b0f0000000000054d7b6400000000023024140000000003454700000000000236334700000000057d5a4e00000000064d635400000000092600000000000001212400000000000324470000000000068380825f59000003113d1e0000000002171e1d00000000021b3d1647000000033625000000000006556b7800000000033112000000000005837d5d00000000076c5d7c00000000085873746d0000000442350000000000074d7d6972000000074d558200000000076c7d53734e0000064d5a00000000000683817200000000056873000000000002173d3a00000000011a3e0000000000033d4a230000000007685400000000000755825e00000000076c794e0000000002113c2c0000000002223f1500000000064d60740000000006576e0000000000033d261400000000076c7b4e0000000005836f7700000000054d7f590000000008837d7573640000021b3631000000000683817c000000000321170f00000000031a3d162b0000000134351f00000000022f1500000000000217352c00000000021743130000000003222a4300000000010d43132300000001361e1500000000091e00000000000006835d72000000000683577f6a840000066c7d757e0000000780795f66000000066c807d814e0000032a1e292b000000041b0d4115000000043b3d1c2b000000066c7d6b5e000000043d431400000000064d7d606400000007717e00000000000338392300000000033a2b0000000000011e401f000000000683634e000000000318312300000000023b352c0000000006684e0000000000021b3d410000000007815f0000000000043b1e1500000000043d3c2c00000000033d1e1314000000068365736600000005837d5900000000077d627700000000066c55660000000001221b1a46000000033839000000000001454a000000000002173915000000000244410000000000054d4b7300000000044a3e000000000003453d251500000002223b2f00000000011726140000000005657e0000000000084f61000000000003223d321300000009361900000000000683567200000000057b590000000000');
        return punkImageSvg(0);
    }

}