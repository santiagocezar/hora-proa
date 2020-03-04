#!/usr/bin/python3
import argparse
import os
import json
import platform
from shutil import copyfile

parser = argparse.ArgumentParser(description="Build app for Android.")
parser.add_argument("--ndk", type=str, required=True, dest="ndk", help="Path to the Android NDK")
parser.add_argument("--sdk", type=str, required=True, dest="sdk", help="Path to the Android SDK")
parser.add_argument("--jdk", type=str, required=True, dest="jdk", help="Path to the Java SDK")
parser.add_argument("--qt", type=str, required=True, dest="qt", help="Path to Qt installation")
parser.add_argument("--abi", type=str, required=False, dest="abi", help="Android ABI", default="armeabi-v7a")
parser.add_argument("-j", type=int, required=False, dest="cores", help="Parallel jobs for compilation (make -j[N] argument)", default=os.cpu_count())

args = parser.parse_args()

prebuilts = args.ndk + "/prebuilt/" + platform.system().lower() + "-" + platform.machine() + "/"

os.environ["ANDROID_NDK"] = args.ndk
os.environ["ANDROID_SDK"] = args.sdk
os.environ["ANDROID_PLATFORM"] = "29"
os.environ["JAVA_HOME"] = args.jdk
os.environ["PATH"] = "{}/bin:{}".format(args.qt, os.environ["PATH"])

if not os.path.exists("android-build"):
    os.mkdir("android-build")
os.chdir("android-build")

#os.system(args.qmake + " .. -spec android-clang ANDROID_ABIS=\"" + args.abi + "\"")
#os.system(ndk_make + " -j" + str(args.cores) + " apk")

cmd = """cmake  -DCMAKE_PREFIX_PATH={}/lib/cmake\\
                -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ON\\
                -DANDROID_ABI={}\\
                -DANDROID_PLATFORM=29\\
                -DANDROID_STL=c++_shared\\
                -DANDROID_DEPLOY_QT={}/bin/androiddeployqt\\
                -DCMAKE_TOOLCHAIN_FILE={}/build/cmake/android.toolchain.cmake .. """\
                .format(args.qt, args.abi, args.qt,args.ndk)
print(cmd)
os.system(cmd)
"""
with open("android_deployment_settings.json", "r+") as ads:
    j = json.load(ads)
    j["armeabi-v7a"] = "arm-linux-androideabi"
    ads.seek(0)
    json.dump(j, ads)
    ads.truncate()
"""
cmd = "make"
print(cmd)
if os.system(cmd):
    copyfile("android-build/build/outputs/apk/debug/android-build-debug.apk", "HoraProA.apk")
