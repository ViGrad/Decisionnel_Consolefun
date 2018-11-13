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
		rows = kwargs.get("rows")

		with open(path, 'rb') as csvfile:
			dataReader = csv.reader(csvfile, delimiter=',', quotechar='"')
			first = True

			firstRow = next(dataReader)
			columns_length = len(firstRow)
			if first == True and header == True:
						self.columnsNames = firstRow
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

					self.addRow(newRow)

	def toString(self):
		string = "Nom: " + self.name
		string += "\n"
		string += ",".join((str(x) for x in self.columnsNames))
		for row in self.rows:
			string += ",".join((str(x) for x in row))

		return string
