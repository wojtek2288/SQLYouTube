--inserty
USE pd2
GO

INSERT INTO Creators
VALUES(1,'PewDiePie', 'pewdie@hotmail.com'), (2,'SebastianSzwed', 'ugh_boy@gmail.com'), 
	  (3, 'Huston Jones', 'hj200@bestmail.com'), (4, 'Larry Wheels', 'larygary@u2.uk'),
	  (5, 'Eric Rosen', 'ericche22@yt.com'), (6, 'Maciej Je', 'jemhoho@hihi.pl')

INSERT INTO Videos
VALUES(1,'Sebastian Szwed nie jest brzydki', '00:02:10', 2), (2,'My new car', '00:10:24', 1),
	  (3,'Calf kicked by UFC Fighter', '00:11:32', 3), (4,'AM I READY', '00:28:20', 4),
	  (5,'I was bribed to play the Wayward Queen Attack', '00:08:20', 5), 
	  (6,'Duze pieni¹dze za najdro¿sze jedzenie', '00:16:16', 6), (7,'fifa z widzami', '00:05:02', 2),
	  (8,'Steki w Dubaju', '00:12:42', 6)

INSERT INTO Creator_subscription
VALUES (1,2), (1,3), (1,5), (2,1), (2,6),(3,5), (3,1),(4,1), (4,2), (5,4), (5,6), (6,2), (6,3) 

INSERT INTO Categories
VALUES (1, 'Gaming'), (2,'Educational'), (3, 'Movie'), (4, 'Music'), (5, 'Action'), (6, 'Tutorial')

INSERT INTO Videos_Categories
VALUES (1,2), (2,1), (3, 2), (4,5), (5,6), (6,2), (7,6)

INSERT INTO Creator_history
VALUES (1,1, '2008-12-11'), (1,3, '2019-03-05'), (1,4, '2020-02-07'), (1,6, '2015-04-09'),
	   (2, 1, '2018-09-05'), (2,5, '2008-03-03'), (2,2, '2017-09-03'), (2,6, '2019-11-06'),
	   (3,2, '2015-06-09'), (3,4, '2019-07-08'), (3, 5, '2012-02-01'),
	   (4,1, '2006-04-30'), (4,2, '2002-03-05'), (4,3, '2014-02-16'), (4, 6, '2019-08-04'),
	   (5,1, '2019-07-24'), (5,2, '2009-09-24'), (5,3,'2020-03-27'), (5,4, '2018-05-18'),
	   (6,2, '2015-06-19'), (6, 4, '2001-09-09'), (6, 7, '2001-10-09'), (6, 1, '2001-10-12')


--modyfikacja 3 rekordow w jednej tabeli

UPDATE Creators
SET Email = 'pewdie12@hotmail.com'
WHERE Creator_id = 1


UPDATE Creators
SET Name = 'Kidraman'
WHERE Creator_id = 2

UPDATE Creators
SET Name = 'Houston Jones'
WHERE Creator_id = 3