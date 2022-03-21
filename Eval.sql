--1
Select
GP.NomGrandPrix,
PGP.DateGP,
C.NomCircuit,
C.LongueurPiste * PGP.NombreTours /1000.0 as 'Distance à Pacourir en KMS'
from GrandPrix GP
inner join PlanificationGP PGP on GP.CodeGP = PGP.CodeGP
inner Join Circuit C on PGP.CodeCircuit = C.CodeCircuit
Order by DateGP;

-- 2
Select
PGP.DateGP,
RC.NumVoiture, RC.NombrePointsMarques, TempsCourse,
P.NomPilote,
E.NomEcurie
From GrandPrix GP
inner join PlanificationGP PGP on GP.CodeGP = PGP.CodeGP
inner join ResultatCourse RC on PGP.codeGP = RC.codeGP
inner join Pilote P on RC.CodePilote = P.CodePilote
inner join Voiture V on Rc.NumVoiture = V.NumVoiture
inner join Ecurie E on V.CodeEcurie = E.CodeEcurie
where NomGrandPrix like '%BAH%'
Order by NombrePointsMarques DESC;

-- 3
Select Distinct NomPilote
From GrandPrix GP
inner join PlanificationGP PGP on GP.CodeGP = PGP.CodeGP
inner join ResultatCourse RC on PGP.CodeGP = RC.CodeGP
inner join Pilote P on P.CodePilote = RC.CodePilote
where RC.Abandon < 1 and RC.Qualifie <>0;

-- 4

Select Distinct S.NomSociete
From Sponsor S
inner join Soutenir_Ecurie SE on S.CodeSponsor = SE.CodeSponsor
inner join Ecurie E on SE.CodeEcurie = E.CodeEcurie
inner join Soutenir_Pilote SP on S.CodeSponsor = SP.CodeSponsor
Inner join Pilote P on SP.CodePilote = P.CodePilote
Order by NomSociete;

-- 5
Select
P.NomPilote,
SUM(RC.NombrePointsMarques) as 'Total de points'
From GrandPrix GP
inner join PlanificationGP PGP on GP.CodeGP = PGP.CodeGP
inner join ResultatCourse RC on PGP.CodeGP = RC.CodeGP
inner join Pilote P on P.CodePilote = RC.CodePilote
Group By P.NomPilote
order by 'Total de points' Desc;

-- 6

Select
E.NomEcurie,
SUM(RC.NombrePointsMarques) as 'Total de points'
From GrandPrix GP
inner join PlanificationGP PGP on GP.CodeGP = PGP.CodeGP
inner join ResultatCourse RC on PGP.CodeGP = RC.CodeGP
inner join Pilote P on P.CodePilote = RC.CodePilote
inner join Voiture V on V.NumVoiture = RC.NumVoiture
inner join Ecurie E on V.CodeEcurie = E.CodeEcurie
Group By E.NomEcurie
order by 'Total de points' Desc;

-- 7
Select NomPilote
From sponsor S
inner join Soutenir_Pilote SP on S.CodeSponsor = SP.CodeSponsor
right join Pilote P on SP.CodePilote = P.CodePilote
where NomSociete is Null;

-- 8

Select GP.NomGrandPrix,
PGP.DateGP,
P.NomPilote,
E.NomEcurie,
V.NumVoiture
From GrandPrix GP
Inner join PlanificationGP PGP on GP.CodeGP = PGP.CodeGP
inner join ResultatCourse RC on PGP.codeGP = RC.codeGP
inner join Pilote P on RC.CodePilote = P.CodePilote
inner join Voiture V on Rc.NumVoiture = V.NumVoiture
inner join Ecurie E on V.CodeEcurie = E.CodeEcurie
Where PositionGrille = 1
order by DateGP

-- 9

Select Count(E.CodeFournisseurPneumatiques) as 'Nombre d écuries',
RaisonSocialeFournisseur
From Fournisseur F
left join Ecurie E on F.CodeFournisseurPneumatiques = E.CodeFournisseurPneumatiques
Group by RaisonSocialeFournisseur


-- 10
Select
P.NomPilote,
AVG(ISNULL(RC.NombrePointsMarques, 0)) as 'Performance'
From GrandPrix GP
inner join PlanificationGP PGP on GP.CodeGP = PGP.CodeGP
inner join ResultatCourse RC on PGP.codeGP = RC.codeGP
inner join Pilote P on RC.CodePilote = P.CodePilote
Group By P.NomPilote
order by 'Performance' DESC

-- 12
Select
GP.NomGrandPrix,
AVG(dbo.GetSpeed((C.LongueurPiste / 1000.0) * PGP.NombreTours, RC.TempsCourse)) as 'Temps KMH moyen'
From GrandPrix GP
inner join PlanificationGP PGP on GP.CodeGP = PGP.CodeGP
inner join circuit C on PGP.CodeCircuit = C.CodeCircuit
inner join ResultatCourse RC on PGP.CodeGP = RC.CodeGP
inner join Pilote P on P.CodePilote = RC.CodePilote
where RC.Abandon < 1 and RC.Qualifie <>0
group by GP.NomGrandPrix

--13

Select P.NomPilote,
dbo.GetSpeed((C.LongueurPiste / 1000.0) * PGP.NombreTours, RC.TempsCourse) as 'Temps moyen KMH'
From GrandPrix GP
inner join PlanificationGP PGP on GP.CodeGP = PGP.CodeGP
inner join circuit C on PGP.CodeCircuit = C.CodeCircuit
inner join ResultatCourse RC on PGP.CodeGP = RC.CodeGP
inner join Pilote P on P.CodePilote = RC.CodePilote
where RC.Abandon < 1 and RC.Qualifie <>0 and GP.NomGrandPrix like '%BAH%' and
dbo.GetSpeed((C.LongueurPiste / 1000.0) * PGP.NombreTours, RC.TempsCourse) >
(Select
AVG(dbo.GetSpeed((C.LongueurPiste / 1000.0) * PGP.NombreTours, RC.TempsCourse))
From GrandPrix GP
inner join PlanificationGP PGP on GP.CodeGP = PGP.CodeGP
inner join circuit C on PGP.CodeCircuit = C.CodeCircuit
inner join ResultatCourse RC on PGP.CodeGP = RC.CodeGP
inner join Pilote P on P.CodePilote = RC.CodePilote
where RC.Abandon < 1 and RC.Qualifie <>0 and GP.NomGrandPrix like '%BAH%'
Group by GP.NomGrandPrix)
Order by 2 Desc