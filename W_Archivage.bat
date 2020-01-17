:: Script By Nawek
:: 17-01-2020 
:: Dépendance : 7zip (https://www.7-zip.org/download.html)
@echo off 

:: Variable Date du jour
SET Date=%date:~0,2%-%date:~3,2%-%date:~6,4%

:: Variable contenant l'emplacement de l'ATF.
SET ATFfolder=C:\TOSHO

:: Variable contenant l'emplacement de ATF.ini.
SET ATFini=C:\windows\ATF.ini

:: Variable Contenant l'emplacement de ou seront sauvegardé les données.
SET ArchiveFolder=C:\sauvegarde_ATF
SET ArchiveDate=%ArchiveFolder%\%date%

:: ----------------------------------------------------------

:: Création du dossier d'emplacement de sauvegarde si il n'existe pas.
MKDIR "%ArchiveDate%
MKDIR "%ArchiveDate%\CWindows"

:: Récupère le chemin vers le programme 7-zip (à télécharger si nécessaire & a modifier çelon le client)
SET ZIP="C:\Program Files (x86)\7-Zip\7z.exe"

:: Sauvegarde des données ATF
::forfiles /p %ATFfolder% /m *.* /c "CMD /C robocopy %ArchiveDate%"
robocopy /e %ATFfolder% %ArchiveDate%\ATF
copy %ATFini% %ArchiveDate%\CWindows

:: ----------------------------------------------------------

:: Compression des données
%ZIP% a %ArchiveDate%.7z %ArchiveDate%

:: Suppression du dossier archivé
RMDIR  %ArchiveDate% /S /Q

:: ----------------------------------------------------------

:: Suppression des sauvegardes datant de plus de X jours
SET Jours=30
forfiles /p %ArchiveFolder% /m *.7z /d %Jours% /c "CMD /c del @FILE"
