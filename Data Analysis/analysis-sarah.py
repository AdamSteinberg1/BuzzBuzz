import csv
import datetime
import matplotlib.pyplot as plt
from matplotlib import *
import scipy.stats as stats
from scipy.stats import f_oneway
import numpy as np


class Subject:
  def __init__(self, pulsoxHR, buzzHR, anxiety, times, videos, num):
    self.pulsoxHR = pulsoxHR
    self.buzzHR = buzzHR
    self.anxiety = anxiety
    self.times = times
    self.videos = videos
    self.num = num

def makeSubject(num: int) -> Subject:
    with open(f'pulse ox subject {num}.csv') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        pulsoxHR = [(datetime.datetime.combine(datetime.date(2022, 3, (22 if num<=3 else 24)), datetime.datetime.strptime(row[0],"%H:%M:%S").time()), float(row[1])) for row in csv_reader]

    with open("SubjectTimes.csv") as csv_file:
        row = list(csv.reader(csv_file, delimiter=','))[num+1]
        times = [datetime.datetime.strptime(row[1] + " " + entry, "%m/%d/%y %H:%M:%S") for entry in row[2:29]]        

    startTime = times[0]
    endTime = times[-1]

    with open("BBB Heart Rate Data.csv") as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        buzzHR = []
        for row in csv_reader:
            sampleTime = datetime.datetime.strptime(row[1], "%Y-%m-%d %H:%M:%S.%f")
            if sampleTime >= startTime and sampleTime <= endTime:
                buzzHR.append((sampleTime, float(row[0])))

    with open(f"Subject {num} Anxiety.csv") as csv_file:
        csv_reader= csv.reader(csv_file, delimiter=',')
        next(csv_reader)
        header = next(csv_reader)
        anxiety = {}
        videos = []
        for row in csv_reader:
            videos.append(row[0])
            buzzMode = int(row[1])
            anxiety[buzzMode] = {}
            for i in range(3,10):
                anxiety[buzzMode][header[i]] = int(row[i])

    return Subject(pulsoxHR, buzzHR, anxiety, times, videos, num)

def graphCompareSensors(subjects: list[Subject]):
    for subject in subjects:
        
        startTime = max(subject.buzzHR[0][0], subject.pulsoxHR[0][0])
        endTime = min(subject.buzzHR[-1][0], subject.pulsoxHR[-1][0])

        x1 = [(i-startTime).total_seconds()/60 for i,j in subject.buzzHR]
        y1 = [j for i,j in subject.buzzHR]

        x2 = [(i-startTime).total_seconds()/60 for i,j in subject.pulsoxHR]
        y2 = [j for i,j in subject.pulsoxHR]

        plt.figure()
        plt.title(f"Subject {subject.num} Heart Rate")
        plt.xlim(0, (endTime-startTime).total_seconds()/60)
        plt.xlabel("Time (minutes)", fontsize=14)
        plt.ylabel("Heart Rate (bpm)", fontsize=14)
        plt.plot(x1,y1, label="Buzz Buzz Bracelet")
        plt.plot(x2,y2, label="Pulse Oximeter")
        plt.legend()
        #plt.savefig(f"figures/hr_comp_{subject.num}.png")
        plt.show()

def statistics(subjects: list[Subject]):
    for subject in subjects:
        startTime = max(subject.buzzHR[0][0], subject.pulsoxHR[0][0])
        endTime = min(subject.buzzHR[-1][0], subject.pulsoxHR[-1][0])

        x1 = [(i-startTime).total_seconds()/60 for i,j in subject.buzzHR]
        y1 = [j for i,j in subject.buzzHR]

        x2 = [(i-startTime).total_seconds()/60 for i,j in subject.pulsoxHR]
        y2 = [j for i,j in subject.pulsoxHR]

        fvalue, pvalue = stats.f_oneway(y1,y2)
        

        BBBavg = np.mean(y1)
        poavg = np.mean(y2)
        percentdiff = (abs((BBBavg-poavg)/((BBBavg+poavg)/2)))*100
        print(f"subject {subject.num}", fvalue,pvalue, percentdiff)


subjects = [makeSubject(i) for i in range(1,7) if i != 3]
subjects[1].buzzHR.append((datetime.datetime(hour=14, minute=39, year=2022, month=3, day=22), subjects[1].buzzHR[-1][1]))


#set up the aesthetics of the graph
rcParams['font.family']='sans-serif'
rcParams['font.sans-serif']=['Arial']
rcParams.update({'font.size': 12})

#graphCompareSensors(subjects)
statistics(subjects)
print("done")
