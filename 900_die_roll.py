# import libraries
import random
import matplotlib.pyplot as plt
from csv import reader
import numpy as npy
# define lists and fill with random numbers
ones =[]
twos =[]
threes =[]
fours =[]
fives =[]
sixes =[]
for i in range (0,900):
    n = random.randint(1,6)
    if n==1:
        ones.append(n)
    elif n==2:
        twos.append(n) 
    elif n==3:
        threes.append(n)
    elif n==4:
        fours.append(n)   
    elif n==5:
        fives.append(n)
    else:
        sixes.append(n)   
# total items in each list 
_1 = len(ones)
_2 = len(twos)
_3 = len(threes)
_4 = len(fours)
_5 = len(fives)
_6 = len(sixes)
# display bar plot for single die over 900 rolls
# practice reading external csv file into a list 
with open('CSV_colors.txt', 'r') as file_object:
    reader_object = reader(file_object)
    colorList =list(reader_object)
    # convert from nested to flat list
    colorList_flat = list(npy.concatenate(colorList).flat)
Die_Value = ['1', '2', '3', '4', '5', '6']
Die_Value_Count = [_1, _2, _3, _4, _5, _6]
plt.xlabel('Die Value', fontsize=16)
plt.ylabel('Roll Count', fontsize=16)
plt.title('Distribution of Roll Values for Single Die ', fontsize=16)

# add values indicating roll totals to each column
bars = plt.bar(Die_Value, height=Die_Value_Count, width =0.4)
textFloat = 5
for bar in bars:
    barHeight = bar.get_height()
    plt.text(bar.get_x(), barHeight + textFloat, barHeight)
axes = plt.gca()
axes.set_ylim([0,200])       
plt.bar(Die_Value,Die_Value_Count,color= colorList_flat,edgecolor='black')

# save image to file, remember to call savefig() function BEFORE show() function
plt.savefig('die_distribution.pdf', bbox_inches='tight')
# practice with different image output file format
plt.savefig('die_distribution.png', dpi=None, facecolor='w', edgecolor='w',
        orientation='portrait', format=None,
        transparent=False, bbox_inches='tight', pad_inches=0.1,
        metadata=None)
# display image in console
plt.show()




