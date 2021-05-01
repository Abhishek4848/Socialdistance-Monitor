url = 'https://www.worldometers.info/coronavirus/country/';
cntry = 'india'
cntryURL = strcat(url,cntry);
target = 'Coronavirus Cases:';
confCases = urlfilter(cntryURL,target)
