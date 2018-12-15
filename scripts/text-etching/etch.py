from os import path
from datetime import datetime, date
from PIL import Image, ImageDraw, ImageFont
from settings import *

TEXT_COLOR = (255, 140, 0, 255)
BOX_PADDING = 20

def etch_text(text):
    output_txt1 = "----------\nWeek " + str(datetime.now().isocalendar()[1]) + "\n"
    output_txt1 += str(datetime.now().date())
    output_txt1 += "\n----------"

    output_txt = text
    base = Image.open(BASE_IMAGE_PATH).convert('RGBA')
    txt = Image.new('RGBA', base.size, (255,255,255,0))
    fnt = ImageFont.truetype(FONT_PATH, FONT_SIZE)


    d = ImageDraw.Draw(txt)

    left_text_pos = [40, base.size[1] - d.textsize(output_txt1, fnt)[1] - 40]
    right_text_pos = [base.size[0] - d.textsize(output_txt, fnt)[0] - 40, base.size[1] - d.textsize(output_txt, fnt)[1] - 40]

    left_text_size = d.textsize(output_txt1, fnt)
    right_text_size = d.textsize(output_txt, fnt)

    left_text_end = [left_text_pos[0]+left_text_size[0], left_text_pos[1]+left_text_size[1]]
    right_text_end = [right_text_pos[0]+right_text_size[0], right_text_pos[1]+right_text_size[1]]

    left_box_pos = left_text_pos[::]
    left_box_pos[0] -= BOX_PADDING
    left_box_pos[1] -= BOX_PADDING

    left_box_end = left_text_end[::]
    left_box_end[0] += BOX_PADDING
    left_box_end[1] += BOX_PADDING

    right_box_pos = right_text_pos[::]
    right_box_pos[0] -= BOX_PADDING
    right_box_pos[1] -= BOX_PADDING

    right_box_end = right_text_end[::]
    right_box_end[0] += BOX_PADDING
    right_box_end[1] += BOX_PADDING
    
    # FIXA POSITION
    d.rectangle(left_box_pos + left_box_end, fill=(0, 0, 0, 60), outline=TEXT_COLOR)
    d.rectangle(right_box_pos + right_box_end, fill=(0, 0, 0, 60), outline=TEXT_COLOR)

    d.multiline_text(right_text_pos, output_txt, font=fnt, align="right", fill=TEXT_COLOR)
    d.multiline_text(left_text_pos, output_txt1, font=fnt, align="left", fill=TEXT_COLOR)

    out = Image.alpha_composite(base, txt)
    out.save(path.dirname(path.abspath(__file__)) + "/etched-wp.png")
