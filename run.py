import subprocess
import argparse
import sys
def check():
    try:
        # chelck if maven and cargo are installed
        
        subprocess.run(
            ["mvn", "--version"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True
        )
        
    except FileNotFoundError:
        print("Maven or Cargo are not installed")
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(description="Run the application")
    parser.add_argument("-w", "--web", action="store_true", help="Run only web")
    parser.add_argument("-a", "--all", action="store_true", help="Run all web services and Ai")
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(0)
    
    args = parser.parse_args()
    print(args) 

    if args.all:
        subprocess.call(["uvicorn", "api:app", "--reload", "--host", "0.0.0.0", "--port", "8000", ])
        subprocess.call(["mvn", "tomcat9:run"])
    if args.web:
        subprocess.call(["mvn", "tomcat9:run"])

if __name__ == "__main__":
    check()
    main()
