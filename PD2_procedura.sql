--PROCEDURA SKLADNIOWA

USE PD2
GO
	if OBJECT_ID('HistoryArchive') IS NOT NULL  drop table HistoryArchive;
	select * into HistoryArchive from Creator_history where 0=1;

	ALTER TABLE Videos
	ADD
		ViewsCnt int
	GO

	ALTER TABLE HistoryArchive 
	ADD 
		CONSTRAINT PK_HistoryArchive_key PRIMARY KEY(Creator_id, Video_id)
	GO
GO

IF OBJECT_ID('arch') IS NOT NULL 
	DROP PROC arch;
GO
CREATE PROCEDURE arch 
	@DaysCount int
AS
BEGIN
	--set Identity_insert dbo.HistoryArchive ON;
 
	DECLARE @archiveDate  datetime;
	DECLARE @currentDate  datetime;
	DECLARE @archivedOrderIDs TABLE(Creator_id int, Video_id int);

	SET @currentDate = getdate();
	SET @archiveDate = dateadd(dd, -@DaysCount, @currentDate);
	
	IF (SELECT COUNT(*) FROM Creator_history WHERE date <= @archiveDate) = 0 
	BEGIN
		print 'There are no records to archive... ';
		RETURN;
	END;

	print 'Archiving records older than ' + CONVERT(varchar(50),@DaysCount) + ' days';

	set transaction isolation level serializable;
	
	begin transaction
	begin try 
		
		INSERT INTO HistoryArchive([Creator_id], [Video_id], [date])
		OUTPUT INSERTED.Creator_id, INSERTED.Video_id INTO @archivedOrderIDs
		SELECT * FROM Creator_history WHERE date <= @archiveDate;
		
		DELETE FROM Creator_history
		FROM Creator_history CH JOIN @archivedOrderIDs AO 
		ON CH.Creator_id = AO.Creator_id AND CH.Video_id = AO.Video_id;

		UPDATE Videos
		SET  Videos.ViewsCnt = gr.numb
		FROM (SELECT COUNT(*) as numb, CH.Video_id AS video_id FROM Creator_history CH GROUP BY CH.Video_id) GR
		WHERE Videos.Video_id = gr.video_id

		UPDATE Videos 
		SET Videos.ViewsCnt = 0
		WHERE Videos.ViewsCnt IS NULL

	commit transaction
	END TRY

	BEGIN CATCH
		ROLLBACK transaction 

	END CATCH
	
END

select * from Creator_history

EXEC arch 1000;

select * from Creator_history
select * from videos