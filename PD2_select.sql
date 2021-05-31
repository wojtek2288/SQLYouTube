--select

USE pd2
GO

--£¹czna d³ugoœæ filmów obejrzanych przez u¿ytkowników na danym kanale.

SELECT c.Name as viewer, c2.Name as creator, time
FROM(
	SELECT ch.Creator_id AS viewer, v.Creator_id as creator, 
	CONVERT(VARCHAR(8),DATEADD(ms, SUM(DATEDIFF(ms, '00:00:00', v.Length)), '00:00:00'),108) as time
	FROM Creator_history CH
	JOIN Videos v on v.Video_id = CH.Video_id
	GROUP BY V.Creator_id, ch.Creator_id) gr
JOIN Creators c on gr.viewer = c.Creator_id
JOIN Creators c2 on gr.creator = c2.Creator_id

--Wyszukaæ  u¿ytkowników,  którzy  obserwuj¹  kana³,  ale  obejrzeli  na  nim mniej  ni¿  trzy  filmy.

SELECT C.Name as viewer, C2.Name as subscibesTo, GR.liczba as ilosc_filmow
FROM(
	SELECT c.Creator_id as viewer, C2.Creator_id as subscribesTo, COUNT(*) as liczba
	FROM Creator_subscription cs
	JOIN Creators C on c.Creator_id = cs.Creator1_id
	JOIN Creators C2 on c2.Creator_id = cs.Creator2_id
	JOIN Creator_history ch on C.Creator_id = ch.Creator_id
	JOIN Videos V ON V.Video_id = CH.Video_id AND C2.Creator_id = V.Creator_id
	GROUP BY C.Creator_id, C2.Creator_id) GR
JOIN Creators c ON GR.viewer = C.Creator_id
JOIN Creators c2 ON GR.subscribesTo = C2.Creator_id
WHERE GR.liczba < 3

--Dla ka¿dego gatunku wyszukaæ film ciesz¹cy siê najwiêksz¹ popularnoœci¹

SELECT c.Category_name as CategoryName, MAX(v.Title) as VideoTitle, 
MAX(gr.liczba_odtworzen) as TimesPlayed
FROM(
	SELECT vc.Category_id as category_id, v.Video_id as video_id,
	COUNT(*) as liczba_odtworzen
	FROM Videos_Categories vc
	JOIN Categories c on vc.Category_id = c.Category_id
	JOIN Videos v on vc.Video_id = v.Video_id
	JOIN Creator_history cr on v.Video_id = cr.Video_id
	GROUP BY vc.Category_id, v.Video_id) GR
JOIN Categories C on c.Category_id = gr.category_id
JOIN Videos v on v.Video_id = gr.video_id
GROUP BY c.Category_name

--Dla ka¿dego kana³u stosunek liczby wyœwietleñ do liczby opublikowanych filmów

SELECT C.Name AS name, gr.Stosunek as ratio
FROM (
	SELECT c.Creator_id, COUNT(*)/MAX(gr.LiczbaFilmow) AS Stosunek
	FROM Creators c
	JOIN Videos v on v.Creator_id = c.Creator_id
	JOIN Creator_history ch on ch.Video_id = v.Video_id
	JOIN (
		SELECT v.Creator_id as creator_id, COUNT(*) AS LiczbaFilmow
		FROM Videos V
		GROUP BY V.Creator_id) gr on gr.creator_id = c.Creator_id
	GROUP BY c.Creator_id) gr
JOIN Creators C ON C.Creator_id = GR.Creator_id
ORDER BY GR.Stosunek DESC

--Wyœwietliæ filmy, które s¹ dostêpne w ramach kana³u, który ma najwiêcej subskrybentów

SELECT C.Name, V.Title, GR.SubCount
FROM Creators C
JOIN (
	SELECT TOP 1 *
	FROM (
		SELECT CS.Creator2_id AS CreatorId, COUNT(*) AS SubCount
		FROM Creator_subscription CS
		GROUP BY CS.Creator2_id) GR
	ORDER BY GR.SubCount DESC) GR ON C.Creator_id = GR.CreatorId
JOIN Videos V ON V.Creator_id = GR.CreatorId

