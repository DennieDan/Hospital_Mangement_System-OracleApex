-- Please execute this file on MySQL Workbench 8.0 or later

CREATE DATABASE no1;
USE no1;
SET FOREIGN_KEY_CHECKS = 0; -- Do not check foreign key constraints
DROP TABLE IF EXISTS EMPLOYEE;
DROP TABLE IF EXISTS SHIFT;
DROP TABLE IF EXISTS ON_SHIFT;
DROP TABLE IF EXISTS DEPARTMENT;
DROP TABLE IF EXISTS PATIENT;
DROP TABLE IF EXISTS MEDICINE;
DROP TABLE IF EXISTS APPOINTMENT;
DROP TABLE IF EXISTS PRESCRIPTION;
DROP TABLE IF EXISTS TREATMENT;
DROP TABLE IF EXISTS BILL;
DROP TABLE IF EXISTS ADMISSION;
DROP TABLE IF EXISTS EMPLOYEE_ACCOUNT;
DROP TABLE IF EXISTS PATIENT_ACCOUNT;
DROP TABLE IF EXISTS ROOM;
-- ---------------------------------------------------
DROP TABLE IF EXISTS UNDERGOES;
DROP TABLE IF EXISTS ADMISSION_ROOM;
DROP TABLE IF EXISTS TREATMENT_ROOM;
DROP TABLE IF EXISTS TAKE_MEDICINE;
SET FOREIGN_KEY_CHECKS = 1;

-- Create DEPARTMENT table
CREATE TABLE DEPARTMENT (
	DID VARCHAR(3) NOT NULL,
		primary key (DID),
    NAME VARCHAR(100) UNIQUE NOT NULL,
    CHIEF VARCHAR(4)
);

-- Create EMPLOYEE table
CREATE TABLE EMPLOYEE (
	EID VARCHAR(4) not null primary key,
    SSN varchar(12) unique not null,
    NAME varchar(100) not null,
    GENDER char default 'M',
    DATEOFBIRTH date not null,
    PHONE varchar(12),
    EMAIL varchar(50) unique not null,
    ADDRESS varchar (200),
    DEPARTMENT varchar(3) references DEPARTMENT(DID) on delete set null, -- if the department is deleted from DEPARTMENT, set the department column NULL
    POSITION varchar(10) not null,
    STARTDATE date not null,
    ENDDATE date,
    DETAILS varchar(200),
    constraint chk_gender check (GENDER in ('F', 'M')),
    constraint chk_position check (POSITION in ('Doctor', 'Nurse', 'Ward boy', 'Pharmacist', 'Officer', 'Technician'))
);

-- trigger: employee must be older than 18
DELIMITER $$
CREATE TRIGGER tg_age
BEFORE INSERT
ON EMPLOYEE
FOR EACH ROW
BEGIN
	IF DATEDIFF(CURDATE(), NEW.DATEOFBIRTH) <= 18
    THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'An employee must be an adult (older than 18 years old)';
	END IF;
END $$
DELIMITER ;

-- insert data for DEPARTMENT
INSERT INTO DEPARTMENT VALUES ('d01', 'Pharmacy Department', 'e029'),
							('d02', 'Department Reproduction and Pediatrics', 'e013'),
							('d03', 'Demartology', 'e028'),
                            ('d04', 'Resuscitation - Emergency Department', 'e021'),
                            ('d05', 'Oncology - Radiotherapy', 'e002'),
                            ('d06', 'Cardiology', 'e041'),
                            ('d07', 'Department of Internal Neurology', 'e008'),
                            ('d08', 'Department of Thoracic Surgery', 'e027');

-- insert data for EMPLOYEE (80 employees)
INSERT INTO EMPLOYEE VALUES ('e001', '380-398-901', 'Nicole Root', 'M', '1986-06-21', '928-354-3630', 'employee@dayrep.com', '356 Tree Frog Lane Rushville, MO 64484', 'd08', 'Doctor', '2001-06-21', NULL, 'Professor, Ph.D, MD');
INSERT INTO EMPLOYEE VALUES ('e002','099-278-482','Melvin Cameron','M','1991-05-24 00:00:00','530-816-7686','SandraJWelch@armyspy.com','206 Byers Lane, Susanville, CA 96130','d05','Doctor','2015-03-16 00:00:00',NULL,'Senior Consultant'),
							('e003','389-382-112','Celina Nelson','F','1995-01-12 00:00:00','940-585-5481','GuyWCausby@jourrapide.com','2362 Olen Thomas Drive, Cee Vee, TX 79223','d01','Pharmacist','2017-09-25 00:00:00',NULL,'Ph.D, MD'),
							('e004','382-189-281','Alyssa Bond','F','1985-04-03 00:00:00','617-517-4432','LiliaJHatfield@dayrep.com','4420 Hinkle Lake Road, Boston, MA 02110','d05','Ward boy','2017-09-25 00:00:00',NULL,'Associate Professor, Bachelor'),
							('e005','234-918-992','Claire Hampton','F','1977-07-03 00:00:00','248-680-6129','CarolynMMatsumura@dayrep.com','4568 Cunningham Court, Troy, MI 48083','d04','Officer','1990-01-18 00:00:00',NULL,NULL),
							('e006','389-094-392','Bradford Gay','M','1973-12-24 00:00:00','310-420-3704','FaithGGrady@rhyta.com','4511 Doctors Drive, Mira Loma, CA 91752','d07','Nurse','1990-01-18 00:00:00',NULL,'MSc, MD'),
							('e007','382-443-783','Bud Holland','M','1976-06-06 00:00:00','260-804-7260','MarieCPeterson@rhyta.com','968 Pearcy Avenue, Fort Wayne, IN 46802','d03','Nurse','1990-01-18 00:00:00',NULL,'Associate Professor, MD'),
							('e008','782-473-112','Noemi Bowman','M','1987-10-27 00:00:00','208-526-3547','PhillipSHall@teleworm.us','1130 Young Road, Idaho Falls, ID 83402','d07','Doctor','1995-02-16 00:00:00',NULL,'MSc, Specialist Level 2 Doctor'),
							('e009','234-232-899','Janis Fisher','F','1960-08-08 00:00:00','713-761-0747','SherylRDixon@armyspy.com','1655 Michael Street, Sugar Land, TX 77478','d08','Technician','2005-08-30 00:00:00',NULL,'Bachelor'),
							('e010','489-344-882','Lora Joyce','M','1973-09-27 00:00:00','781-832-9507','MarvinTJackson@teleworm.us','3575 Hillcrest Avenue, Acton, MA 01720','d05','Doctor','2015-03-16 00:00:00',NULL,'Professor, Specialist Level 2 Doctor'),
							('e011','298-463-892','Pam Costa','M','1993-11-29 00:00:00','559-224-9924','DellaCKnapp@dayrep.com','3105 Edgewood Avenue, Fresno, CA 93704','d08','Ward boy','2004-12-12 00:00:00',NULL,'Associate Professor, Ph.D'),
							('e012','298-938-265','Cleo Cole','M','1966-04-11 00:00:00','502-532-7871','BenjaminBLassiter@dayrep.com','4447 Gregory Lane, Campbellsburg, KY 40011','d07','Nurse','2004-12-12 00:00:00',NULL,'Senior Consultant'),
							('e013','783-231-446','Tricia Dyer','F','1969-11-25 00:00:00','718-755-1470','FrederickPShuler@armyspy.com','4946 Anmoore Road, Huntington, NY 11743','d02','Doctor','2002-10-11 00:00:00',NULL,'Specialist Level 2 Doctor'),
							('e014','289-903-331','Mack Mueller','M','1959-04-11 00:00:00','425-398-3873','LynetteSStjohn@jourrapide.com','2554 Conifer Drive, Bothell, WA 98021','d04','Officer','2004-12-12 00:00:00',NULL,NULL),
							('e015','289090343','Kelli Hendrix','F','1967-08-11 00:00:00','570-221-2922','ArturoVWilson@armyspy.com','1510 Carriage Lane, Elysburg, PA 17824','d06','Officer','2004-12-13 00:00:00',NULL,NULL),
							('e016','934389822','Claud Mora','F','1990-07-25 00:00:00','386-383-1146','MargaretWLatham@teleworm.us','1276 Willis Avenue, Daytona Beach, FL 32114','d05','Nurse','2004-12-14 00:00:00',NULL,'Ph.D, MD'),
							('e017','473783999','Jeanine Adkins','F','1991-12-04 00:00:00','213-687-0084','RobertSCampbell@rhyta.com','334 Canis Heights Drive, Los Angeles, CA 90071','d06','Nurse','2004-12-15 00:00:00',NULL,'Professor, MD'),
							('e018','389272333','Isaac Waters','M','1960-04-12 00:00:00','914-407-6926','AmadoMLawson@jourrapide.com','4128 Pallet Street, New York, NY 10011','d03','Doctor','2002-10-11 00:00:00',NULL,'Ph.D, MD'),
							('e019','223892712','Evan Glenn','M','1965-07-31 00:00:00','505-403-2036','SergioBTrowbridge@dayrep.com','2468 Reel Avenuel, Clovis, NM 88101','d04','Doctor','2004-12-12 00:00:00',NULL,'MSc, MD');
INSERT INTO EMPLOYEE VALUES ('e020', '787-392-783', 'Numbers Golden', 'M', '1989-10-21', '206-877-1007', 'RichardKBaity@jourrapide.com', '4245 Raccoon Run, Seattle, WA 98109', 'd01', 'Pharmacist', '1990-01-18', NULL, 'Professor, Ph.D, MD'),
							('e021', '787-283-992','Adriana Blake','F', '1965-01-07','347-920-2747','francisco1985@hotmail.com','573 Bottom Lane Getzville, New York(NY), 14068','d04','Doctor','2002-10-11',NULL,	'Specialist Level 2 Doctor'),
							('e022', '782-361-232',	'Maryellen Soto', 'F',	'1989-10-15',	'980-729-3701',	'domenico1986@hotmail.com',	'4128 Snyder Avenue Charlotte, North Carolina(NC), 28263',	'd08',	'Ward boy',	'1990-01-18',	NULL,	'Associate Professor, MD'),
							('e023',	'099-382-348',	'Florence Dean',	'F',	'1969-08-06',	'269-209-3043',	'nella2000@hotmail.com',	'3383 Reppert Coal Road Bloomfield Township, Michigan(MI), 48302',	'd07',	'Technician',	'2017-09-25',	NULL,	'Associate Professor, Bachelor'),
							('e024',	'746-323-441',	'Brendon Vang',	'M',	'1969-12-04',	'336-681-8156',	'chadrick1991@hotmail.com',	'911 Havanna Street Greensboro, North Carolina(NC), 27407',	'd01',	'Pharmacist',	'2002-10-11',	NULL,	'Professor, Ph.D, MD'),
							('e025',	'993-734-532',	'Jaime Christensen', 'F',	'1995-12-15',	'414-201-8725',	'lukas.hoege0@yahoo.com',	'1050 Mercer Street Appleton, Wisconsin(WI), 54913',	'd02',	'Nurse',	'1995-12-15',	NULL,	'Senior Consultant'),
							('e026',	'783-726-321',	'Antone Parsons',	'M',	'1994-03-01',	'505-787-2541',	'ward2014@gmail.com',	'1880 Reel Avenue Fort Sumner, New Mexico(NM), 88119',	'd03',	'Ward boy',	'2011-09-23',	NULL,	'Bachelor'),
							('e027',	'847-836-372',	'Guadalupe Guerrero',	'M',	'1978-03-15',	'605-202-6047',	'sabina1981@gmail.com',	'2400 Elsie Drive Vermillion, South Dakota(SD), 57069',	'd08',	'Doctor',	'2002-10-11',	NULL,	'Professor, Ph.D, MD'),
							('e028',	'784-636-523',	'Bobbie David',	'M',	'1972-01-30',	'601-434-6549',	'kenya1970@yahoo.com',	'4074 Reppert Coal Road Mount Olive, Mississippi(MS), 39119',	'd03',	'Doctor',	'2005-08-30',	NULL,	'MSc, Specialist Level 2 Doctor'),
							('e029',	'980-082-736',	'Randall Heath',	'F',	'1992-11-14',	'503-647-6344',	'ena1995@yahoo.com',	'4184 Godfrey Street North Plains, Oregon(OR), 97133',	'd01',	'Pharmacist',	'2017-09-25'	,NULL,	'Professor, Ph.D, MD'),
							('e030',	'673-214-644',	'Gale King',	'M',	'1971-02-23',	'916-533-0956',	'rylan.ritch@yahoo.com',	'1771 Alexander Avenue Concord, California(CA), 94520',	'd01',	'Officer',	'1990-01-18',	NULL,	''),
							('e031',	'894-362-735',	'Rickie Miller',	'M',	'1984-06-27',	'517-290-6016',	'carmella_donnel@gmail.com',	'150 John Avenue Lansing, Michigan(MI), 48911',	'd03',	'Ward boy',	'1990-01-18',	NULL,	'Bachelor'),
							('e032',	'738-462-735',	'Arlen Buchanan',	'M',	'1986-10-07',	'917-335-3060',	'sienna.kloc@hotmail.com',	'577 Shinn Street New York, New York(NY), 10022',	'd02',	'Ward boy',	'1990-01-18',	NULL,	'Bachelor'),
							('e033',	'382-938-473',	'Markus Patterson',	'F',	'1994-05-22',	'210-998-7338',	'maudie1972@yahoo.com',	'4800 Richland Avenue Valley Lodge, Texas(TX), 77020',	'd04',	'Ward boy',	'2017-09-25',	NULL,	'Bachelor'),
							('e034',	'364-625-143',	'Isabella Park',	'F',	'1986-07-21',	'615-401-8470',	'delaney1992@gmail.com',	'1058 Buffalo Creek Road Nashville, Tennessee(TN), 37201',	'd04',	'Ward boy',	'1990-01-18',	NULL,	'Bachelor'),
							('e035',	'768-353-625',	'John Cooke',	'M',	'1970-11-27',	'708-641-2214',	'hal1976@yahoo.com',	'99 Bingamon Branch Road Winnetka, Illinois(IL), 60093',	'd03',	'Nurse',	'1990-01-18',	NULL,	'Professor, Ph.D'),
							('e036',	'082-746-279',	'Whitney Arroyo',	'M',	'1990-11-26',	'347-380-7844',	'coty19731982@gmail.com',	'1806 Plainfield Avenue White Plains, New York(NY), 10601',	'd07',	'Nurse',	'2017-09-25',	NULL,	'Associate Professor, Bachelor'),
							('e037',	'037-282-912',	'Cyril Jones',	'M',	'1973-10-27',	'651-238-6951',	'ellsworth1970@hotmail.com',	'3767 Pineview Drive Winnebago, Minnesota(MN), 56098',	'd06',	'Nurse',	'1990-01-18',	NULL,	'Associate Professor, Bachelor'),
							('e038',	'849-372-734',	'Laurel Dorsey',	'F',	'1973-07-01',	'832-205-9764',	'lenore_schust@hotmail.com',	'349 Wines Lane Houston, Texas(TX), 77040',	'd07',	'Doctor',	'1990-01-18',	NULL,	'Professor, Ph.D, MD'),
							('e039',	'839-392-820',	'Trina Greer',	'F',	'1980-01-05',	'573-821-2553',	'eve2001@hotmail.com',	'4186 Penn Street Jefferson City, Missouri(MO), 65109',	'd05',	'Nurse',	'1990-01-18',	NULL,	'Bachelor'),
							('e040',	'036-728-456',	'Colleen Kim',	'M',	'1966-05-27',	'724-504-0437',	'lauren_yund7@yahoo.com',	'2613 Pine Street Butler, Pennsylvania(PA), 16001',	'd06',	'Doctor',	'2005-08-30',	NULL,	'Professor, Ph.D, MD'),
							('e041',	'223-847-673',	'Doreen Garner',	'M',	'1981-11-07',	'620-430-4228',	'odell1999@yahoo.com',	'1911 Roosevelt Road Dodge City, Kansas(KS), 67801',	'd06',	'Doctor',	'1990-01-18',	NULL,	'Specialist Level 2 Doctor'),
							('e042',	'823-576-102',	'Edison Parks',	'M',	'1975-04-22',	'551-358-2861',	'tremaine_leffl@hotmail.com',	'3305 Granville Lane Jersey City, New Jersey(NJ), 07307', 'd07',	'Doctor',	'1990-01-18',	NULL,	'Specialist Level 2 Doctor'),
							('e043',	'078-463-823',	'Gwen Chambers',	'M',	'1956-02-26',	'562-214-7611',	'armand2003@hotmail.com',	'1226 Peck Court Laguna Niguel, California(CA), 92677',	'd03',	'Doctor',	'2017-09-25',	NULL,	'MSc, Specialist Level 2 Doctor'),
							('e044',	'782-361-233',	'Terry Pratt',	'M',	'1995-09-17',	'404-661-7083',	'xzavier.wiega@hotmail.com',	'3420 Flint Street Atlanta, Georgia(GA), 30303',	'd03',	'Officer',	'2017-09-25',	NULL,	''),
							('e045',	'783-829-882',	'Jan Hanson',	'F',	'1996-01-30',	'254-709-7896',	'jasmin1975@hotmail.com',	'1496 Clair Street Waco, Texas(TX), 76706',	'd05',	'Technician',	'2017-09-25',	NULL,	'Associate Professor, Bachelor'),
							('e046',	'782-893-898',	'Clinton Smith',	'M',	'1985-06-06',	'502-419-0528',	'leora1974@yahoo.com',	'102 Cerullo Road Louisville, Kentucky(KY), 40202',	'd07',	'Technician',	'1990-01-18',	NULL,	'Associate Professor, Bachelor'),
							('e047',	'847-384-014',	'Newton Byrd',	'M',	'1985-09-23',	'847-974-8006',	'jaylon_bogisi@hotmail.com',	'3850 Bolman Court East Lynn, Illinois(IL), 60960',	'd02',	'Nurse',	'2012-12-04',	NULL,	'Associate Professor, Bachelor'),
							('e048',	'624-274-045',	'Maura Sampson',	'F',	'1990-08-08',	'904-857-4876',	'kody19831974@gmail.com',	'4005 Brannon Avenue St Augustine, Florida(FL), 32084',	'd02', 'Nurse',	'2012-12-04',	NULL,	'Associate Professor, Bachelor'),
							('e049',	'562-378-373',	'Burl Mclaughlin',	'M',	'1984-08-01',	'573-513-8029',	'garett1982@gmail.com',	'1058 Oak Ridge Drive Stlouis, Missouri(MO), 63101 ',	'd03',	'Doctor',	'1990-03-12'	,NULL,	'Specialist Level 2 Doctor'),
							('e050',	'783-909-821',	'Kennith Vaughn',	'M',	'1979-12-09',	'864-547-5355',	'rachelle1970@yahoo.com',	'527 Traction Street Piedmont, South Carolina(SC), 29673',	'd08',	'Technician',	'1990-01-18',	NULL,	'Associate Professor, Bachelor'),
							('e051',	'728-364-526',	'Darnell Johnston',	'M',	'1973-05-18',	'813-546-9221',	'wilhelmin8@hotmail.com',	'4826 Bernardo Street  Tampa, Florida(FL), 33610',	'd02',	'Doctor',	'1990-03-12',	NULL,	'Specialist Level 2 Doctor'),
							('e052',	'903-723-726',	'Juliette Crosby',	'F',	'1963-02-01',	'409-387-5570',	'lacy.rippi5@gmail.com',	'2087 Brookview Drive Beaumont, Texas(TX), 77701',	'd06',	'Doctor',	'1963-02-01',	NULL,	'MSc, Specialist Level 2 Doctor'),
							('e053',	'647-353-288',	'George Lee',	'M',	'1962-08-13',	'607-339-8450',	'katlyn1993@yahoo.com',	'2423 Cliffside Drive Syracuse, New York(NY), 13206',	'd07',	'Doctor',	'2011-04-07',	NULL,	'Specialist Level 2 Doctor'),
							('e054',	'746-379-231',	'Jamison Mays',	'F',	'1979-06-09',	'847-612-8552',	'sally2002@gmail.com',	'22 Simpson Street East Moline, Illinois(IL), 61244',	'd08',	'Doctor',	'1990-03-12',	NULL,	'MSc, Specialist Level 2 Doctor'),
							('e055',	'837-475-622',	'Celeste Grant',	'M',	'1986-11-01',	'347-585-5525',	'kendrick.durg@gmail.com',	'4232 Duncan Avenue Whitestone, New York(NY), 11357',	'd08',	'Nurse',	'2011-04-07',	NULL,	'Associate Professor, Bachelor'),
							('e056',	'474-277-461',	'Sam Erickson',	'M',	'1988-08-14',	'408-229-3176',	'leonel1998@yahoo.com',	'1054 Hide A Way Road San Jose, California(CA), 95136',	'd04',	'Ward boy',	'2011-04-07',	NULL,	'Associate Professor, Bachelor'),
							('e057',	'344-552-721',	'Kirsten Wilcox',	'F',	'1991-11-01',	'857-247-4034',	'elsa_schult1@yahoo.com',	'2668 Aspen Court Boston, Massachusetts(MA), 02115',	'd04',	'Ward boy',	'2011-04-07',	NULL,	'Associate Professor, Bachelor'),
							('e058',	'024-483-712',	'Violet Rosario',	'F',	'1962-06-09',	'615-210-8761',	'dannie1996@hotmail.com',	'4403 Frum Street Nashville, Tennessee(TN), 37212',	'd05',	'Doctor',	'2005-08-30',	NULL,	'MSc, MD'),
							('e059',	'893-647-352',	'Dominique Mcdowell',	'M',	'1985-04-11',	'615-242-4545',	'ursula_ku6@hotmail.com',	'2257 McDowell Street Nashville, Tennessee(TN), 37238',	'd02',	'Ward boy',	'2011-09-23',	NULL,	'Associate Professor, Bachelor'),
							('e060',	'483-774-898',	'Samual Frey',	'M',	'1994-03-11',	'469-453-1755',	'josiah.mora2@yahoo.com',	'3992 Stoney Lane Dallas, Texas(TX), 75207',	'd08',	'Ward boy',	'2011-09-23',	NULL,	'Associate Professor, Bachelor'),
							('e061',	'900-846-355',	'Abel Lutz',	'M', '1994-04-27',	'301-917-8668',	'jaclyn_strac@hotmail.com',	'3365 Del Dew Drive Lanham, Maryland(MD), 20706',	'd04',	'Nurse',	'2011-09-23',	NULL,	'Professor, Bachelor'),
							('e062',	'788-463-565',	'Mai Haley',	'M',	'1986-04-01',	'276-664-3778',	'kenneth_sip@hotmail.com',	'1067 Douglas Dairy Road Johnson City, Virginia(VA), 37601',	'd04',	'Nurse',	'2011-09-23',	NULL,	'Professor, Bachelor'),
							('e063',	'038-273-622',	'Jon Lang',	'M',	'1993-05-28',	'740-756-0648',	'elenor.mora@hotmail.com',	'3166 Viking Drive Carroll, Ohio(OH), 43112',	'd07',	'Ward boy',	'2011-09-23',	NULL,	'Associate Professor, Bachelor'),
							('e064',	'787-566-454',	'Noemi Kline',	'F',	'1961-01-21',	'703-234-2536',	'henri1988@gmail.com',	'3039 Lawman Avenue Washington, Virginia(VA), 20004',	'd05',	'Officer',	'2011-09-23',	NULL,	''),
							('e065',	'895-867-888',	'Jeannine Leonard',	'F',	'1984-09-18',	'770-333-2356',	'jayson.abern@yahoo.com',	'1711 Neuport Lane Smyrna, Georgia(GA), 30080',	'd07',	'Officer',	'2011-09-23',	NULL,	''),
							('e066',    '859-889-887',	'Lloyd Morrow',	'M'	,'1964-04-03',	'703-762-1490',	'nickolas1979@gmail.com',	'3780 Perine Street Mclean, Virginia(VA), 22101',	'd01',	'Pharmacist',	'2002-10-11',	NULL,	'Ph.D, MD'),
							('e067',	'232-221-348',	'Willy Wilson',	'M',	'1974-07-21',	'979-587-6213',	'earlene.blo@gmail.com'	,'3944 Franklin Avenue Bloomington, Texas(TX), 77951',	'd01',	'Pharmacist',	'2005-08-30',	NULL,	'Ph.D, MD'),
							('e068',	'848-476-754',	'Carolyn Hughes',	'F',	'1959-03-01',	'612-629-6512',	'elmer2012@yahoo.com',	'3675 Jewell Road Minneapolis, Minnesota(MN), 55402',	'd01',	'Pharmacist',	'2011-04-07',	NULL,	'Professor, Ph.D, MD'),
							('e069',	'544-785-633',	'Jerome Parks',	'F',	'1972-12-28',	'636-753-2741',	'samir2015@gmail.com',	'4508 Court Street Portage Des Sioux, Missouri(MO), 63373',	'd03',	'Nurse',	'2002-10-11',	NULL,	'Associate Professor, Bachelor'),
							('e070',	'098-957-880',	'Harriett Suarez',	'M',	'1985-07-09',	'630-429-9645',	'jarrod1973@yahoo.com',	'460 Hickman Street Chicago, Illinois(IL), 60606',	'd06',	'Ward boy',	'1990-01-18',	NULL,	'Associate Professor, Bachelor'),
							('e071',	'878-499-372',	'Archie Lozano',	'M',	'1980-04-20',	'786-230-7844',	'deja2014@yahoo.com',	'697 Drainer Avenue Milton, Florida(FL), 32570',	'd08',	'Officer',	'1990-01-18',	NULL,	''),
							('e072',	'084-733-133',	'Herbert Thompson',	'M',	'1973-01-31',	'770-601-3445',	'theodore_jacobs@yahoo.com',	'3334 Layman Court Winder, Georgia(GA), 30680',	'd02',	'Officer',	'2005-08-30',	NULL,	''),
							('e073',	'787-466-212',	'Louella Webb',	'F',	'1989-04-08',	'347-863-9034',	'imani_kuhl9@yahoo.com','596 Old Dear Lane Wingdale, New York(NY), 12594',	'd01', 'Officer',	'1990-01-18',	NULL,	''),
							('e074',	'899-848-700',	'Hassan Brennan',	'M',	'1986-11-18',	'860-917-5326',	'uriah1976@yahoo.com',	'2018 Airplane Avenue Norwich, Connecticut(CT), 06360',	'd06',	'Ward boy',	'1990-01-18',	NULL,	'Professor, Bachelor'),
							('e075',	'078-775-655',	'Roland Peck',	'M',	'1957-12-26',	'334-552-3702',	'meredith1982@gmail.com',	'4172 Wright Court Cahaba Heights, Alabama(AL), 35242',	'd03',	'Nurse',	'2011-09-23',	NULL,	'Professor, Bachelor'),
							('e076',	'839-445-367',	'Catalina Garrison',	'F',	'1958-11-09',	'601-291-3658',	'brenda.webe5@gmail.com',	'967 Brownton Road Jackson, Mississippi(MS), 39201',	'd02',	'Nurse',	'2011-09-23',	NULL,	'Professor, Bachelor'),
							('e077',	'774-346-765',	'Darin Beard',	'M',	'1991-05-31',	'518-894-7752',	'leon.wucker8@gmail.com',	'365 West Virginia Avenue Albany, New York(NY), 12207',	'd02',	'Ward boy',	'2011-09-23',	NULL,	'Associate Professor, Bachelor'),
							('e078',	'089-885-764',	'Brady Barr',	'M',	'1995-12-17',	'775-847-4782',	'pablo1996@hotmail.com',	'3553 Wescam Court Virginia City, Nevada(NV), 89440',	'd04',	'Ward boy',	'2011-09-23',	NULL,	'Associate Professor, Bachelor'),
							('e079',	'012-112-632',	'Donald Moore',	'M',	'1956-12-22',	'908-814-4099',	'conor_bin1@gmail.com',	'602 Beechwood Avenue Piscataway, New Jersey(NJ), 08854',	'd08',	'Doctor',	'2011-09-23',	NULL,	'Professor, Ph.D, MD'),
							('e080',	'078-887-677',	'Selena Navarro',	'F',	'1955-10-17',	'760-677-5201',	'harmon_beie4@hotmail.com',	'3418 Coleman Avenue Boron, California(CA), 93516',	'd05',	'Doctor',	'1990-03-12',	NULL,	'Professor, Ph.D, MD');


-- reference CHIEF of DEPARTMENT
ALTER TABLE DEPARTMENT
ADD FOREIGN KEY (CHIEF) REFERENCES EMPLOYEE(EID) on delete set null; -- when the chief is deleted from EMPLOYEE table, set chief to NULL

-- create PATIENT table
CREATE TABLE PATIENT (
	PID varchar(4) not null,
		primary key (PID),
    SSN varchar(12) unique not null,
    NAME varchar(100) not null,
    GENDER char default 'M',
    DATEOFBIRTH date not null,
    PHONE varchar(12),
    EMAIL varchar(50),
    ADDRESS varchar(200),
    NOTATION varchar(200),
    constraint chk_gender_patient check (GENDER in ('F', 'M')) -- either 'F' and 'M' must be inserted in this field
);

-- insert data for PATIENT
INSERT INTO PATIENT VALUES ('p001', '909-339-988', 'Thomas Ngo', 'M', '1990-09-23', '706-323-0278', 'ngo.tom123@hotmail.com', '495 Grove Street, New York(NY)', NULL),
							('p002', '434-854-234', 'Joseph Dixon', 'M', '1975-04-06', '384-687-1922', 'joseph1994@hotmail.com', '2930 Franklin Street, Eufaula, Alabama', 'Hearing impairment'),
                            ('p003', '430-028-541', 'Mary Wright', 'F', '1952-11-18', '954-209-4777', 'mary2011@yahoo.com', '2334 Oral Lake Road, Shakopee, Minnesota', NULL),
                            ('p004', '433-232-009', 'Oscar J Moore', 'M', '1988-09-08', '708-343-3245', 'terdan_ardm@hotmail.com', '2017 Jail Drive, Bloomington, Illinois(IL)', NULL),
                            ('p005', '667-483-898', 'Edward T Brady', 'M', '1997-12-06', '708-254-8212', 'wilber1997@hotmail.com', '4705 John Calvin Drive, Schaumburg, Illinois', NULL),
                            ('p006', '894-000-334', 'Sharon K Lazzaro', 'F', '1989-06-20', '617-090-4432', 'kaley1999@gmail.com', '4684 Gerald L. Bates Drive, Cambridge, Massachusetts', NULL),
                            ('p007', '776-937-222', 'Marcie G Milan', 'F', '2001-04-14', '512-201-8981', 'skye2001@gmail.com', '2112 Sundown Lane, Austin, Texas', NULL),
                            ('p008', '430-289-239', 'Ruby Q Hill', 'F', '1990-03-31', '478-208-4581', 'rubyhill2001@hotmail.com', '2211 White Lane, Hawkinsville, Georgia (GA), 31036', NULL),
                            ('p009', '578-332-948', 'Matthew M Miller', 'M', '2013-08-09', '317-192-8988', 'mat231@gmail.com', '496 Sugarfoot Lane, Crawfordsville, Indiana(IN), 47933', NULL),
                            ('p010', '454-232-243', 'Darcy Dove', 'F', '1969-04-25', '305-201-7798', 'lowell2504@hotmail.com', '1369 Foley Street, Fortlauderdale, Florida(FL), 33306', NULL),
                            ('p011', '787-233-123', 'Robert Kemphill', 'M', '1983-09-12', '456-409-0449', 'flavie2008@gmail.com', '2244 Coolidge Street, Helena, Montana(MT), 59601', NULL);

-- create EMPLOYEE_ACCOUNT table					
CREATE TABLE EMPLOYEE_ACCOUNT (
	EID varchar(4) unique not null references EMPLOYEE(EID), -- if the employee is deleted, delete their account as well
	USERNAME varchar(50) primary key,
    PASSWORD varchar(50) not null
);


-- insert data for EMPLOYEE_ACCOUNT
INSERT INTO EMPLOYEE_ACCOUNT (EID, USERNAME, PASSWORD) VALUES ('e001', 'employee@dayrep.com', '12345'),
																('e002', 'SandraJWelch@armyspy.com', 'wS94G0'),
																('e003', 'GuyWCausby@jourrapide.com', 'p1LK04'),
																('e004', 'LiliaJHatfield@dayrep.com', '61pR5E'),
																('e005', 'CarolynMMatsumura@dayrep.com', '5kU33a'),
																('e006', 'FaithGGrady@rhyta.com', '3Hhm33'),
																('e007', 'MarieCPeterson@rhyta.com', '028Ccw'),
																('e008', 'PhillipSHall@teleworm.us', '6c5Oe7'),
																('e009', 'SherylRDixon@armyspy.com', '1pDs46'),
																('e010', 'MarvinTJackson@teleworm.us', '94a6Mp'),
																('e011', 'DellaCKnapp@dayrep.com', 'uJl919'),
																('e012', 'BenjaminBLassiter@dayrep.com', 'Yo23t3'),
																('e013', 'FrederickPShuler@armyspy.com', 'iM722A'),
																('e014', 'LynetteSStjohn@jourrapide.com', 'xP828N'),
																('e015', 'ArturoVWilson@armyspy.com', '7BHx18'),
																('e016', 'MargaretWLatham@teleworm.us', 'bI689b'),
																('e017', 'RobertSCampbell@rhyta.com', 'dP55i5'),
																('e018', 'AmadoMLawson@jourrapide.com', '25aS7C'),
																('e019', 'SergioBTrowbridge@dayrep.com', 'jC863r');
                                    

-- create PATIENT_ACCOUNT table
CREATE TABLE PATIENT_ACCOUNT (
	PID varchar(4) unique not null, foreign key (PID) references PATIENT(PID) on delete cascade,
	username varchar(50) primary key,
    password varchar(50) not null
);


-- insert data for PATIENT_ACCOUNT
INSERT INTO PATIENT_ACCOUNT (PID, USERNAME, PASSWORD) VALUES ('p001', 'patientuser321', '12321'),
																('p006', 'gohome.now', 'hu8dw1'),
                                                                ('p008', 'lovethe12life', '78@him'),
                                                                ('p010', 'yanynThomas', '9431992'),
                                                                ('p002', 'jimmyandanna', 'oi909'),
                                                                ('p011', 'flymetothemoon', '89321'),
                                                                ('p005', 'edwarddevops', '3i3u'),
                                                                ('p003', 'marymarryme', 'hjh2'),
                                                                ('p009', 'johnydeepfanclub', '8910bas'),
                                                                ('p004', 'oscarwinner', '8981ka$hjs');

-- create ADMIN_ACCOUNT table
CREATE TABLE ADMIN_ACCOUNT (
	username varchar(50) primary key,
    password varchar(50) not null
);

-- insert data into ADMIN_ACCOUNT
INSERT INTO ADMIN_ACCOUNT VALUES ('Admin', 'Admin123');

-- Set time zone to +7 GMT
SET time_zone ='+07:00';

-- create SHIFT table
CREATE TABLE SHIFT (
	SHIFTID VARCHAR(3) not null,
		PRIMARY KEY (SHIFTID),
    STARTTIME timestamp not null,
    ENDTIME timestamp not null,
    check (ENDTIME > STARTTIME)
);

-- insert data for SHIFT
INSERT INTO SHIFT VALUES ('s01', '2024-03-30 00:00', '2024-03-30 08:00'),
						('s02', '2024-04-12 00:45', '2024-04-12 08:45'),
                        ('s03', '2023-10-16 07:30', '2023-10-16 15:30'),
                        ('s04', '2024-03-18 03:30', '2024-03-18 11:30'),
                        ('s05', '2024-01-03 08:15', '2024-01-03 16:15'),
                        ('s06', '2023-12-15 11:30', '2023-12-15 19:30'),
                        ('s07', '2024-01-17 16:30', '2024-01-17 23:30'),
                        ('s08', '2023-10-07 23:30', '2023-11-07 07:30'),
                        ('s09', '2024-03-21 21:45', '2024-03-22 05:45'),
                        ('s10', '2023-11-21 11:45', '2023-11-21 19:45'),
                        ('s11', '2023-07-24 05:45', '2023-07-24 13:45'),
                        ('s12', '2023-10-02 01:30', '2023-10-02 09:30'),
                        ('s13', '2023-10-01 09:00', '2023-10-01 17:00'),
                        ('s14', '2024-02-15 06:00', '2024-02-15 14:00'),
                        ('s15', '2023-07-15 23:30', '2023-07-16 07:30'),
                        ('s16', '2024-02-11 04:45', '2024-02-11 12:45'),
                        ('s17', '2023-11-22 03:00', '2023-11-22 11:00'),
                        ('s18', '2023-06-08 13:00', '2023-06-08 21:00'),
                        ('s19', '2023-10-25 22:00', '2023-10-26 06:00'),
                        ('s20', '2023-07-28 11:00', '2023-07-28 19:00');
                        
-- create ON_SHIFT table
CREATE TABLE ON_SHIFT (
	SHIFT varchar(3) not null, foreign key(SHIFT) references SHIFT(SHIFTID) on delete cascade,
    EMPLOYEE varchar(4) not null, foreign key(EMPLOYEE) references EMPLOYEE(EID) on delete cascade,
		primary key (SHIFT, EMPLOYEE)
);

-- trigger: no overlapping shift for any employee - CHECKED
DELIMITER $$
CREATE TRIGGER tg_shift
BEFORE INSERT ON ON_SHIFT
FOR EACH ROW
BEGIN
	DECLARE newstart, newend TIMESTAMP;
    SELECT STARTTIME, ENDTIME INTO newstart, newend
    FROM SHIFT
    WHERE SHIFT.SHIFTID = NEW.SHIFT;
	IF EXISTS (SELECT O.SHIFT 
				FROM ON_SHIFT O JOIN SHIFT S ON O.SHIFT = S.SHIFTID
				WHERE O.EMPLOYEE = NEW.EMPLOYEE
                AND (newstart BETWEEN S.STARTTIME AND S.ENDTIME
                OR newend BETWEEN S.STARTTIME AND S.ENDTIME))
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Overlapping shifts!!!';
	END IF;
END $$
DELIMITER ;

-- insert data to ON_SHIFT
INSERT INTO ON_SHIFT VALUES ('s01',	'e018'),
							('s01',	'e022'),
							('s01',	'e023'),
							('s01',	'e056'),
							('s02',	'e022'),
							('s02',	'e080'),
							('s03',	'e011'),
							('s03',	'e026'),
							('s04',	'e047'),
							('s05',	'e032'),
							('s05',	'e030'),
							('s06',	'e069'),
							('s06',	'e026'),
							('s06',	'e055'),
							('s07',	'e017'),
							('s07',	'e062'),
							('s08',	'e021'),
							('s08',	'e003'),
							('s09',	'e010');
                            
-- for CHECKING trigger tg_shift
-- INSERT INTO SHIFT VALUES ('s21', '2023-07-28 15:00', '2024-03-30 23:00');
-- INSERT INTO ON_SHIFT VALUES ('s20', 'e018');
-- INSERT INTO ON_SHIFT VALUES ('s21', 'e018');

-- create MEDICINE table
CREATE TABLE MEDICINE (
	ID varchar(3) not null,
		primary key (ID),
    NAME varchar(30) unique not null,
    BRAND varchar(30),
    SUPPLIER varchar(30),
    ORIGIN varchar(15),
    DURATION date,
    STOCK int not null, 
    PRICE decimal(9,3)
);

-- insert data for MEDICINE
INSERT INTO MEDICINE VALUES ('m01', 'Gluapirin', 'Neosporin', 'Meds Manor', 'US', '2034-06-07', '559', '10'),
							('m02', 'Aggrezenil', 'Aleve', 'Meditronix International', 'Australia', '2039-04-21', '3009', '554'),
                            ('m03', 'Tamsumentin', 'Neosporin', 'Meds Manor', 'Ireland', '2025-08-06', '4765', '900'),
                            ('m04', 'Valstrin', 'Tums', 'Global Medics', 'Germany', '2028-11-18', '311', '98000'),
                            ('m05', 'Duraclude', 'Dayquil', 'Healthwise Corporation', 'Germany', '2026-12-21', '77', '78666'),
                            ('m06', 'Aldakyn', 'Aleve', 'Meds Manor', 'Ireland', '2026-02-07', '6665', '60000.99'),
                            ('m07', 'Novovatol Oxacaine', 'Aleve', 'Pharma Plus', 'US', '2030-03-23', '898', '54.99'),
                            ('m08', 'Perconium Adotamine', 'Bayer Aspirin', 'Healthwise Corporation', 'Cuba', '2034-05-28', '332', '34889'),
                            ('m09', 'Afacelex Abobosol', 'Bayer Aspirin', 'Healthwise Corporation', 'Cuba', '2035-05-01', '100', '890'),
                            ('m10', 'Coleclude Oxytrace', 'Theraflu', 'Meditronix International', 'China', '2039-08-25', '12', '12000');

-- create TREATMENT table
CREATE TABLE TREATMENT (
	ID varchar(3) not null,
		primary key (ID),
	NAME varchar(50) unique not null,
    PRICE decimal(9,3)
);

-- insert data for TREATMENT
INSERT INTO TREATMENT VALUES ('t01', 'MRI', '3000'),
							('t02', 'X-Ray', '85'),
                            ('t03', 'CT Scan', '557'),
                            ('t04', 'Fetal Ultrasound', '156'),
                            ('t05', 'Ultrasound-guided breast biopsy', '752'),
                            ('t06', 'Arm Angiography', '4000'),
                            ('t07', 'Aortic Angiography', '5900'),
                            ('t08', 'Fluoroscopy', '580'),
                            ('t09', 'Heart valve replacement', '170000'),
                            ('t10', 'Heart bypass', '123000'),
                            ('t11', 'Spinal Fusion', '110000'),
                            ('t12', 'Hip replacement', '40364'),
                            ('t13', 'Knee replacement', '35000'),
                            ('t14', 'Angioplasty', '28200'),
                            ('t15', 'Gastric bypass', '25600'),
                            ('t16', 'Cornea', '17500'),
                            ('t17', 'Gastric sleeve', '16000');
                            
-- create ROOM table
CREATE TABLE ROOM (
	ROOMNO int not null,
		primary key (ROOMNO)
);

-- insert data into ROOM
INSERT INTO ROOM VALUES (101),
						(102),
						(103),
						(104),
						(201),
						(202),
						(203),
						(301),
						(302),
						(401),
						(402),
						(403),
						(404),
						(405),
						(501),
						(502),
						(503),
						(504),
						(505),
						(601),
						(701),
						(702),
						(801),
						(901),
						(902),
						(1001),
						(1002),
						(1003);

-- create ADMISSION_ROOM table
CREATE TABLE ADMISSION_ROOM (
	ROOMNO int not null primary key,
    CAPACITY int,
    CURRENTNUMBER int default 0,
    foreign key (ROOMNO) references ROOM(ROOMNO) on delete cascade
);

-- insert data into ADMISSION_ROOM
INSERT INTO ADMISSION_ROOM VALUES (501,	10,	0),
								(601, 10, 0),
								(701, 5, 0),
								(702, 6, 0),
								(801, 10, 0),
								(901, 10, 0),
								(902, 2, 0),
								(1001, 1, 0),
								(1002, 5, 0),
								(1003, 1, 0);

-- create TREATMENT_ROOM table
CREATE TABLE TREATMENT_ROOM (
	ROOMNO int not null primary key,
    ROOMNAME varchar(40) not null,
    AVAILABLE boolean default true,
    foreign key (ROOMNO) references ROOM(ROOMNO) on delete cascade
);

-- insert data into TREATMENT_ROOM
INSERT INTO TREATMENT_ROOM VALUES (101,	'ICU',	1),
								(102,	'ICU',	1),
								(103,	'ICU',	1),
								(104,	'Maternity Care Room',	1),
								(201,	'Operation Theater',	1),
								(202,	'Maternity Care Room',	1),
								(203,	'Maternity Care Room',	1),
								(301,	'Operation Theatre',	1),
								(302,	'Operation Theatre',	1),
								(401,	'Behavioral and Mental Health Room',	1),
								(402,	'Consultation Room',	1),
								(403,	'Consultation Room',	1),
								(404,	'Consultation Room',	1),
								(405,	'Consultation Room',	1),
								(502,	'Consultation Room',	1),
								(503,	'Consultation Room',	1),
								(504,	'Consultation Room',	1),
								(505,	'Consultation Room',	1);


-- create APPOINTMENT table
CREATE TABLE APPOINTMENT (
	ID int not null auto_increment,
		primary key (ID),
    DOCTOR varchar(4) not null, foreign key (DOCTOR) references EMPLOYEE(EID) on delete no action,
    PATIENT varchar(4) not null, foreign key (PATIENT) references PATIENT(PID) on delete restrict,
    STARTTIME timestamp not null,
    ENDTIME timestamp,
    ROOM int,
    foreign key (ROOM) references TREATMENT_ROOM(ROOMNO) on delete set null,
    constraint chk_time check (ENDTIME > STARTTIME)
);
-- Set auto increment from 1
ALTER TABLE APPOINTMENT AUTO_INCREMENT=1;

-- insert data into APPOINTMENT
INSERT INTO APPOINTMENT (DOCTOR, PATIENT, STARTTIME, ENDTIME, ROOM) VALUES ('e010',	'p004',	'2022-02-01 04:40',	'2022-02-01 04:55',	502),
																			('e013',	'p006',	'2022-02-23 11:00',	'2022-02-23 11:30',	504),
																			('e010',	'p007',	'2022-06-28 23:30',	'2022-06-29 00:30',	505),
																			('e021',	'p009',	'2022-12-28 16:30',	'2022-12-28 17:30',	402),
																			('e010',	'p002',	'2023-01-14 19:30',	'2023-01-14 19:45',	404),
																			('e079',	'p010',	'2023-01-30 18:00',	'2023-01-30 18:15',	503),
																			('e058',	'p011',	'2023-02-19 05:30',	'2023-02-19 05:45',	404),
																			('e021',	'p009',	'2023-03-10 12:30',	'2023-03-10 12:45',	402),
																			('e054',	'p008',	'2023-10-13 04:00',	'2023-10-13 04:30',	403),
																			('e002',	'p001',	'2023-10-29 03:30',	'2023-10-29 04:00',	504);


-- Trigger for Doctor restriction in APPOINTMENT
DELIMITER $$
CREATE TRIGGER tg_appointment_doctor
BEFORE INSERT
ON APPOINTMENT FOR EACH ROW
BEGIN
	IF (SELECT POSITION 
		FROM EMPLOYEE WHERE EMPLOYEE.EID = NEW.DOCTOR) NOT LIKE 'Doctor'
	THEN
        SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'A doctor must be in charge of the appointment';
	END IF;
END $$
DELIMITER ;

-- for checking trigger tg_appointment_doctor
-- INSERT INTO APPOINTMENT (DOCTOR, PATIENT, STARTTIME, ENDTIME, ROOM) VALUES ('e003',	'p009',	'2022-02-01 04:40',	'2022-02-01 04:55',	502);

-- Trigger: each doctor and patient cannot have more than one appointment at a time
DELIMITER $$
CREATE TRIGGER tg_insert_appointment
BEFORE INSERT ON APPOINTMENT
FOR EACH ROW
BEGIN
	IF EXISTS (SELECT * FROM APPOINTMENT
				WHERE DOCTOR = NEW.DOCTOR
                AND (NEW.STARTTIME BETWEEN STARTTIME AND ENDTIME
                OR NEW.ENDTIME BETWEEN STARTTIME AND ENDTIME))
	THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'A doctor is busy at this time';
	ELSEIF EXISTS (SELECT * FROM APPOINTMENT
				WHERE PATIENT = NEW.PATIENT
                AND (NEW.STARTTIME BETWEEN STARTTIME AND ENDTIME
                OR NEW.ENDTIME BETWEEN STARTTIME AND ENDTIME))
	THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'A patient has ready had an appointment at this time';
	ELSEIF EXISTS (SELECT * FROM APPOINTMENT
				WHERE ROOM = NEW.ROOM
                AND (NEW.STARTTIME BETWEEN STARTTIME AND ENDTIME
                OR NEW.ENDTIME BETWEEN STARTTIME AND ENDTIME))
	THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'The room is already booked at that time';
	END IF;
    IF (SELECT ROOMNAME
		FROM TREATMENT_ROOM WHERE TREATMENT_ROOM.ROOMNO = NEW.ROOM) NOT LIKE 'Consultation Room'
	THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'An appointment can only take place in a Consultation Room';
	END IF;
END $$
DELIMITER ;

-- for CHECKING tg_insert_appointment
-- INSERT INTO APPOINTMENT (DOCTOR, PATIENT, STARTTIME, ENDTIME, ROOM) VALUES ('e021',	'p004',	'2022-02-01 04:30',	'2022-02-01 04:45',	502);
-- SELECT * FROM APPOINTMENT;
-- DELETE FROM APPOINTMENT WHERE ID = 11;

-- create ADMISSION table
CREATE TABLE ADMISSION (
	STAYID varchar(3) not null primary key,
	STARTDATE date not null default (CURDATE()),
    ENDDATE date default NULL,
    ROOMNO int not null references ADMISSION_ROOM(ROOMNO),
    APPOINTMENT int not null, 
    foreign key (APPOINTMENT) references APPOINTMENT(ID) on delete restrict,
    constraint chk_date check (ENDDATE >= STARTDATE)
);

-- trigger: check whether a room is full or not
DELIMITER $$
CREATE TRIGGER tg_admit
BEFORE INSERT ON ADMISSION
FOR EACH ROW
BEGIN
	-- Case 1: if a current date is inserted
	IF NEW.STARTDATE = CURDATE()
    THEN
		-- Check if the current number of patients in the room reaches the max or not
		IF (SELECT CURRENTNUMBER
			FROM ADMISSION_ROOM
            WHERE ROOMNO = NEW.ROOMNO) >= (SELECT CAPACITY
											FROM ADMISSION_ROOM
                                            WHERE ROOMNO = NEW.ROOMNO)
		THEN
			-- prevent insert action and print message
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'This room is full';
		ELSE
        -- If there are still spaces, increase the currentnumber by 1
			UPDATE ADMISSION_ROOM
            SET CURRENTNUMBER = CURRENTNUMBER + 1
            WHERE ROOMNO = NEW.ROOMNO;
		END IF;
	-- if startdate is not the current date
	ELSEIF NEW.STARTDATE < CURDATE()
    THEN
		IF NEW.ENDDATE IS NOT NULL
        THEN
			IF (SELECT COUNT(STAYID) -- count the total number of patients in that room at the date which overlaps the date inserted
				FROM ADMISSION A
				WHERE ROOMNO = NEW.ROOMNO
				AND (NEW.STARTDATE BETWEEN STARTDATE AND ENDDATE -- Check if the total patients exceed the capacity
					OR NEW.ENDDATE BETWEEN STARTDATE AND ENDDATE)) >= (SELECT CAPACITY
																		FROM ADMISSION_ROOM
																		WHERE ROOMNO = NEW.ROOMNO)
			THEN
				SIGNAL SQLSTATE '45000' 
				SET MESSAGE_TEXT = 'This room is full';
			END IF;
		ELSE
			IF (SELECT COUNT(STAYID) -- count the total number of patients in that room at the date which overlaps the date inserted
				FROM ADMISSION A
				WHERE ROOMNO = NEW.ROOMNO
				AND (NEW.STARTDATE BETWEEN STARTDATE AND ENDDATE -- Check if the total patients exceed the capacity
					OR CURDATE() BETWEEN STARTDATE AND ENDDATE)) >= (SELECT CAPACITY
																		FROM ADMISSION_ROOM
																		WHERE ROOMNO = NEW.ROOMNO)
			THEN
				SIGNAL SQLSTATE '45000' 
				SET MESSAGE_TEXT = 'This room is full';
			END IF;
		END IF;
    END IF;
END $$
DELIMITER ;

-- PROCEDURE: Discharge patient from Hospital
DELIMITER $$
CREATE PROCEDURE discharge_stay (IN patient_stay VARCHAR(3)) -- declare an input is the STAYID
BEGIN
	-- check if the patient is in the hospital and have not been discharged (enddate is NULL?)
    DECLARE patient_room INT; -- declare a variable represents roomno
    IF EXISTS (SELECT *
				FROM ADMISSION
				WHERE STAYID = 's09' AND ENDDATE IS NULL)
	THEN
		-- set patient_room to the room of that patient
		SELECT ROOMNO INTO patient_room
		FROM ADMISSION
		WHERE STAYID = patient_stay;
        -- set the enddate to current date
		UPDATE ADMISSION
        SET ENDDATE = CURDATE()
        WHERE STAYID = patient_stay;
        -- decrease the currentnumber by 1
        UPDATE ADMISSION_ROOM
        SET CURRENTNUMBER = CURRENTNUMBER - 1
        WHERE ROOMNO = patient_room;
	ELSE
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'The patient is not currently admitted';
	END IF;
END $$
DELIMITER ;

-- insert data into ADMISSION
INSERT INTO ADMISSION VALUES ('s01', '2022-02-01',	'2022-02-04',	702,	1),
							('s02',	'2022-02-23',	'2022-03-05',	901,	2),
							('s03',	'2022-06-29',	'2022-07-04',	1001,	3),
							('s04',	'2022-12-28',	'2022-12-29',	1001,	4),
							('s05',	'2023-01-14',	'2023-01-21',	601,	5),
							('s06',	'2023-01-30',	'2023-02-01',	902,	6),
							('s07',	'2023-02-19',	'2023-02-21',	501,	7),
							('s08',	'2023-03-10',	'2023-03-12',	901,	8);
                            
-- add an admission for current time
-- INSERT INTO ADMISSION (STAYID, ROOMNO, APPOINTMENT) VALUES ('s09', 702, 9);

-- Test: call discharge_stay procedure for 's09'
-- CALL discharge_stay('s09');

-- for checking trigger tg_admit
-- INSERT INTO ADMISSION VALUES ('s10', '2022-06-29',	'2022-06-30',	1001,	10);

-- create PRESCRIPTION table
CREATE TABLE PRESCRIPTION (
	PRESID varchar(4) not null,
		primary key (PRESID),
	PRESCRIBER varchar(4) not null references EMPLOYEE(EID) on delete restrict,
    APPOINTMENT int not null references APPOINTMENT(ID) on delete restrict,
    VALUE decimal(9,3) default 0
);

-- insert data into PRESCRIPTION
INSERT INTO PRESCRIPTION (PRESID, PRESCRIBER, APPOINTMENT) VALUES ('pr01',	'e029',	1),
																('pr02',	'e020',	2),
																('pr03',	'e029',	3),
																('pr04',	'e020',	5),
																('pr05',	'e003',	7),
																('pr06',	'e029',	8),
																('pr07',	'e003',	4),
																('pr08',	'e029',	'6');

-- create TAKE_MEDICINE table
CREATE TABLE TAKE_MEDICINE (
	PRESCRIPTION varchar(4) not null,
    MEDICINE varchar(3) not null,
    foreign key (PRESCRIPTION) references PRESCRIPTION(PRESID) on delete restrict,
    foreign key (MEDICINE) references MEDICINE(ID) on delete restrict,
    primary key (PRESCRIPTION, MEDICINE)
);

-- Trigger: update the value of prescription when a new medicine is added to the prescription
DELIMITER $$
CREATE TRIGGER tg_pres_value
AFTER INSERT -- after a medicine is added to a prescription
ON TAKE_MEDICINE FOR EACH ROW
BEGIN
	DECLARE new_value DEC (9,2); -- declare a variable
    
    -- assign the total sum of all medicine to new_value
    SELECT SUM(M.PRICE) INTO new_value
    FROM MEDICINE M JOIN TAKE_MEDICINE T ON M.ID = T.MEDICINE
    WHERE T.PRESCRIPTION = NEW.PRESCRIPTION;
    
    -- update the new value of the prescription whose ID has been inserted in the TAKE_MEDICINE table
    UPDATE PRESCRIPTION
    SET VALUE = new_value
    WHERE PRESID LIKE NEW.PRESCRIPTION;
END $$
DELIMITER ;

-- insert data into TAKE_MEDICINE
INSERT INTO TAKE_MEDICINE VALUES ('pr01',	'm02'),
								('pr01',	'm03'),
								('pr02',	'm07'),
								('pr02',	'm08'),
								('pr02',	'm09'),
								('pr02',	'm02'),
								('pr03',	'm05'),
								('pr03',	'm06'),
								('pr03',	'm10'),
								('pr04',	'm09'),
								('pr05',	'm04'),
								('pr05',	'm06'),
								('pr05',	'm07'),
								('pr05',	'm08'),
								('pr06',	'm07'),
								('pr06',	'm09'),
								('pr06',	'm10'),
                                ('pr07',	'm01'),
                                ('pr07',	'm03'),
                                ('pr07',	'm09'),
								('pr08',	'm06');

-- create UNDERGOES table
CREATE TABLE UNDERGOES (
	APPOINTMENT int not null,
		foreign key (APPOINTMENT) references APPOINTMENT(ID) on delete restrict,
    TREATMENT varchar(3) not null,
		foreign key (TREATMENT) references TREATMENT(ID) on delete restrict,
    DATE date not null,
    PHYSICIAN varchar(4),
		foreign key (PHYSICIAN) references EMPLOYEE(EID) on delete restrict,
    ASSISTANT varchar(4),
		foreign key (ASSISTANT) references EMPLOYEE(EID) on delete restrict,
    ROOMBOOKING int,
		foreign key (ROOMBOOKING) references TREATMENT_ROOM(ROOMNO) on delete set null,
	primary key (APPOINTMENT, TREATMENT, DATE)
);

-- Trigger for UNDERGOES:
-- Physician must be a Doctor
-- Assistant must be a nurse or a ward boy
DELIMITER $$
CREATE TRIGGER tg_undergoes_employee
BEFORE INSERT
ON UNDERGOES FOR EACH ROW
BEGIN
	IF (SELECT POSITION
		FROM EMPLOYEE WHERE EMPLOYEE.EID = NEW.PHYSICIAN) NOT LIKE 'Doctor'
	THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'A physician must be a doctor';
	END IF;
    IF (SELECT POSITION
		FROM EMPLOYEE WHERE EMPLOYEE.EID = NEW.ASSISTANT) NOT IN ('Nurse', 'Ward boy')	
	THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'An assistant must be a nurse';
	END IF;
END $$ 
DELIMITER ;

-- INSERT DATA INTO UNDERGOES
INSERT INTO UNDERGOES VALUES (1,	't06',	'2022-02-02',	'e010',	'e007',	NULL),
							(1,	't15',	'2022-02-02',	'e013',	'e069',	201),
							(2,	't06',	'2022-02-23',	'e021',	'e012',	NULL),
							(2,	't12',	'2022-02-24',	'e001',	'e036',	302),
							(3,	't03',	'2022-06-29',	'e058',	'e007',	NULL),
							(3,	't09',	'2022-06-30',	'e041',	'e076',	301),
							(3,	't15',	'2022-07-01',	'e080',	'e061',	102),
							(4,	't01',	'2022-12-28',	'e080',	'e075',	NULL),
							(5,	't17',	'2023-01-14',	'e027',	'e069',	301),
							(5,	't07',	'2023-01-18',	'e043',	NULL,	NULL),
							(6,	't04',	'2023-01-30',	'e051',	NULL,	NULL),
							(6,	't15',	'2023-01-31',	'e010',	'e016',	201),
							(7,	't13',	'2023-02-20',	'e019',	NULL,	201),
							(8,	't14',	'2023-03-10',	'e041',	'e035',	302);



-- create BILL table
CREATE TABLE BILL (
	ID int not null auto_increment,
		primary key (ID),
    BILLDATE date not null,
    APPOINTMENT int references APPOINTMENT(ID) on delete restrict,
    Total dec not null default 0
);

-- Trigger: Bill Total is a derived attribute, autofilled field based on the process of that patient during a specific appointment
DELIMITER $$
CREATE TRIGGER tg_bill
BEFORE INSERT
ON BILL
FOR EACH ROW
BEGIN
	DECLARE temp DEC(9,2) DEFAULT 0; -- declare a variable for storing temporary values
    
    -- Treatment fee
    SELECT SUM(T.PRICE) INTO temp
    FROM TREATMENT T
    WHERE T.ID IN (SELECT U.TREATMENT
					FROM UNDERGOES U
                    WHERE U.APPOINTMENT IN (SELECT A.ID
											FROM APPOINTMENT A
                                            WHERE A.ID = NEW.APPOINTMENT));
	
    SET NEW.TOTAL = NEW.TOTAL + temp;
    
    -- Prescription fee
    SELECT P.VALUE INTO temp
    FROM PRESCRIPTION P
    WHERE P.APPOINTMENT = NEW.APPOINTMENT;
    
    SET NEW.TOTAL = NEW.TOTAL + temp;
    
    -- Admission fee, $250/day
    SELECT (DATEDIFF(ENDDATE, STARTDATE) + 1) * 250 INTO temp
    FROM ADMISSION A
    WHERE A.APPOINTMENT = NEW.APPOINTMENT;
    
    SET NEW.TOTAL = NEW.TOTAL + temp;
END $$
DELIMITER ;

-- insert data into BILL
INSERT INTO BILL (ID, BILLDATE, APPOINTMENT) VALUES (1,	'2022-02-04',	1);
INSERT INTO BILL (ID, BILLDATE, APPOINTMENT) VALUES (2,	'2022-03-05',	2);
INSERT INTO BILL (ID, BILLDATE, APPOINTMENT) VALUES (3,	'2022-07-04',	3);
INSERT INTO BILL (ID, BILLDATE, APPOINTMENT) VALUES (4,	'2022-12-29',	4);
INSERT INTO BILL (ID, BILLDATE, APPOINTMENT) VALUES (5,	'2023-01-21',	5);
INSERT INTO BILL (ID, BILLDATE, APPOINTMENT) VALUES (6,	'2023-02-01',	6);
INSERT INTO BILL (ID, BILLDATE, APPOINTMENT) VALUES (7,	'2023-02-21',	7);
INSERT INTO BILL (ID, BILLDATE, APPOINTMENT) VALUES (8,	'2023-03-12',	8);









