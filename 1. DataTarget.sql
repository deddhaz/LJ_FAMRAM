DROP TABLE IF EXISTS PBI_LearningJourneyFAMRAM_DataTarget;
SELECT 
    de.nik,
    de.Name,
    de.JobTitle,
    de.WorkLocation,
    de.Area,
    de.Region,
    de.Unit,
    de.[Join Date],
    de.EmploymentStatus,
    pg.[Status Kelulusan] AS [Status Kelulusan GPOP],
    pg1.[Status Kelulusan] AS [Status Kelulusan GLP1],
    ph.[Handle Spv]
INTO PBI_LearningJourneyFAMRAM_DataTarget
FROM DataEmployeeMbeat de
LEFT JOIN hcir.dbo.pichchandle ph ON ph.Cabang = de.WorkLocation
LEFT JOIN PBI_GPOP_Check pg ON pg.NIK = de.nik
LEFT JOIN PBI_GLP1_Cek pg1 ON pg1.NIK = de.NIK
WHERE de.JobTitle IN (
    'Field Asset Management 1-90 Car', 
    'Field Asset Management 1-90 Mix', 
    'Field Asset Management 1-90 Motorcycle',
    'Field Asset Management Car', 
    'Field Asset Management Motorcycle', 
    'Remedial Asset Management Car', 
    'Remedial Asset Management Motorcycle',
	'Field Asset Management',
	'Remedial Asset Management'
) 
AND de.EmploymentStatus IN ('Contract', 'Mitra', 'Outsource', 'Permanent');
