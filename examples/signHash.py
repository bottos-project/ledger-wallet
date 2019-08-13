# encode=utf-8
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
import hashlib


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

def sha256(s):
    return hashlib.sha256(s).hexdigest()

parser = argparse.ArgumentParser()
parser.add_argument('--path', help="BIP 32 path to retrieve")
parser.add_argument('--msg', help="sign content")

args = parser.parse_args()

if args.path == None:
    args.path = "44'/19724'/0'/0/0"

if args.msg is None:
    args.msg = "hello world!!"

donglePath = parse_bip32_path(args.path)
hashValue = sha256( args.msg)
apdu = bytearray.fromhex("ea020100") + chr(len(donglePath) + 32).encode()  + donglePath + bytearray.fromhex(hashValue)

print(bytes(apdu).encode('hex'))

dongle = getDongle(True)
result = dongle.exchange(bytes(apdu))
# offset = 1 + result[0]
# address = result[offset + 1: offset + 1 + result[offset]]

print("result", binascii.hexlify(result).decode())



