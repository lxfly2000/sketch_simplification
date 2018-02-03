#coding:utf-8

from PIL import Image
import argparse
import math

parser = argparse.ArgumentParser(description="分割图片。")
parser.add_argument("--img",type=str,help="输入文件名。")
parser.add_argument("--out_fmt",type=str,default="out_%d_%d.png",help="输出文件名，默认为“out_%%d_%%d.png”。")
parser.add_argument("--dw",type=int,default=500,help="分割宽度，默认为 500.")
parser.add_argument("--dh",type=int,default=500,help="分割高度，默认为 500.")
params = parser.parse_args()

im=Image.open(params.img)
div_w=im.width/math.ceil(im.width/params.dw)
div_h=im.height/math.ceil(im.height/params.dh)

y=0
while y*div_h<im.height:
	x=0
	while x*div_w<im.width:
		file_name = params.out_fmt%(y,x)
		im.crop((x*div_w,y*div_h,(x+1)*div_w,(y+1)*div_h)).save(file_name)
		x+=1
		
	y+=1
