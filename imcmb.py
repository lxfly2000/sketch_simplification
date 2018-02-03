#coding:utf-8

from PIL import Image
import argparse

parser = argparse.ArgumentParser(description="拼接图片。")
parser.add_argument("--img_fmt",type=str,help="输入文件名的格式字符串。")
parser.add_argument("--out",type=str,default="out.png",help="保存文件名，默认为“out.png”。")
parser.add_argument("--nx",type=int,help="横向分割数量。")
parser.add_argument("--ny",type=int,help="纵向分割数量。")
params = parser.parse_args()

im=Image.open(params.img_fmt%(0,0))
sum_width=im.width*(params.nx-1)
sum_height=im.height*(params.ny-1)
im.close()
im=Image.open(params.img_fmt%(params.ny-1,params.nx-1))
sum_width+=im.width
sum_height+=im.height
im.close()

im_combine = Image.new("RGB",(sum_width,sum_height))

x,y=0,0
for j in range(0,params.ny):
	for i in range(0,params.nx):
		im=Image.open(params.img_fmt%(j,i))
		im_combine.paste(im,(x,y))
		x+=im.width
		im.close()
		
	x=0
	y+=im.height
		
im_combine.save(params.out)
