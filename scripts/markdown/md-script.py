import markdown2 as md
import sys
import os

def get_filenames():
    args = sys.argv[::]
    filenames = []
    for arg in args:
        filename, file_extension = os.path.splittext(arg)
        if file_extension == ".md":
            filenames.append(filename + file_extension)
    print(filenames)

if __name__ == "__main__":
    converter = md.Markdown()
    print(sys.argv)
