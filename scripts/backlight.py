import subprocess
import sys

def clamp(n, lower_bound, upper_bound):
    return min(upper_bound, max(lower_bound, n))

GPU_PATH = "/sys/class/backlight/amdgpu_bl0/"
def parse_stdin():
    max_brightness = subprocess.run(["cat", GPU_PATH + "max_brightness"], stdout=subprocess.PIPE).stdout.decode("utf-8")[:-1]
    max_brightness = int(max_brightness)
    new_brightness = None

    if "-i" in sys.argv:
        i = 0
        for index, text in enumerate(sys.argv):
            if text == "-i":
                i = index
                break
        curr_brightness = subprocess.run(["cat", GPU_PATH + "brightness"], stdout=subprocess.PIPE).stdout.decode("utf-8")[:-1]
        curr_brightness = int(curr_brightness)
        with open(GPU_PATH + "brightness", "w") as f:
            f.write(str(clamp(curr_brightness + int(sys.argv[i + 1]), 0, max_brightness)))
        # Read from the file to make sure that given value was actually written
        with open(GPU_PATH + "brightness", "r") as f:
            new_brightness = int(f.read())
    elif "-s" in sys.argv or "--show" in sys.argv:
        with open(GPU_PATH + "brightness", "r") as f:
            print(f.read())
    else: # Set brightness
        i = None
        for arg in sys.argv:
            try:
                i = int(arg)
            except:
                pass
        if i == None:
            print("Invalid arguments.")
            print("Try running with \"--help\" for more information.")
            return
        with open(GPU_PATH + "brightness", "w") as f:
            f.write(str(clamp(i, 0, max_brightness)))
        new_brightness = i

if __name__ == "__main__":
    parse_stdin()
