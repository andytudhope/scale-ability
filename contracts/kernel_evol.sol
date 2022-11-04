// Copyright (c) Kernel
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import 'https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/utils/Strings.sol';

// Bring on the OnChain Monkeys!
contract OnChainMonkey {
  using Strings for uint256;

  uint256 public constant maxSupply = 10000;
  uint256 public numClaimed = 0;
  string[] private background = ["656","dda","e92","1eb","663","9de","367","ccc"]; // only trait that is uniform, no need for rarity weights
  string[] private fur1 = ["653","532","444","a71","ffc","ca9","f89","777","049","901","fc5","ffe","574","bcc","d04","222","889","7f9","fd1"];
  string[] private fur2 = ["532","653","653","653","653","653","653","653","653","653","110","653","711","344","799","555","8a8","32f","653"];
  uint8[] private fur_w =[249, 246, 223, 141, 116, 114, 93, 90, 89, 86, 74, 72, 55, 48, 39, 32, 28, 14, 8];
  string[] private eyes = ["abe","0a0","653","888","be7","abe","0a0","653","888","be7","cef","abe","0a0","653","888","be7","cef","abe","0a0","653","888","be7","cef"];
  uint8[] private eyes_w = [245, 121, 107, 101, 79, 78, 70, 68, 62, 58, 56, 51, 50, 48, 44, 38, 35, 33, 31, 22, 15, 10, 7];
  string[] private mouth = ["653","ffc","f89","777","049","901","bcc","d04","fd1","ffc","653","f89","777","049","bcc","901","901","bcc","653","d04","ffc","f89","777","049","fd1","f89","777","bcc","d04","049","ffc","901","fd1"];
  uint8[] private mouth_w = [252, 172, 80, 79, 56, 49, 37, 33, 31, 30, 28, 27, 26, 23, 22, 18, 15, 14, 13, 12, 11, 10, 10, 10, 9, 8, 7, 7, 6, 5, 5, 4, 3];
  string[] private earring = ["999","fe7","999","999","fe7","bdd"];
  uint8[] private earring_w = [251, 32, 29, 17, 16, 8, 5];
  string[] private clothes1 = ["f00","f00","222","f00","f00","f00","f00","f00","f00","00f","00f","00f","00f","00f","00f","00f","222","00f","f0f","222","f0f","f0f","f0f","f0f","f0f","f0f","f0f","f80","f80","f80","f80","f80","f00","f80","f80","f80","90f","90f","00f","90f","90f","90f","222"];
  string[] private clothes2 = ["d00","00f","f00","f0f","f80","90f","f48","0f0","ff0","f00","00d","f0f","f80","90f","f48","0f0","ddd","ff0","f00","653","00f","d0d","f80","90f","f48","0f0","ff0","f00","f0f","00f","d60","f48","ddd","90f","0f0","ff0","f00","00f","fd1","f0f","f80","70d","fd1"];
  uint8[] private clothes_w = [251, 55, 45, 43, 38, 37, 34, 33, 32, 31, 31, 31, 31, 31, 30, 30, 29, 29, 28, 27, 27, 27, 26, 25, 24, 22, 21, 20, 19, 19, 19, 19, 19, 19, 18, 17, 16, 15, 14, 13, 11, 9, 8, 6];
  string[] private hat1 = ["f00","f00","f00","f00","f00","f00","f00","00f","00f","00f","00f","00f","00f","00f","f00","f0f","f0f","f0f","f0f","f0f","f0f","f0f","f80","f80","f80","f80","f80","f80","f00","f80","90f","f48","22d","90f","90f","ff0",""];
  string[] private hat2 = ["0f0","00f","f80","ff0","90f","f0f","f48","f00","0f0","00f","f80","ff0","90f","f0f","000","f00","0f0","00f","f80","ff0","90f","f0f","f00","0f0","00f","f80","ff0","90f","f00","f0f","f00","000","000","0f0","00f","f48",""];  
  uint8[] private hat_w = [251, 64, 47, 42, 39, 38, 36, 35, 34, 34, 33, 29, 28, 26, 26, 25, 25, 25, 22, 21, 20, 20, 18, 17, 17, 15, 14, 14, 13, 13, 12, 12, 12, 10, 9, 8, 7];
  string[] private z = ['<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 500 500"><rect x="0" y="0" width="500" height="500" style="fill:#',
    '"/><rect width="300" height="120" x="99" y="400" style="fill:#', '"/><circle cx="190" cy="470" r="5" style="fill:#', '"/><circle cx="310" cy="470" r="5" style="fill:#',
    '"/><circle cx="100" cy="250" r="50" style="fill:#', '"/><circle cx="100" cy="250" r="20" style="fill:#', '"/><circle cx="400" cy="250" r="50" style="fill:#',
    '"/><circle cx="400" cy="250" r="20" style="fill:#', '"/><circle cx="250" cy="250" r="150" style="fill:#', '"/><circle cx="250" cy="250" r="120" style="fill:#',
    '"/><circle cx="200" cy="215" r="35" style="fill:#fff"/><circle cx="305" cy="222" r="31" style="fill:#fff"/><circle cx="200" cy="220" r="20" style="fill:#',
    '"/><circle cx="300" cy="220" r="20" style="fill:#', '"/><circle cx="200" cy="220" r="7" style="fill:#000"/><circle cx="300" cy="220" r="7" style="fill:#000"/>',
    '<ellipse cx="250" cy="315" rx="84" ry="34" style="fill:#',
     '"/><rect x="195" y="330" width="110" height="3" style="fill:#000"/><circle cx="268" cy="295" r="5" style="fill:#000"/><circle cx="232" cy="295" r="5" style="fill:#000"/>',
    '</svg>'];
  string private cross='<rect x="95" y="275" width="10" height="40" style="fill:#872"/><rect x="85" y="285" width="30" height="10" style="fill:#872"/>';
  string private clo1='<rect width="300" height="120" x="99" y="400" style="fill:#';
  string private clo2='"/><rect width="50" height="55" x="280" y="430" style="fill:#';
  string private hh1='<rect width="200" height="99" x="150" y="40" style="fill:#';
  string private hh2='"/><rect width="200" height="33" x="150" y="106" style="fill:#';
  string private sl1='<rect x="150" y="190" width="200" height="30" style="fill:#';
  string private sl2='"/><rect x="160" y="170" width="180" height="50" style="fill:#';
  string private mou='<line x1="287" y1="331" x2="320" y2="366" style="stroke:#000;stroke-width:5"/>';
  string private ey1='<rect x="160" y="190" width="75" height="15" style="fill:#';
  string private ey2='"/><rect x="275" y="190" width="65" height="15" style="fill:#';
  string private ey3='<rect x="160" y="235" width="180" height="50" style="fill:#';
  string private zz='"/>';
  string private ea1='<circle cx="100" cy="290" r="14" style="fill:#';
  string private ea2='fe7';
  string private ea3='999';
  string private ea4='"/><circle cx="100" cy="290" r="4" style="fill:#000"/>';
  string private ea5='<circle cx="100" cy="290" r="12" style="fill:#';
  string private ea6='bdd';
  string private mo1='<line x1="';
  string private mo2='" y1="307" x2="';
  string private mo3='" y2="312" style="stroke:#000;stroke-width:2"/>';
  string private mo4='" y1="317" x2="';
  string private mo5='" y2="322" style="stroke:#000;stroke-width:2"/>';
  string private tr1='", "attributes": [{"trait_type": "Background","value": "';
  string private tr2='"},{"trait_type": "Fur","value": "';
  string private tr3='"},{"trait_type": "Earring","value": "';
  string private tr4='"},{"trait_type": "Hat","value": "';
  string private tr5='"},{"trait_type": "Eyes","value": "';
  string private tr6='"},{"trait_type": "Clothes","value": "';
  string private tr7='"},{"trait_type": "Mouth","value": "';
  string private tr8='"}],"image": "data:image/svg+xml;base64,';
  string private ra1='A';
  string private ra2='C';
  string private ra3='D';
  string private ra4='E';
  string private ra5='F';
  string private ra6='G';
  string private co1=', ';
  string private rl1='{"name": "OnChain Monkey #';
  string private rl3='"}';
  string private rl4='data:application/json;base64,';

  struct Ape { // a nod to BAYC, "ape" was shorter to type than monkey
    uint8 bg;
    uint8 fur;
    uint8 eyes;
    uint8 mouth;
    uint8 earring;
    uint8 clothes;
    uint8 hat;
  }

  // this was used to create the distributon of 10,000 and tested for uniqueness for the given parameters of this collection
  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  function usew(uint8[] memory w,uint256 i) internal pure returns (uint8) {
    uint8 ind=0;
    uint256 j=uint256(w[0]);
    while (j<=i) {
      ind++;
      j+=uint256(w[ind]);
    }
    return ind;
  }

  function randomOne(uint256 tokenId) internal view returns (Ape memory) {
    tokenId=12839-tokenId; // avoid dupes
    Ape memory ape;
    ape.bg = uint8(random(string(abi.encodePacked(ra1,tokenId.toString()))) % 8);
    ape.fur = usew(fur_w,random(string(abi.encodePacked(clo1,tokenId.toString())))%1817);
    ape.eyes = usew(eyes_w,random(string(abi.encodePacked(ra2,tokenId.toString())))%1429);
    ape.mouth = usew(mouth_w,random(string(abi.encodePacked(ra3,tokenId.toString())))%1112);
    ape.earring = usew(earring_w,random(string(abi.encodePacked(ra4,tokenId.toString())))%358);
    ape.clothes = usew(clothes_w,random(string(abi.encodePacked(ra5,tokenId.toString())))%1329);
    ape.hat = usew(hat_w,random(string(abi.encodePacked(ra6,tokenId.toString())))%1111);
    if (tokenId==7403) {
      ape.hat++; // perturb dupe
    }
    return ape;
  }

  // get string attributes of properties, used in tokenURI call
  function getTraits(Ape memory ape) internal view returns (string memory) {
    string memory o=string(abi.encodePacked(tr1,uint256(ape.bg).toString(),tr2,uint256(ape.fur).toString(),tr3,uint256(ape.earring).toString()));
    return string(abi.encodePacked(o,tr4,uint256(ape.hat).toString(),tr5,uint256(ape.eyes).toString(),tr6,uint256(ape.clothes).toString(),tr7,uint256(ape.mouth).toString(),tr8));
  }

  // return comma separated traits in order: hat, fur, clothes, eyes, earring, mouth, background
  function getAttributes(uint256 tokenId) public view returns (string memory) {
    Ape memory ape = randomOne(tokenId);
    string memory o=string(abi.encodePacked(uint256(ape.hat).toString(),co1,uint256(ape.fur).toString(),co1,uint256(ape.clothes).toString(),co1));
    return string(abi.encodePacked(o,uint256(ape.eyes).toString(),co1,uint256(ape.earring).toString(),co1,uint256(ape.mouth).toString(),co1,uint256(ape.bg).toString()));
  }

  function genEye(string memory a,string memory b,uint8 h) internal view returns (string memory) {
    string memory out = '';
    if (h>4) { out = string(abi.encodePacked(sl1,a,sl2,a,zz)); }
    if (h>10) { out = string(abi.encodePacked(out,ey1,b,ey2,b,zz)); }
    if (h>16) { out = string(abi.encodePacked(out,ey3,a,zz)); }
    return out;
  }

  function genMouth(uint8 h) internal view returns (string memory) {
    string memory out = '';
    uint i;
    if ((h>24) || ((h>8) && (h<16))) {
      for (i=0;i<7;i++) {
        out = string(abi.encodePacked(out,mo1,(175+i*25).toString(),mo2,(175+i*25).toString(),mo3));
      }
      for (i=0;i<6;i++) {
        out = string(abi.encodePacked(out,mo1,(187+i*25).toString(),mo4,(187+i*25).toString(),mo5));
      }
    }
    if (h>15) {
      out = string(abi.encodePacked(out,mou));
    }
    return out;
  }

  function genEarring(uint8 h) internal view returns (string memory) {
    if (h==0) {
      return '';
    }
    if (h<3) {
      if (h>1) {
        return string(abi.encodePacked(ea1,ea2,ea4));
      } 
      return string(abi.encodePacked(ea1,ea3,ea4));
    }
    if (h>3) {
      if (h>5) {
        return string(abi.encodePacked(ea5,ea6,zz));
      } 
      if (h>4) {
        return string(abi.encodePacked(ea5,ea2,zz));
      } 
      return string(abi.encodePacked(ea5,ea3,zz));
    }
    return cross;
  }

  function genSVG(Ape memory ape) internal view returns (string memory) {
    string memory a=fur1[ape.fur];
    string memory b=fur2[ape.fur];
    string memory hatst='';
    string memory clost='';
    if (ape.clothes>0) {
      clost=string(abi.encodePacked(clo1,clothes1[ape.clothes-1],clo2,clothes2[ape.clothes-1],zz));
    }
    if (ape.hat>0) {
      hatst=string(abi.encodePacked(hh1,hat1[ape.hat-1],hh2,hat2[ape.hat-1],zz));
    }
    string memory output = string(abi.encodePacked(z[0],background[ape.bg],z[1],b,z[2]));
    output = string(abi.encodePacked(output,a,z[3],a,z[4],b,z[5],a,z[6]));
    output = string(abi.encodePacked(output,b,z[7],a,z[8],b,z[9],a,z[10]));
    output = string(abi.encodePacked(output,eyes[ape.eyes],z[11],eyes[ape.eyes],z[12],genEye(a,b,ape.eyes),z[13],mouth[ape.mouth],z[14]));
    return string(abi.encodePacked(output,genMouth(ape.mouth),genEarring(ape.earring),hatst,clost,z[15]));
  }
    
    function debug() external view returns (string memory) {
        Ape memory ape = randomOne(1);
        return genSVG(ape);
    }
}