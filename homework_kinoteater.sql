-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 27, 2024 at 09:45 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `homework_kinoteater`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddColumnToRezisoor` (IN `columnName` VARCHAR(255), IN `columnType` VARCHAR(255), IN `columnNullable` VARCHAR(255), IN `columnDefault` VARCHAR(255))   BEGIN
	IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = DATABASE() 
        AND TABLE_NAME = 'rezisoor' 
        AND COLUMN_NAME = columnName
        ) THEN
        SET @ddl = CONCAT(
        	'ALTER TABLE rezisoor ADD ', columnName, ' ', columnType, 
        	IF(columnNullable = 'YES', ' NULL', ' NOT NULL'), 
         	IF(columnDefault IS NOT NULL AND columnDefault != '', CONCAT(' DEFAULT ', columnDefault), '')
            );
        PREPARE stmt FROM @ddl;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
	ELSE
		SELECT CONCAT('Column "', columnName, '" already exists in table "rezisoor".') AS warning;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addColumnToTable` (IN `tableName` VARCHAR(255), IN `columnName` VARCHAR(255), IN `dataType` VARCHAR(255), IN `defaultValue` VARCHAR(255))   BEGIN
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = DATABASE() 
        AND TABLE_NAME = tableName 
        AND COLUMN_NAME = columnName
	) THEN
        SET @ddl = CONCAT('ALTER TABLE ', tableName, 
                          ' ADD COLUMN ', columnName, ' ', dataType, 
                          ' NOT NULL', 
                          IF(defaultValue IS NOT NULL AND defaultValue != '', CONCAT(' DEFAULT ', QUOTE(defaultValue)), '')
                         );
        PREPARE stmt FROM @ddl;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addFilm` (IN `name` VARCHAR(200), IN `genreID` INT, IN `languageID` INT, IN `runningTime` INT, IN `directorID` INT, IN `filmTypeID` INT)   BEGIN
    INSERT INTO film(filmNimetus, zanrID, keelID, pikkus, rezisorID, filmtypeID)
    VALUES (name, genreID, languageID, runningTime, directorID, filmTypeID);
    SELECT * FROM film;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createTable` (IN `newTableName` VARCHAR(255))   BEGIN
  SET @ddl = CONCAT('CREATE TABLE ', newTableName, ' (',
                      'id INT AUTO_INCREMENT PRIMARY KEY, ',
                      'name VARCHAR(255)',
                      ');');
  PREPARE stmt FROM @ddl;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
  SELECT CONCAT('Table `', newTableName, '` has been created.') AS Result;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteFromGenre` (IN `deleteID` INT)   BEGIN
	SELECT * FROM zanr;
    DELETE FROM zanr
    WHERE zanrID=deleteID;
    SELECT * from zanr;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteTableByName` (IN `tableName` VARCHAR(255))   BEGIN
	DECLARE fkCount INT;
 	SELECT COUNT(*)
  	INTO fkCount
  	FROM information_schema.TABLE_CONSTRAINTS
  	WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = tableName AND CONSTRAINT_TYPE = 'FOREIGN KEY';

  	IF fkCount = 0 THEN
        SET @s = CONCAT('DROP TABLE ', tableName);
        PREPARE stmt FROM @s;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SELECT CONCAT('Table ', tableName, ' has been dropped.') AS Result;
  	ELSE
    	SELECT CONCAT('Table ', tableName, ' was not dropped because it has foreign keys.') AS Result;
  	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRezisoor` (IN `id` INT, IN `newName` VARCHAR(255), IN `newSurname` VARCHAR(255))   BEGIN
  	UPDATE rezisoor SET eesnimi = newName, perenimi = newSurname WHERE rezisoorID = id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `country`
--

CREATE TABLE `country` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `film`
--

CREATE TABLE `film` (
  `filmID` int(11) NOT NULL,
  `filmNimetus` varchar(25) NOT NULL,
  `zanrID` int(11) NOT NULL,
  `keelID` int(11) NOT NULL,
  `pikkus` int(11) NOT NULL,
  `rezisorID` int(11) NOT NULL,
  `filmtypeID` int(11) NOT NULL,
  `reklaam` text NOT NULL,
  `country` varchar(255) NOT NULL DEFAULT 'NULL'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `film`
--

INSERT INTO `film` (`filmID`, `filmNimetus`, `zanrID`, `keelID`, `pikkus`, `rezisorID`, `filmtypeID`, `reklaam`, `country`) VALUES
(1, 'Pulp Fiction', 8, 1, 154, 1, 1, '', 'NULL'),
(2, 'Vabastatud Django', 1, 1, 165, 1, 2, '', 'NULL'),
(3, 'Ongi Karloson!', 4, 2, 80, 2, 2, '', 'NULL'),
(4, 'Roheline elevant', 7, 2, 86, 3, 1, '', 'NULL'),
(5, 'Kaardid, rahad, kaks püst', 4, 3, 107, 5, 2, '', 'NULL'),
(11, 'Harry Potter', 2, 3, 152, 7, 3, '', 'NULL'),
(12, 'Harry Potter 2', 2, 3, 161, 7, 2, '', 'NULL');

-- --------------------------------------------------------

--
-- Table structure for table `filmtype`
--

CREATE TABLE `filmtype` (
  `filmTypeID` int(11) NOT NULL,
  `filmType` varchar(25) NOT NULL,
  `kirjeldus` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `filmtype`
--

INSERT INTO `filmtype` (`filmTypeID`, `filmType`, `kirjeldus`) VALUES
(1, '2D', '2D-arvutigraafika on pildi esitamine digitaalsete kahemõõtmeliste mudelitena, näiteks tasandilise geomeetria ja teksti abil.'),
(2, '3D', '3D-arvutigraafika on pildi esitamine digitaalsete kolmemõõtmeliste mudelitena, näiteks ruumilise geomeetria abil.\r\n\r\n3D-mudel on kolmemõõtmelise objekti matemaatiline esitus. Mudelit saab kuvada kahemõõtmelisena 3D-renderdamise kaudu või kasutada mittevisuaalse arvutisimulatsiooni või arvutuste jaoks. On olemas ka 3D-arvutigraafika tarkvara.'),
(3, '4D', '3D-arvutigraafika lisaeffektidega.');

-- --------------------------------------------------------

--
-- Table structure for table `keel`
--

CREATE TABLE `keel` (
  `keelID` int(11) NOT NULL,
  `keelNimi` varchar(25) NOT NULL,
  `keelNimiVene` varchar(25) NOT NULL,
  `keelNimiInglise` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `keel`
--

INSERT INTO `keel` (`keelID`, `keelNimi`, `keelNimiVene`, `keelNimiInglise`) VALUES
(1, 'Eesti', 'Эстонский', 'Estonian'),
(2, 'Vene', 'Русский', 'Russian'),
(3, 'Inglise', 'Английский', 'English'),
(4, 'Saksa', 'Немецкий', 'German'),
(5, 'Prantsuse', 'Французский', 'French');

-- --------------------------------------------------------

--
-- Table structure for table `kinokava`
--

CREATE TABLE `kinokava` (
  `kinokavaID` int(11) NOT NULL,
  `kuupaev` datetime DEFAULT NULL,
  `filmNimetus` int(11) DEFAULT NULL,
  `pilethind` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kinokava`
--

INSERT INTO `kinokava` (`kinokavaID`, `kuupaev`, `filmNimetus`, `pilethind`) VALUES
(1, '2020-03-20 16:20:00', 5, 5),
(2, '2020-03-17 20:00:00', 1, 8),
(3, '2020-03-18 13:00:00', 4, 2),
(4, '2020-03-19 20:00:00', 2, 7),
(5, '2020-03-21 21:00:00', 3, 4);

-- --------------------------------------------------------

--
-- Table structure for table `piletimyyk`
--

CREATE TABLE `piletimyyk` (
  `piletimyykID` int(11) NOT NULL,
  `kogus` int(11) NOT NULL,
  `kinokavaID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `piletimyyk`
--

INSERT INTO `piletimyyk` (`piletimyykID`, `kogus`, `kinokavaID`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);

-- --------------------------------------------------------

--
-- Table structure for table `rezisoor`
--

CREATE TABLE `rezisoor` (
  `rezisoorID` int(11) NOT NULL,
  `eesnimi` varchar(25) DEFAULT NULL,
  `perenimi` varchar(25) DEFAULT NULL,
  `birthdate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rezisoor`
--

INSERT INTO `rezisoor` (`rezisoorID`, `eesnimi`, `perenimi`, `birthdate`) VALUES
(1, 'Quentin', 'Tarantino', NULL),
(2, 'Sarik', ' Andreasyan', NULL),
(3, 'Svetlana', 'Baskova', NULL),
(4, 'Michael', 'Bay', NULL),
(5, 'Guy', 'Richi', NULL),
(6, 'Woody', 'Allen', NULL),
(7, 'Chris', 'Columbus', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `zanr`
--

CREATE TABLE `zanr` (
  `zanrID` int(11) NOT NULL,
  `zanrNimi` varchar(25) NOT NULL,
  `zanrKirjeldus` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `zanr`
--

INSERT INTO `zanr` (`zanrID`, `zanrNimi`, `zanrKirjeldus`) VALUES
(1, 'Draama', 'Tõsise teema, sisu, ainestiku ja süžeega, realistlikus elu- ja tegevuskeskkonnas ning usutavates elusituatsioonides tegutsevate realistlike tegelastega lavastatud filmiteos, mis on rajatud filmikangelaste (aktiivsele) suhtlemisele, tegevusele, karakterite muutumisele ja arengule. Tavaliselt ei kasutata filmiefekte, komöödia- või märulielemente. Väga levinud filmižanr, mille peamised alaliigid on melodraama, ajalooline (eepiline) draama, romantiline draama ja elulooline film, mida on käesolevas loendis käsitletud eraldiseisvate kategooriatena.'),
(2, 'Fantaasia', 'Žanr, milles toimub või kujundatud midagi ebareaalne elus.'),
(4, 'Komöödia', 'Komöödiafilm on enamasti kergema sisu ja tahtlikult meelelahutusliku, publikut lõbustava, lõõgastava ja naerma ajava eesmärgiga tehtud filmiteos rõhutatult, liialdatult ja ülemäärase situatsioonilahenduse, keelekasutuse, tegevuse, suhete ja karakteritega.'),
(5, 'Krimi', 'Krimi- ja gangsterfilmide tegevus hargneb kriminaalkurjategijate, kuritegelike jõukude ja sündikaatide, enamasti pangaröövlite, allmaailma tegelaste ja pättide ümber, kes tegutsevad väljaspool seadust, tegelevad narkootikumidega, võitlevad omavahel, varastavad ja tapavad. Film keskendub enamasti kurjategijate mõttemaailmale, ambitsioonidele, suurusehullustusele ja kompleksidele, mis lõpuks viivad nende hukkumiseni. Sageli liigitatakse need krimifilme sarnasuse tõttu ka film noir või detektiiv/uurijafilmideks. Sellesse kategooriasse peaks paigutama ka filmid sarimõrvaritest. Sageli soovitatakse kasutada (kui võimalik) spetsiifilisemad žanrimääratlusi: röövlifilm, film noir, gangsterifilm, uurijafilm, politseifilm või põnevusfilm '),
(6, 'Müsteerium', 'Detektiiv/uurijafilmi peetakse tavaliselt kriminaalfilmi (krimifilmi), film noir või põnevusfilmi (põneviku) alaliigiks. Film põhineb enamasti lahendamata mõrva või kadumise loo uurimisele, filmi peategelaseks on tugeva ja omapärase karakteri ja tegutsemisviisiga detektiiv-uurija, kes tegutseb metoodiliselt ja sihikindlalt kurjategija või mõrvari tabamiseks.'),
(7, 'Õudus', 'Filmilavastused, mis tegelevad elu varjatud, tundmatu, keelatud, üleloomuliku või seletamatu poolega, kutsuvad esile varjatud alateadvuslikku pinget, kartust, hirmutunnet või õudust, millel on reeglina hirmus või šokeeriv lõpplahendus, kuid mis samal ajal köidavad vaatajat ja lahutavad meelt siduva vaatamispinge tekitamise, kaasaelamise ja tugeva läbielamise (katarsise) kaudu. Filmide stilistika on mitmekesine, ulatudes õudusfilmide klassikast (Nosferatu) kuni arvutites loodud üleloomulike lugudeni. Õudusfilmides tegutsevad kummitused, vaimud, libahundid, zombid, vampiirid, saatanad, monstrumid.   Nüüdisajal on õudusfilmi žanr sageli kombineeritud ulmefilmiga, kus monstrumeid sünnitab tehnoloogiline viga, väärkäsitlus, võimu-, raha- või kättemaksiha, korruptsioon või Maad ohustavad tulnukad. Õudusfilmides võib leida sarnaseid elemente muinasjuttfilmide ja üleloomulikele nähtustele rajatud filmidega. Õudusfilmidel on mitmeid alaliike: filmid lõikujatest, sarimõrvaritest, noorteõudukad, satanismifilmid, Dracula, Frankenstein jm. Vajadusel tuleks kasutada lisamääranguid (sagedasemad Ulmefilm, Üleloomulik film).         '),
(8, 'Thriller', 'Põnevusfilmid on enamasti žanrihübriidid – esineb märulipõnevik (Action-Thriller), krimipõnevik (Crime-Caper-Thriller), vesternipõnevik (Western-Thriller), film noir põnevik, isegi romantilise komöödia põnevik (Romantic comedy-Thriller). Põnevikud on lähedalt seotud õudusfilmižanriga. Põnevikud haaravad sellega, et kutsuvad esile intensiivse erutuse, pakuvad põnevust ja kaasaelamisvõimalust, tekitavad rahutut ootust ja närvesöövat pinget. Põnevikud on sageli seotud krimiteemaga, ent põhirõhk ei ole detektiividel, gangsteritel, röövlitel, isegi krimiaktil mitte. Selle asemel fokuseerub narratiiv põnevusel, mis tuleneb sellest, et indiviid või grupp tegelasi on ohtlikkus olukorras, millest pääsemine sõltub juhuslikust saatuse pöördest. Sageli on filmiteemaks poliitiline vandenõu, terrorism, süütu süüdistatava põgenemine, mõrvani viiv armukolmnurk, psüühikahäiretega tegelased.'),
(9, 'Seiklus', 'Enamasti köitvad filmilavastused eksootilistes paikades, seotud uue kogemuse ja tundmatu avastamisega, sageli sarnane märuližanriga. Tegutsevad uljad ja julged inimesed, tegemist võib olla eepilistele ja ajaloolistele filmidele omaste lahendustega (kus kangelased on sageli julged, altruistlikud, patriootilised inimesed, kes tegutsevad oma ideaalide nimel), kadunud kontinentide otsimise, džungli- ja kõrbefilmidega, aaretejahiga, katastroofide, otsingute ja avastamisega, võitlusega vabaduse eest ja vallutajate vastu, püüdega aidata taastada õiglust ja mõistlikku ühiskonnakorraldust jms.   LOC žanrinimistu: seotud sisu- ja žanrikategooriad: seiklusfilm, antiikmaailma film, loomafilm, lennundusaineline film, röövlifilm, krimifilm, katastrooffilm, spioonifilm, muinasjuttfilm, gangsterifilm, džunglifilm, võitluskunstide film, uurijafilm, politseifilm, eelajalooline film, vanglafilm, ulmefilm, laulev kauboi, spordifilm, ellujäämise film, õudusfilm, sõjafilm, vestern. '),
(10, 'Action', 'Aktiivse, enamasti katkematu tegevusega, paljude kaskadöörinippidega filmid, tagaajamise ja jälitamisega, võitluse, päästeaktsioonide, lahingute, põgenemiste, kriiside ja katastroofidega (üleujutused, plahvatused, loodusõnnetused), võitluskunste kasutavad, seikluslikud, köitva rütmi ja tempoga ning vastuoluliste positiivsete kangelastega, kes võitlevad halbade vastu. Loodud ennekõike vaataja köitmise ja meelelahutuse eesmärgil. ');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `country`
--
ALTER TABLE `country`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `film`
--
ALTER TABLE `film`
  ADD PRIMARY KEY (`filmID`),
  ADD KEY `zanr_fk` (`zanrID`),
  ADD KEY `rezisor_fk` (`rezisorID`),
  ADD KEY `filmtype_fk` (`filmtypeID`),
  ADD KEY `keel_fk` (`keelID`);

--
-- Indexes for table `filmtype`
--
ALTER TABLE `filmtype`
  ADD PRIMARY KEY (`filmTypeID`);

--
-- Indexes for table `keel`
--
ALTER TABLE `keel`
  ADD PRIMARY KEY (`keelID`);

--
-- Indexes for table `kinokava`
--
ALTER TABLE `kinokava`
  ADD PRIMARY KEY (`kinokavaID`),
  ADD KEY `film_fk` (`filmNimetus`);

--
-- Indexes for table `piletimyyk`
--
ALTER TABLE `piletimyyk`
  ADD PRIMARY KEY (`piletimyykID`),
  ADD KEY `kinokava_fk` (`kinokavaID`);

--
-- Indexes for table `rezisoor`
--
ALTER TABLE `rezisoor`
  ADD PRIMARY KEY (`rezisoorID`);

--
-- Indexes for table `zanr`
--
ALTER TABLE `zanr`
  ADD PRIMARY KEY (`zanrID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `country`
--
ALTER TABLE `country`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `film`
--
ALTER TABLE `film`
  MODIFY `filmID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `filmtype`
--
ALTER TABLE `filmtype`
  MODIFY `filmTypeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `keel`
--
ALTER TABLE `keel`
  MODIFY `keelID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `kinokava`
--
ALTER TABLE `kinokava`
  MODIFY `kinokavaID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `piletimyyk`
--
ALTER TABLE `piletimyyk`
  MODIFY `piletimyykID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `rezisoor`
--
ALTER TABLE `rezisoor`
  MODIFY `rezisoorID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `zanr`
--
ALTER TABLE `zanr`
  MODIFY `zanrID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `film`
--
ALTER TABLE `film`
  ADD CONSTRAINT `filmtype_fk` FOREIGN KEY (`filmtypeID`) REFERENCES `filmtype` (`filmTypeID`),
  ADD CONSTRAINT `keel_fk` FOREIGN KEY (`keelID`) REFERENCES `keel` (`keelID`),
  ADD CONSTRAINT `rezisor_fk` FOREIGN KEY (`rezisorID`) REFERENCES `rezisoor` (`rezisoorID`),
  ADD CONSTRAINT `zanr_fk` FOREIGN KEY (`zanrID`) REFERENCES `zanr` (`zanrID`);

--
-- Constraints for table `kinokava`
--
ALTER TABLE `kinokava`
  ADD CONSTRAINT `film_fk` FOREIGN KEY (`filmNimetus`) REFERENCES `film` (`filmID`);

--
-- Constraints for table `piletimyyk`
--
ALTER TABLE `piletimyyk`
  ADD CONSTRAINT `kinokava_fk` FOREIGN KEY (`kinokavaID`) REFERENCES `kinokava` (`kinokavaID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
