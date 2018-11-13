import csv

def getColumnsNames(path):
	with open(path, 'rb') as csvfile:
		dataReader = csv.reader(csvfile, delimiter=',')
		firstRow = next(dataReader)

		for i in range(len(firstRow)):
			print(i, firstRow[i])

filePath = './consolefunpro.csv/output.csv'
getColumnsNames(filePath)