from os import path
from datetime import datetime, date
from PIL import Image, ImageDraw, ImageFont
from settings import *

def etch_text(text):
    output_txt1 = "\nWeek " + str(datetime.now().isocalendar()[1]) + "\n"
    output_txt1 += str(datetime.now().date())

    output_txt = text
    base = Image.open(BASE_IMAGE_PATH).convert('RGBA')
    txt = Image.new('RGBA', base.size, (255,255,255,0))
    fnt = ImageFont.truetype(FONT_PATH, FONT_SIZE)

    d = ImageDraw.Draw(txt)
    d.multiline_text((base.size[0] - d.textsize(output_txt, fnt)[0] - 20,DOCK_HEIGHT), output_txt, font=fnt, align="right", fill=(255,255,255,180))
    d.multiline_text((20, base.size[1] - d.textsize(output_txt1, fnt)[1] - 20 ), output_txt1, font=fnt, align="left", fill=(255, 255, 255, 180))

    out = Image.alpha_composite(base, txt)
    out.save(path.dirname(path.abspath(__file__)) + "/etched-wp.png")
