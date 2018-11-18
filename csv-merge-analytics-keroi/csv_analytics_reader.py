import csv

class AnalyticFile:
	def __init__ (self, name):
		self.name = name
		self.columnsNames = []
		self.rows = []

	def colNames(self, columnsNames):
		self.columnsNames = []

	def addRow(self, row):
		self.rows.append(row)

	def mergeWithKeroi(self, csvFile, fileType):
		index = 0
		indexOfUrl = 0
		columnsNames = self.columnsNames
		rows = []
		binding = []

		for i in range(len(csvFile.columnsNames)):
			index = 0
			try:
				index = columnsNames.index(csvFile.columnsNames[i])
			except:
				index = -1

			if(index < 0):
				columnsNames.append(csvFile.columnsNames[i])
				index = len(columnsNames) - 1
				binding.append([i, index])
			
			else:
				binding.append([i, index])

		for i in range(len(self.rows)):
			idFromAnalytics = self.rows[i][indexOfUrl].replace(fileType, "").split("/")[0]
			indexOfId = 0
			for csvRow in csvFile.rows:
				idFromCsv = csvRow[indexOfId]
				if str(idFromCsv) == str(idFromAnalytics):
					for j in range(len(csvRow)):
						bind = None
						for b in binding:
							if b[0] == j:
								bind = b[1]
								break
						
						row = self.rows[i]
						while(len(row) <= bind):
							row.append(None)

						self.rows[i][bind] = csvRow[j]
		
		self.columnsNames = columnsNames

	def read(self, path, **kwargs):
		header = kwargs.get("header")
		rows = kwargs.get("rows")

		with open(path, 'rb') as csvfile:
			dataReader = csv.reader(csvfile, delimiter=',')
			first = True

			firstRow = next(dataReader)
			columns_length = len(firstRow)
			if first == True and header == True:
						self.columnsNames = firstRow
						self.columnsNames.append("genre")
						first = False

			for row in dataReader:
				if len(row) == columns_length:
					newRow = []

					if rows:
						for i in rows:
							try:
								newRow.append(int(row[i].replace("\xc2\xa0", " ").replace(" ", "")))
							except:
								newRow.append(row[i])
					else:
						newRow = row

					newRow.append("Autre")
					self.addRow(newRow)

	def toCsv(self, fileName):
		with open(fileName, 'wb') as destination:
			writer = csv.writer(destination, delimiter=',')
			writer.writerow(self.columnsNames)
			for row in self.rows:
				writer.writerow(row)

	def toString(self):
		string = "Nom: " + self.name + "\n"
		string += "\n"
		string += ",".join((str(x) for x in self.columnsNames)) + "\n"
		for row in self.rows:
			string += ",".join((str(x) for x in row)) + "\n"

		return string