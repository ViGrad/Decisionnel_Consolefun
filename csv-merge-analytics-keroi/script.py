from csv_analytics_reader import AnalyticFile
from csv_keroi_reader import KeroiFile

analyticPath = './consolefunpro.csv/analytics.csv'
filesInfos = [
	['./consolefunpro.csv/keroi_fichejeux.csv', "/jeuxvideo/detail/"],
	['./consolefunpro.csv/keroi_tests.csv', "/testsjeux/detail/"],
	['./consolefunpro.csv/keroi_news.csv', "/actualites/detail/"]
]

header = True						# Indique si un header est present dans le fichier

analyticCsv = AnalyticFile("analytics")
analyticCsv.read(analyticPath, header = header)

for infos in filesInfos:
	path = infos[0]
	pre = infos[1]

	splitted = path.split("/")
	name = splitted[len(splitted) - 1]
	csv = KeroiFile(name)
	csv.read(path, header = header)
	analyticCsv.mergeWithKeroi(csv, pre)


analyticCsv.toCsv("output.csv")