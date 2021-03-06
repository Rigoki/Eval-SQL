USE [GrandPrixF1]
GO
/****** Object:  UserDefinedFunction [dbo].[GetSpeed]    Script Date: 17/03/2022 11:15:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
ALTER FUNCTION [dbo].[GetSpeed]
(
	@Distance decimal (6,3),
	@Time Time
)
RETURNS decimal(6,3)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @SpeedKMH decimal(6,3),
	@Heure int,
	@minutes int,
	@secondes int,
	@ms  int,
	@total int

	set @Heure = datepart(hh,@time) *3600.0
	set @minutes = datepart(mi, @time) * 60.0
	set @secondes = datepart(ss, @time)
	set @ms = datepart(ms, @Time) / 1000.0
	set @total = @heure + @minutes+@secondes+ @ms
	set @SpeedKMH = @Distance / @total * 3600.0
	-- Return the result of the function
	RETURN @SpeedKMH

END
