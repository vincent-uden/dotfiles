from sys import argv
from settings import *
from main import *

def get_tasks(file_name, as_text=False):
    with open(file_name, "r") as f:
        content = f.read()
    if as_text:
        return content
    tasks = content.split("\n")
    if tasks[-1] == "":
        tasks.pop()
    return tasks

def write_tasks(file_name, tasks):
    output = ""
    for task in tasks:
        output += task + "\n"
    with open(file_name, "w") as f:
        f.write(output)

def add_task(file_name, task):
    with open(file_name, "a") as f:
        f.write(task + "\n")

def remove_task(file_name, index):
    tasks = get_tasks(file_name)
    tasks.pop(index)
    write_tasks(file_name, tasks)

def clear_tasks(file_name):
    with open(file_name, "w") as f:
        f.write("")


if __name__ == "__main__":
    for i, arg in enumerate(argv):
        if arg == "-a":
            add_task(TASK_FILE, argv[i + 1])
        if arg == "-r":
            remove_task(TASK_FILE, int(argv[i + 1]))
        if arg == "-c":
            clear_tasks(TASK_FILE)
    if "-rl" in argv:
        etch_wallpaper()
