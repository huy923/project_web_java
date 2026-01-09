import os,sys
import subprocess
def check():
    # check have file env 
    if not os.path.exists(".env"):
        # create file .env
        if sys.platform == "linux" or sys.platform == "darwin": # if os is linux or mac
            subprocess.run("cp .env.example .env")
            # check have openssl
            if not os.path.exists("/usr/bin/openssl"): 
                print("❌ Please install openssl")
                sys.exit(1)
        else: # if os is windows
            subprocess.run("copy .env.example .env")
            # check have openssl
            if not os.path.exists("C:\\Program Files\\OpenSSL-Win64\\bin\\openssl.exe"): 
                print("❌ Please install openssl")
                sys.exit(1)
    