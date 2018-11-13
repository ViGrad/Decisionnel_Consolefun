
import csv

def transform(path, **kwargs):
	header = kwargs.get("header")
	write_header = kwargs.get("write_header")
	columns = kwargs.get("columns")
	rows = kwargs.get("rows")
	columns_length = kwargs.get("columns_length")

	with open("output.csv", 'wb') as destination:
		with open(path, 'rb') as csvfile:
			writer = csv.writer(destination, delimiter=',')
			dataReader = csv.reader(csvfile, delimiter=',')
			first = True

			firstRow = next(dataReader)
			columns_length = len(firstRow)
			if first == True and header == True:
						columnsNames = firstRow
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

					writer.writerow(newRow)



filePath = './consolefunpro.csv/output.csv'
header = True						# Indique si un header est present dans le fichier
write_header = True		  # Indique si on ecrit un header dans le fichier de destination
rows = [0, 25]						# Index des colonnes cibles

transform(filePath, header = header, write_header = write_header, rows = rows)
