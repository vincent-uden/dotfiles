from os import path, system
from subprocess import call
from etch import etch_text
from tasklist import get_tasks
from settings import *
from math import ceil

def etch_wallpaper():
    all_tasks = get_tasks(TASK_FILE, as_text=False)
    longest = max(all_tasks, key=len)
    longest_half_len = ceil(float(len(longest))/2)
    print(len(longest))
    print(longest_half_len)
    todo_line = "-" * (longest_half_len - 4) + "- TODO -" + "-" * (longest_half_len - 4) + "\n"
    print(len(todo_line))
    etch_text(todo_line + get_tasks(TASK_FILE, as_text=True) + "-" * (len(todo_line) - 1))
    cwd = path.dirname(path.abspath(__file__))
    system(FEH_PATH + " --bg-scale " + cwd + "/etched-wp.png")

if __name__ == "__main__":
    etch_wallpaper()
