
import csv

def transform(path, **kwargs):
	header = kwargs.get("header")
	write_header = kwargs.get("write_header")
	columns = kwargs.get("columns")
	columns_length = kwargs.get("columns_length")

	with open("output.csv", 'wb') as destination:
		with open(path, 'rb') as csvfile:
			writer = csv.writer(destination, delimiter=',')
			dataReader = csv.reader(csvfile, delimiter=',')
			first = True

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

						writer.writerow(newRow)



filePath = './consolefunpro.csv/utilisateurs actifs.csv'
header = True						# Indique si un header est present dans le fichier
write_header = True		  # Indique si on ecrit un header dans le fichier de destination
columns = [1]						# Index des colonnes cibles
columns_length = 2			# Tailles des lignes dans le fichier

transform(filePath, header = header, write_header = write_header, columns = columns, columns_length = columns_length)
