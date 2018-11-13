import csv

class CsvFile:
	def __init__ (self, name):
		self.name = name
		self.columnsNames = []
		self.columns = []

	def colNames(self, columnsNames):
		self.columnsNames = []

	def addRow(self, row):
		self.columns.append(row)

	def read(self, path, **kwargs):
		header = kwargs.get("header")
		write_header = kwargs.get("write_header")
		columns = kwargs.get("columns")

		with open(path, 'rb') as csvfile:
			dataReader = csv.reader(csvfile, delimiter=',')
			first = True

			columns_length = len(next(dataReader))

			for row in dataReader:
				if len(row) == columns_length:
					if first == True and (header == True and write_header == False) :
						first = False

					else:
						newRow = []

						if columns:
							for i in columns:
								try:
									newRow.append(int(row[i].replace("\xc2\xa0", " ").replace(" ", "")))
								except:
									newRow.append(row[i])
						else:
							newRow = row

						self.addRow(newRow)

	def toString(self):
		print("Nom: " + self.name)
		print("\n")
		print(",".join((str(x) for x in self.columnsNames)))
		for row in self.columns:
			print(",".join((str(x) for x in row)))