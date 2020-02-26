#!/usr/bin/python3
import argparse
import os

import platform
if platform.system() != "Linux":
    print("WARNING: This script only supports 64-bit Linux")

parser = argparse.ArgumentParser(description="Build app for Android.")
parser.add_argument("qmake", type=str, help="QMake executable")
parser.add_argument("--ndk", type=str, required=True, dest="ndk", help="Path to the android NDK")
parser.add_argument("--sdk", type=str, required=True, dest="sdk", help="Path to the android SDK")
parser.add_argument("--abi", type=str, required=False, dest="abi", help="Android ABI", default="armeabi-v7a")
parser.add_argument("-j", type=int, required=False, dest="cores", help="Parallel jobs for compilation (make -j[N] argument)", default=os.cpu_count())

args = parser.parse_args()

ndk_make = args.ndk + "/prebuilt/linux-x86_64/bin/make"

os.mkdir("build (Android)")
os.chdir("build (Android)")

os.system(args.qmake + " .. -spec android-clang ANDROID_ABIS=\"" + args.abi + "\"")
os.system(ndk_make + " -j" + str(args.cores) + " apk")