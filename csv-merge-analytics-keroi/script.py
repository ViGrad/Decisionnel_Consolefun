from csv_analytics_reader import AnalyticFile
from csv_keroi_reader import KeroiFile

analyticPath = './consolefunpro.csv/analytics.csv'
analyticHeader = True
filesInfos = [
	{
		'path': './consolefunpro.csv/keroi_fichejeux.csv', 
		'pre': "/jeuxvideo/detail/",
		'columns': [0],
		'header': True,
		'categorie': "Fiche jeux"
	},
	{
		'path': './consolefunpro.csv/keroi_tests.csv', 
		'pre': "/testsjeux/detail/",
		'columns': [0],
		'header': True,
		'categorie': "Test"
	},
	{
		'path': './consolefunpro.csv/keroi_news.csv', 
		'pre': "/actualites/detail/",
		'columns': [0],
		'header': True,
		'categorie': "News"
	}
]

analyticCsv = AnalyticFile("analytics")
analyticCsv.read(analyticPath, header = analyticHeader)

for infos in filesInfos:
	path = infos['path']
	pre = infos['pre']
	header = infos['header']
	columns = infos['columns']
	categorie = infos['categorie']

	splitted = path.split("/")
	name = splitted[len(splitted) - 1]
	csv = KeroiFile(name)
	csv.read(path, header = header, columns = columns, categorie = categorie)
	analyticCsv.mergeWithKeroi(csv, pre)


analyticCsv.toCsv("output.csv")