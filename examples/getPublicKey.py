#!/usr/bin/env python
"""
*******************************************************************************
*   Ledger Ethereum App
*   (c) 2016-2019 Ledger
*
*  Licensed under the Apache License, Version 2.0 (the "License");
*  you may not use this file except in compliance with the License.
*  You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
*  Unless required by applicable law or agreed to in writing, software
*  distributed under the License is distributed on an "AS IS" BASIS,
*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*  See the License for the specific language governing permissions and
*  limitations under the License.
********************************************************************************
"""
from __future__ import print_function

from ledgerblue.comm import getDongle
from ledgerblue.commException import CommException
import argparse
import struct
import binascii


def parse_bip32_path(path):
    if len(path) == 0:
        return b""
    result = b""
    elements = path.split('/')
    for pathElement in elements:
        element = pathElement.split('\'')
        if len(element) == 1:
            result = result + struct.pack(">I", int(element[0]))
        else:
            result = result + struct.pack(">I", 0x80000000 | int(element[0]))
    return result


parser = argparse.ArgumentParser()
parser.add_argument('--path', help="BIP 32 path to retrieve")
args = parser.parse_args()

if args.path == None:
    args.path = "44'/19724'/0'/0/0"

donglePath = parse_bip32_path(args.path)
apdu = bytearray.fromhex("ea010100") + chr(len(donglePath)).encode()  + donglePath

print(bytes(apdu).encode('hex'))

dongle = getDongle(True)
result = dongle.exchange(bytes(apdu))
# offset = 1 + result[0]
# address = result[offset + 1: offset + 1 + result[offset]]

print("Public key", binascii.hexlify(result).decode())



