import csv
import datetime
from matplotlib import ticker
import matplotlib.pyplot as plt
from matplotlib import *
import numpy as np
import scipy.stats as stats
from scipy.stats import f_oneway

class Subject:
  def __init__(self, pulsoxHR: list[tuple[datetime.datetime,float]], buzzHR: list[tuple[datetime.datetime,float]], anxiety, times, videos, num):
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
        plt.savefig(f"figures/hr_comp_{subject.num}.png")

def averageAnxiety(subjects, buzzMode):
    anxiety = {
        'Before Video': [], 
        'Beginning of Video': [], 
        'overall ': [], 
        'Near the end of Video': [], 
        'Immediately after the video': [], 
        'Three minutes after video': [], 
    }

    for subject in subjects:
        for key in anxiety:
            anxiety[key].append(subject.anxiety[buzzMode][key])

    for key in anxiety:
        anxiety[key] = (np.average(anxiety[key]), np.std(anxiety[key]))
    
    tmp=anxiety.copy()
    anxiety = {
        "Before the Video": tmp['Before Video'],
        "Beginning of the Video": tmp['Beginning of Video'],
        "Middle of the Video": tmp['overall '],
        "Near End of the Video": tmp['Near the end of Video'],
        "End of the Video": tmp['Immediately after the video'],
        "Three Minutes After the Video": tmp['Three minutes after video'],
    }

    return anxiety

def averageHeartrate(subjects, buzzMode):
    heartrates = {
        "Before the Video": [],
        "Beginning of the Video": [],
        "Middle of the Video": [],
        "Near End of the Video": [],
        "End of the Video": [],
        "Three Minutes After the Video": [],
    }

    for subject in subjects:
        with open('Tidy Data.csv') as csv_file:
            csv_reader = csv.DictReader(csv_file, delimiter=',')
            for row in csv_reader:
                if int(row["Buzz Mode"]) == buzzMode and int(row["Subject Number"]) == subject.num:
                    for key in heartrates:
                        if row["Video Label"] == key:
                            startTime = datetime.datetime.strptime(row["Start Time"] + " " + row["Date"], "%H:%M:%S %m/%d/%Y")
                            endTime = datetime.datetime.strptime(row["End Time"] + " " + row["Date"], "%H:%M:%S %m/%d/%Y")
                            samples = [sample for time, sample in subject.pulsoxHR if time >= startTime and time <= endTime]
                            heartrates[key].append(np.average(samples))

    for key in heartrates:
        heartrates[key] = (np.average(heartrates[key]), np.std(heartrates[key]))

    
    return heartrates


def graphAnxiety(subjects: list[Subject]):
    for buzzMode in range(0,4):
        anxiety = averageAnxiety(subjects, buzzMode)
        heartrates = averageHeartrate(subjects, buzzMode)

        y1std = {key: value[1] for key,value in anxiety.items()}
        print(f"Buzz Mode {buzzMode} anxiety std:", y1std, "\n")

        y2std = {key: value[1] for key,value in heartrates.items()}
        print(f"Buzz Mode {buzzMode} heartrate std:", y2std, "\n")


        plt.figure(figsize=(15, 4.8))
        match buzzMode:
            case 0:
                plt.title("No Vibration")
            case 1:
                plt.title("False Heart Rate - Constant")
            case 2:
                plt.title("False Heart Rate - Gradual")
            case 3:
                plt.title("Guided Breathing")
                
        labels = anxiety.keys()
        y1 = [avg for avg,std in anxiety.values()]
        y2 = [avg for avg,std in heartrates.values()]
      
        x = np.arange(len(labels))
        ax1 = plt.subplot(1,1,1)
        w = 0.3
        plt.xticks(x + w /2, labels)
        plt.xlim(-0.5,6)
        hr_bar = ax1.bar(x, y2, width=w, color='C0', align='center')
        ax2 = ax1.twinx()
        anxiety_bar = ax2.bar(x + w, y1, width=w, color = 'C1', align='center')
        ax1.set_ylabel('Heart Rate')
        ax2.set_ylabel('Anxiety')
        plt.legend([hr_bar, anxiety_bar],['Heart Rate', 'Anxiety'], loc="best")
        plt.savefig(f"figures/Anxiety Buzz Mode {buzzMode}")

def averageDuplicates(data: list[tuple[float, float]]):
    y_values_by_x = {}
    for x, y in data:
        y_values_by_x.setdefault(x, []).append(y)

    average_y_by_x = {k: sum(v)/len(v) for k, v in y_values_by_x.items()}
    return list(average_y_by_x.items())

def averageHeartrate(subjects: list[Subject], buzzMode: int, video: int) -> tuple[list[int], list[float]]:
    data = []
    for subject in subjects:
        with open('Tidy Data.csv', encoding='utf-8-sig') as csv_file:
            csv_reader = csv.DictReader(csv_file, delimiter=',')
            filtered: list[tuple[datetime.datetime, datetime.datetime]] = []
            for row in csv_reader:
                if int(row["Video Number"]) == video and int(row["Buzz Mode"]) == buzzMode and int(row["Subject Number"])==subject.num:
                    startTime = datetime.datetime.strptime(row["Start Time"] + " " + row["Date"], "%H:%M:%S %m/%d/%Y")
                    endTime = datetime.datetime.strptime(row["End Time"] + " " + row["Date"], "%H:%M:%S %m/%d/%Y")
                    filtered.append((startTime,endTime))
            if len(filtered) == 0:
                continue
            startTime = min([start for start,end in filtered])
            endTime = max([end for start,end in filtered])
            heartrates = [((time-startTime).total_seconds(), hr) for time,hr in subject.pulsoxHR if time>=startTime and time<=endTime]
            data.extend(averageDuplicates(heartrates))
    if(len(data)==0):
        return [],[]
    averaged = averageDuplicates(data)
    averaged.sort()
    x,y = [time for time,hr in averaged], [hr for time,hr in averaged]
    return x,y



def graphCompareBuzzModes(subjects: list[Subject]):
    buzzModes = ["No Vibration", "False Heart Rate - Constant", "False Heart Rate - Gradual", "Guided Breathing"]
    for subject in subjects:
        plt.figure(figsize=(15, 4.8))
        for buzzMode in range(4):
            filtered: list[tuple[datetime.datetime, datetime.datetime]] = []
            with open('Tidy Data.csv', encoding='utf-8-sig') as csv_file:
                csv_reader = csv.DictReader(csv_file, delimiter=',')
                for row in csv_reader:
                    if int(row["Buzz Mode"]) == buzzMode and int(row["Subject Number"])==subject.num:
                        startTime = datetime.datetime.strptime(row["Start Time"] + " " + row["Date"], "%H:%M:%S %m/%d/%Y")
                        endTime = datetime.datetime.strptime(row["End Time"] + " " + row["Date"], "%H:%M:%S %m/%d/%Y")
                        filtered.append((startTime,endTime))
            if len(filtered) == 0:
                continue
            startTime = min([start for start,end in filtered])
            endTime = max([end for start,end in filtered])
            heartrates = averageDuplicates(sorted([((time-startTime).total_seconds()/(endTime-startTime).total_seconds(), hr) for time,hr in subject.pulsoxHR if time>=startTime and time<=endTime]))
            x = [time for time,hr in heartrates]
            y = [hr for time,hr in heartrates]
            plt.plot(x,y,label=buzzModes[buzzMode])
        plt.gca().xaxis.set_major_formatter(ticker.PercentFormatter(xmax=1))
        plt.ylabel("Heart Rate (bpm)")
        plt.xlabel("Percentage of Video")
        plt.title(f"Subject {subject.num}")
        plt.ylim(top=plt.ylim()[1]*1.1)
        plt.legend(loc="upper center", ncol=len(buzzModes))
        plt.savefig(f"figures/Subject {subject.num} Buzz Modes.png")
        
        
def statistics(subjects: list[Subject])
    buzzModes = ["No Vibration", "False Heart Rate - Constant", "False Heart Rate - Gradual", "Guided Breathing"]
    for subject in subjects:
        fvalue, pvalue = stats.f_oneway()
        print(f"Subject {subject.num}",fvalue,pvalue)

subjects = [makeSubject(i) for i in range(1,7) if i != 3]
subjects[1].buzzHR.append((datetime.datetime(hour=14, minute=39, year=2022, month=3, day=22), subjects[1].buzzHR[-1][1]))


#set up the aesthetics of the graph
rcParams['font.family']='sans-serif'
rcParams['font.sans-serif']=['Arial']
rcParams.update({'font.size': 12})

#graphCompareSensors(subjects)
#graphAnxiety(subjects)
graphCompareBuzzModes(subjects)

print("done")
