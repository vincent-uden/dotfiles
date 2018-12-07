from os import path, system
from subprocess import call
from etch import etch_text
from tasklist import get_tasks
from settings import *

def etch_wallpaper():
    etch_text("- TODO -\n" + get_tasks(TASK_FILE, as_text=True))
    cwd = path.dirname(path.abspath(__file__))
    system(FEH_PATH + " --bg-scale " + cwd + "/etched-wp.png")

if __name__ == "__main__":
    etch_wallpaper()
