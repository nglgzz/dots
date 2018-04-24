#!/bin/env python
# coding: utf-8
from os import path
import sys
import cv2
import numpy as np

help_msg = """
    ./remap.py SRC:
        remap colors, open a window with the result and don't save it

    ./remap.py SRC DST:
        remap colors on a single file and save the result on the specified file

    ./remap.py SRC1 [SRC2 SRC3 ... SRCN] DST_DIR:
        remap colors on multiple files, and save them with the same name on the
        specified directory

    other options for the future:
        - recursive conversion
        - set src and dst colors
"""

# Colors use BGR format.
src_color = np.array([134, 213, 173])
dst_color = np.array([202, 244, 78])


def show(img):
    cv2.imshow('img', img)
    cv2.waitKey()
    cv2.destroyAllWindows()


def remap_color(filename, src_color, dst_color):
    img = cv2.imread(filename, cv2.IMREAD_UNCHANGED)
    new_img = np.zeros(img.shape, dtype='uint8')

    if img[0][0].shape == (4,):
        # In case of PNGs or images that have an alpha channel, add an extra
        # channel to colors.
        src_color = np.pad(src_color, (0, 1), 'constant')
        dst_color = np.pad(dst_color, (0, 1), 'constant')

    for i, line in enumerate(img):
        for k, pixel in enumerate(line):
            new_img[i][k] = dst_color + (pixel - src_color)
    return new_img


if len(sys.argv) == 1:
    print('No arguments specified.')
    print(help_msg)
    exit()

if len(sys.argv) == 2:
    show(remap_color(sys.argv[1], src_color, dst_color))
    exit()

if len(sys.argv) > 2:
    input_files = sys.argv[1:-1] or [sys.argv[1]]
    output = sys.argv[-1]

    if len(input_files) == 1:
        new_img = remap_color(input_files[0], src_color, dst_color)
        cv2.imwrite(output, new_img)
        exit()

    if  not path.isdir(output):
        print('Output directory not specified.')
        exit()


# (img, name)
new_images = [(
    remap_color(fi, src_color, dst_color),
    path.basename(fi)
) for fi in input_files]

for img, name in new_images:
    cv2.imwrite(path.join(output, name), img)

