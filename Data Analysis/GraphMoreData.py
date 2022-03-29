import csv
import datetime
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import numpy as np


def readData():
    x=[]
    y=[]
    with open('HKQuantityTypeIdentifierHeartRate.csv') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=';')
        next(csv_reader)
        next(csv_reader)
        for row in csv_reader:
            x.append(datetime.datetime.strptime(row[6], "%Y-%m-%d %H:%M:%S -0400"))
            y.append(float(row[8]))
    return x,y

def graphMostRecentPeriod(x, y, period):
    mostRecent = x[-1]
    filtered = [elem for elem in zip(x,y) if mostRecent - elem[0] < period]
    filtered.sort()
    x=[i for i,j in filtered]
    y=[j for i,j in filtered]
    plt.figure(graphMostRecentPeriod.count)
    graphMostRecentPeriod.count += 1
    plt.plot(x,y)
    plt.ylabel("Heart Rate (bpm)")
    plt.xlabel("Time")



x,y=readData()
graphMostRecentPeriod.count = 0

graphMostRecentPeriod(x,y, datetime.timedelta(hours=1))
plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%H:%M'))
plt.gcf().autofmt_xdate() # Rotation
plt.title("Heart Rates from Past Hour")
plt.savefig("HourlyHR.png")

graphMostRecentPeriod(x,y, datetime.timedelta(days=1))
plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%m/%d %H:%M'))
plt.gcf().autofmt_xdate() # Rotation
plt.title("Heart Rates from Past Day")
plt.savefig("DailyHR.png")

graphMostRecentPeriod(x,y, datetime.timedelta(weeks=1))
plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%m/%d'))
plt.gcf().autofmt_xdate() # Rotation
plt.title("Heart Rates from Past Week")
plt.savefig("WeeklyHR.png")

