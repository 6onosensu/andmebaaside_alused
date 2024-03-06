use World;
SELECT * FROM City;
select * from country;
select * from CountryLanguage;


-- select laused 2 tabelite põhjal
--vigane päring
select * from City, Country;

--õige päring
select * from Country, City
where city.ID=country.Capital;

--INNER JOIN
SELECT * FROM Country 
INNER JOIN City
ON city.ID=country.Capital;

--use tables nickname
SELECT * FROM Country AS c
INNER JOIN City AS ci
ON ci.ID=c.Capital;

SELECT * FROM Country c
INNER JOIN City ci
ON ci.ID=c.Capital;

--1.a--
SELECT c.name 'Riik', ci.name 'Pealinn',
ci.Population 'Pealinna Elanike Arv' 
FROM Country c
INNER JOIN City ci
ON ci.ID=c.Capital
WHERE c.Continent LIKE 'Europe'
ORDER BY ci.Population desc;

--1.b--
SELECT c.name 'Riik', ci.name 'Pealinn', ci.Population 'Pealinna Elanike Arv' 
FROM Country c
LEFT JOIN City ci
ON ci.ID=c.Capital
ORDER BY c.Name;

--2--
select c.name as 'Riik', ci.Name as Pealinn
from Country as c
INNER JOIN City AS ci
ON ci.ID=C.Capital
Where c.Name=ci.Name;

--3--
select a.id, a.name, a.district, a.countryCode
from city as a, City as b, country as c
where a.Name = b.name and a.ID <> b.ID
AND A.CountryCode=c.code and b.CountryCode=c.code
order by a.name;

--4--
select c.Name AS Riik, c.Continent AS Con,
count(co.Language) As 'Language ARV'
from Country AS c
INNER JOIN CountryLanguage AS co
ON c.Code=co.CountryCode
group by c.name, c.continent
ORDER by count(co.Language) desc;

--5--
SELECT c.name 'Riik',
c.Continent 'Kontinent',
count(cl.Language) 'Keelte Arv' 
FROM Country c, CountryLanguage cl
WHERE c.Code=cl.CountryCode
and cl.IsOfficial = 1
group by c.name, c.continent
ORDER BY count(cl.Language) desc;

--6--
SELECT c.name Riik,
cl.Language Keel,
(c.Population * cl.Percentage) 'Keelte Arv' 
FROM Country c, CountryLanguage cl
WHERE c.Code=cl.CountryCode
AND c.continent LIKE 'Asia'
ORDER BY C.Name

--7.a--
SELECT c.Name Riik,
c.Population 'Riigi Elanikut' ,
ci.Name AS Pealinn,
ci.Population AS 'Pealinna Elanike Arv',
round( (cast(Ci.Population AS FLOAT)/cast(c.Population AS float))*100,1) Protsent
FROM Country as c
INNER JOIN City as ci
ON Ci.ID = c.Capital
ORDER BY c.Name;

--7.b--
SELECT Co.Name AS Riik, Co.Population as 'Riigi Elanikut' ,
Ci.Name AS Pealinn ,Ci.Population AS 'Pealinna Elanike Arv',
round( (cast(Ci.Population AS FLOAT)/cast(Co.Population AS float))*100,1) Protsent
FROM Country as Co
LEFT JOIN City as Ci
ON Ci.ID = Co.Capital
ORDER BY Co.Name;

--8--
SELECT cl.Language Language,
SUM (c.Population * cl.Percentage) 'Kokku Inimest'
FROM country c
INNER JOIN CountryLanguage cl
ON cl.CountryCode=c.Code
GROUP BY cl.Language
ORDER BY SUM (c.Population*cl.Percentage) desc

--9.--
Select cl.Language AS Language, 
SUM(c.Population * cl.Percentage ) AS 'Kokku Inimest'
FROM Country AS c
INNER JOIN CountryLanguage AS cl 
ON cl.CountryCode = c.Code
WHERE c.Continent = 'Europe'
GROUP BY cl.Language
ORDER BY SUM(C.Population * cl.Percentage) desc;

--10--
SELECT c.Name Riik,
c.Continent Kontinent,
c.SurfaceArea Pindala, 
c.IndepYear 'Iseseis Aasta',
c.Population 'Elanikude Arv',
c.GovernmentForm GovernmentForm,
c.HeadOfState HeadOfState,
ci.Name Pealinn,
cl.Language Keel
from country c, city ci, CountryLanguage cl
WHERE cl.countrycode=c.code AND ci.ID = c.Capital AND cl.IsOfficial=1
ORDER BY c.name