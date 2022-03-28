#Goal: Graph User opinion vs buzz mode as a bar graph. 
#each bar will represent the average of six subjects opinion
#the error bar will represent the standard deviation between the trials. 

#Libraries
import matplotlib.pyplot as plt
import numpy as np
import math
from matplotlib import rcParams

#set up the aesthetics of the graph
rcParams['font.family']='sans-serif'
rcParams['font.sans-serif']=['Arial']
rcParams.update({'font.size': 12})

n = 3 # number of groups

#Average User Opinion
BuzzMode = ['BuzzMatch','BuzzGradual','BuzzBreath']
AvgOpinion = [-0.5, -0.3, 1.5]
BuzzStdev = [2.81,2.73,3.27]

index = np.arange(n)

#make the graph
fig = plt.figure()
plt.bar(BuzzMode, AvgOpinion)
plt.errorbar(index, AvgOpinion, yerr=BuzzStdev,capsize=4,marker="s",markersize=3, fmt ="o", color = 'black')
plt.xlabel("Buzz Mode",fontsize = 14)
plt.ylabel("User Opinion", fontsize = 14)
plt.ylim(-5,5)
plt.xticks(index, ('False Heart Rate - Constant', 'False Heart Rate - Gradual', 'Guided Breathing'))

ax = plt.gca()
ax.axhline(color = 'black', linewidth = 1)
ax.set_yticks([-5,-4,-3,-2,-1-0,1,2,3,4,5])

plt.show()