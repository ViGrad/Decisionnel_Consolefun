import csv

class KeroiFile:
	def __init__ (self, name):
		self.name = name
		self.columnsNames = []
		self.rows = []

	def colNames(self, columnsNames):
		self.columnsNames = []

	def addRow(self, row):
		self.rows.append(row)

	def read(self, path, **kwargs):
		header = kwargs.get("header")
		write_header = kwargs.get("write_header")
		columns = kwargs.get("columns")
		genre = kwargs.get("genre")
		if genre is None:
			genre = "Autre"

		with open(path, 'rb') as csvfile:
			dataReader = csv.reader(csvfile, delimiter=',', quotechar='"')
			first = True

			firstRow = next(dataReader)
			columns_length = len(firstRow)
			if first == True and header == True:
					newRow = []
					first = False

					if columns is None:
						newRow = firstRow
					else:
						for i in columns:
							try:
								newRow.append(int(firstRow[i].replace("\xc2\xa0", " ").replace(" ", "")))
							except:
								newRow.append(firstRow[i])
					newRow.append("genre")
					self.columnsNames = newRow

			for row in dataReader:
				if len(row) == columns_length:
					newRow = []

					if columns is None:
						newRow = row
					else:
						for i in columns:
							try:
								newRow.append(int(row[i].replace("\xc2\xa0", " ").replace(" ", "")))
							except:
								newRow.append(row[i])

					newRow.append(genre)
					self.addRow(newRow)

	def toString(self):
		string = "Nom: " + self.name
		string += "\n"
		string += ",".join((str(x) for x in self.columnsNames))
		for row in self.rows:
			string += ",".join((str(x) for x in row))
			string += "\n"

		return string
