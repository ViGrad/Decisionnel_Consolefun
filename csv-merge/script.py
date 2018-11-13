from csv_file_struct import CsvFile



filePath = './consolefunpro.csv/analytics.csv'
header = True						# Indique si un header est present dans le fichier
write_header = True		  # Indique si on ecrit un header dans le fichier de destination

csv = CsvFile("Analytics")
csv.read(filePath, header = header, write_header = write_header)

