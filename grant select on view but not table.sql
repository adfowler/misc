



SELECT *, cast('TPUSA' as varchar(5)) 'MissionCode'
INTO AllMissionData..Gifts
FROM tpusa..gifts;

INSERT INTO AllMissionData..gifts
select donor_id, donation_type, gift_date, amount, donation_method, appeal_code, donation_id, 'SVDP'
from svdp..gifts;


USE AllMissionData
GO

CREATE VIEW V_Gifts as
	SELECT *
	FROM Gifts
	WHERE MissionCode = SUSER_NAME();

USE AllMissionReport
GO

CREATE VIEW V_Gifts as
	SELECT *
	FROM AllMissionData..V_Gifts;
	


use AllMissionData
--user is in public group. no data reader
GRANT SELECT ON V_Gifts to TPUSA


use AllMissionReport
--user is in data reader group
GRANT SELECT ON V_Gifts to TPUSA
