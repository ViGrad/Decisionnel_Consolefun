from csv_analytics_reader import AnalyticFile
from csv_keroi_reader import KeroiFile

analyticPath = './consolefunpro.csv/analytics.csv'
analyticHeader = True
filesInfos = [
	{
		'path': './consolefunpro.csv/keroi_fichejeux.csv', 
		'pre': "/jeuxvideo/detail/",
		'columns': [0, 1, 3, 5],
		'header': True,
		'genre': "Fiche jeux"
	},
	{
		'path': './consolefunpro.csv/keroi_tests.csv', 
		'pre': "/testsjeux/detail/",
		'columns': [0, 1],
		'header': True,
		'genre': "Test"
	},
	{
		'path': './consolefunpro.csv/keroi_news.csv', 
		'pre': "/actualites/detail/",
		'columns': [0, 2, 4, 5, 6],
		'header': True,
		'genre': "News"
	}
]

analyticCsv = AnalyticFile("analytics")
analyticCsv.read(analyticPath, header = analyticHeader)

for infos in filesInfos:
	path = infos['path']
	pre = infos['pre']
	header = infos['header']
	columns = infos['columns']
	genre = infos['genre']

	splitted = path.split("/")
	name = splitted[len(splitted) - 1]
	csv = KeroiFile(name)
	csv.read(path, header = header, columns = columns, genre = genre)
	analyticCsv.mergeWithKeroi(csv, pre)


analyticCsv.toCsv("output.csv")