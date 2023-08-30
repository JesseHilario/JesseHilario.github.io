USE BaseBall_Summer_2023;
IF OBJECT_ID (N'dbo.[Parks]', N'U') IS NOT NULL
DROP TABLE dbo.[Parks];
GO
CREATE TABLE Parks (
  parkID char(5),
  parkName varchar(100) NOT NULL,
  parkAlias varchar(100),
  city varchar(50),
  state varchar(50),
  country char(2),
  primary key (parkID),
--   foreign key (parkID) references dbo.HomeGames
);

-- Alter table Parks
-- Alter column [Parks_PK] varchar(255) Not Null
-- ADD PRIMARY KEY (parkID)

ALTER TABLE Parks
ADD CONSTRAINT check_Country CHECK (country in ('AU', 'CA', 'JP', 'MX', 'PR', 'UK', 'US'))
-- Alter table Parks
-- Add Constraint FK_parkID Foreign key (parkID)
-- References HomeGames(parkID)
-- On delete cascade
-- On Update cascade


Use BaseBall_Summer_2023;
Delete from Parks
INSERT INTO Parks VALUES ('ALB01','Riverside Park',null,'Albany','NY','US'),
('ALT01','Columbia Park',null,'Altoona','PA','US'), ('ANA01','Angel Stadium of
Anaheim','Edison Field; Anaheim Stadium','Anaheim','CA','US'), ('ARL01','Arlington
Stadium',null,'Arlington','TX','US'), ('ARL02','Rangers Ballpark in Arlington','The
Ballpark in Arlington; Ameriquest Fl','Arlington','TX','US'), ('ATL01','Atlanta-
Fulton County Stadium',null,'Atlanta','GA','US'), ('ATL02','Turner
Field',null,'Atlanta','GA','US'), ('ATL03','Suntrust
Park',null,'Atlanta','GA','US'), ('BAL01','Madison Avenue
Grounds',null,'Baltimore','MD','US'), ('BAL02','Newington
Park',null,'Baltimore','MD','US'), ('BAL03','Oriole Park
I',null,'Baltimore','MD','US'), ('BAL04','Belair Lot',null,'Baltimore','MD','US'),
('BAL05','Monumental Park',null,'Baltimore','MD','US'), ('BAL06','Oriole Park
II',null,'Baltimore','MD','US'), ('BAL07','Oriole Park
III',null,'Baltimore','MD','US'), ('BAL09','Oriole Park IV','American League
Park','Baltimore','MD','US'), ('BAL10','Terrapin Park','Oriole Park
V','Baltimore','MD','US'), ('BAL11','Memorial Stadium',null,'Baltimore','MD','US'),
('BAL12','Oriole Park at Camden Yards',null,'Baltimore','MD','US'), ('BOS01','South
End Grounds I','Walpole Street Grounds','Boston','MA','US'), ('BOS02','Dartmouth
Grounds','Union Park','Boston','MA','US'), ('BOS03','South End Grounds
II',null,'Boston','MA','US'), ('BOS04','Congress Street
Grounds',null,'Boston','MA','US'), ('BOS05','South End Grounds
III',null,'Boston','MA','US'), ('BOS06','Huntington Avenue Baseball
Grounds',null,'Boston','MA','US'), ('BOS07','Fenway Park',null,'Boston','MA','US'),
('BOS08','Braves Field','Bee Hive','Boston','MA','US'), ('BUF01','Riverside
Grounds',null,'Buffalo','NY','US'), ('BUF02','Olympic Park
I',null,'Buffalo','NY','US'), ('BUF03','Olympic Park II',null,'Buffalo','NY','US'),
('BUF04','International Fair Association Grounds','Federal League
Park','Buffalo','NY','US'), ('CAN01','Mahaffey Park','Pastime
Park','Canton','OH','US'), ('CAN02','Pastime Park',null,'Canton','OH','US'),
('CHI01','Lake Front Park I','Union Base-ball Grounds','Chicago','IL','US'),
('CHI02','23rd Street Park',null,'Chicago','IL','US'), ('CHI03','Lake Front Park
II',null,'Chicago','IL','US'), ('CHI05','South Side Park I','Cricket Club Grounds;
Union Grounds','Chicago','IL','US'), ('CHI06','West Side
Park',null,'Chicago','IL','US'), ('CHI07','South Side Park
II',null,'Chicago','IL','US'), ('CHI08','West Side
Grounds',null,'Chicago','IL','US'), ('CHI09','South Side Park
III',null,'Chicago','IL','US'), ('CHI10','Comiskey Park I','White Sox
Park','Chicago','IL','US'), ('CHI11','Wrigley Field','Weeghman Park; Cubs
Park','Chicago','IL','US'), ('CHI12','Guaranteed Rate Field','U.S. Cellular
Field;White Sox Park; Comiskey Park II','Chicago','IL','US'), ('CIN01','Lincoln
Park Grounds','Union Cricket Club Grounds','Cincinnati','OH','US'),
('CIN02','Avenue Grounds',null,'Cincinnati','OH','US'), ('CIN03','Bank Street
Grounds',null,'Cincinnati','OH','US'), ('CIN04','League Park
I',null,'Cincinnati','OH','US'), ('CIN05','League Park
II',null,'Cincinnati','OH','US'), ('CIN06','Palace of the Fans','League Park
III','Cincinnati','OH','US'), ('CIN07','Crosley Field','Redland
Field','Cincinnati','OH','US'), ('CIN08','Cinergy Field','Riverfront
Stadium','Cincinnati','OH','US'), ('CIN09','Great American
Ballpark',null,'Cincinnati','OH','US'), ('CLE01','National Association
Grounds',null,'Cleveland','OH','US'), ('CLE02','League Park I','Kennard Street
Park','Cleveland','OH','US'), ('CLE03','League Park II','American Association
Park','Cleveland','OH','US'), ('CLE04','Brotherhood Park','Players League
Park','Cleveland','OH','US'), ('CLE05','League Park III','National League Park
III','Cleveland','OH','US'), ('CLE06','League Park IV','Dunn
Field','Cleveland','OH','US'), ('CLE07','Cleveland Stadium','Municipal
Stadium','Cleveland','OH','US'), ('CLE08','Progressive Field','Jacobs
Field','Cleveland','OH','US'), ('CLE09','Cedar Avenue Driving
Park',null,'Cleveland','OH','US'), ('CLL01','Euclid Beach
Park',null,'Collinwood','OH','US'), ('COL01','Recreation Park
I',null,'Columbus','OH','US'), ('COL02','Recreation Park
II',null,'Columbus','OH','US'), ('COL03','Neil Park I',null,'Columbus','OH','US'),
('COL04','Neil Park II',null,'Columbus','OH','US'), ('COV01','Star Baseball
Park',null,'Covington','KY','US'), ('DAY01','Fairview
Park',null,'Dayton','OH','US'), ('DEN01','Mile High
Stadium',null,'Denver','CO','US'), ('DEN02','Coors Field',null,'Denver','CO','US'),
('DET01','Recreation Park',null,'Detroit','MI','US'), ('DET02','Bennett
Park',null,'Detroit','MI','US'), ('DET03','Burns Park','West End
Park','Detroit','MI','US'), ('DET04','Tiger Stadium','Navin Field; Briggs
Stadium','Detroit','MI','US'), ('DET05','Comerica Park',null,'Detroit','MI','US'),
('DOV01','Fairview Park Fair Grounds',null,'Dover','DE','US'), ('ELM01','Maple
Avenue Driving Park',null,'Elmira','NY','US'), ('FOR01','Grand Duchess','Hamilton
Field','Fort Wayne','IN','US'), ('FOR03','Jailhouse Flats',null,'Fort
Wayne','IN','US'), ('FTB01','Fort Bragg Field',null,'Fort Bragg','NC','US'),
('GEA01','Geauga Lake Grounds','Beyerle_s Park','Geauga Lake','OH','US'),
('GLO01','Gloucester Point Grounds',null,'Gloucester City','NJ','US'),
('GLO02','Gloucester Fireworks Park',null,'Gloucester City','NJ','US'),
('GRA01','Ramona Park',null,'Grand Rapids','MI','US'), ('HAR01','Harrison
Field',null,'Harrison','NJ','US'), ('HOB01','Elysian
Field',null,'Hoboken','NJ','US'), ('HON01','Aloha
Stadium',null,'Honolulu','HI','US'), ('HOU01','Colt
Stadium',null,'Houston','TX','US'), ('HOU02','Astrodome',null,'Houston','TX','US'),
('HOU03','Minute Maid Park','Enron Field; Astros Field','Houston','TX','US'),
('HRT01','Hartford Ball Club Grounds',null,'Hartford','CT','US'),
('HRT02','Hartford Trotting Park',null,'Hartford','CT','US'), ('IND01','South
Street Park',null,'Indianapolis','IN','US'), ('IND02','Seventh Street Park
I',null,'Indianapolis','IN','US'), ('IND03','Bruce
Grounds',null,'Indianapolis','IN','US'), ('IND04','Seventh Street Park
II',null,'Indianapolis','IN','US'), ('IND05','Seventh Street Park
III',null,'Indianapolis','IN','US'), ('IND06','Indianapolis
Park',null,'Indianapolis','IN','US'), ('IND07','Federal League Park','Washington
Park','Indianapolis','IN','US');
INSERT INTO Parks VALUES ('IRO01','Windsor Beach',null,'Irondequoit','NY','US'),
('JER01','Oakdale Park',null,'Jersey City','NJ','US'), ('JER02','Roosevelt
Stadium',null,'Jersey City','NJ','US'), ('KAN01','Athletic Park',null,'Kansas
City','MO','US'), ('KAN02','Association Park',null,'Kansas City','MO','US'),
('KAN03','Exposition Park',null,'Kansas City','MO','US'), ('KAN04','Gordon and
Koppel Field',null,'Kansas City','MO','US'), ('KAN05','Municipal
Stadium',null,'Kansas City','MO','US'), ('KAN06','Kauffman Stadium','Royals
Stadium','Kansas City','MO','US'), ('KEO01','Perry Park','Walte_s
Pasture','Keokuk','IA','US'), ('LAS01','Cashman Field',null,'Las Vegas','NV','US'),
('LBV01','The Ballpark at Disney_s Wide World',null,'Lake Buena Vista','FL','US'),
('LON01','London Stadium',null,'London','ENG','UK'), ('LOS01','Los Angeles Memorial
Coliseum',null,'Los Angeles','CA','US'), ('LOS02','Wrigley Field',null,'Los
Angeles','CA','US'), ('LOS03','Dodger Stadium','Chavez Ravine','Los
Angeles','CA','US'), ('LOU01','Louisville Baseball
Park',null,'Louisville','KY','US'), ('LOU02','Eclipse Park
I',null,'Louisville','KY','US'), ('LOU03','Eclipse Park
II',null,'Louisville','KY','US'), ('LOU04','Eclipse Park
III',null,'Louisville','KY','US'), ('LUD01','Ludlow Baseball
Park',null,'Ludlow','KY','US'), ('MAS01','Long Island
Grounds',null,'Maspeth','NY','US'), ('MIA01','Sun Life Stadium','JoeRobbie;
ProPlayer; Dolphin; LandShark','Miami','FL','US'), ('MIA02','Marlins
Park',null,'Miami','FL','US'), ('MID01','Mansfield Club
Grounds',null,'Middletown','CT','US'), ('MIL01','Milwaukee Base-Ball
Grounds',null,'Milwaukee','WI','US'), ('MIL02','Wright Street
Grounds',null,'Milwaukee','WI','US'), ('MIL03','Athletic
Park',null,'Milwaukee','WI','US'), ('MIL04','Lloyd Street
Grounds',null,'Milwaukee','WI','US'), ('MIL05','County
Stadium',null,'Milwaukee','WI','US'), ('MIL06','Miller
Park',null,'Milwaukee','WI','US'), ('MIN01','Athletic
Park',null,'Minneapolis','MN','US'), ('MIN02','Metropolitan
Stadium',null,'Bloomington','MN','US'), ('MIN03','Hubert H. Humphrey
Metrodome',null,'Minneapolis','MN','US'), ('MIN04','Target
Field',null,'Minneapolis','MN','US'), ('MNT01','Estadio
Monterrey',null,'Monterrey','Nuevo Leon','MX'), ('MON01','Parc Jarry','Jarry
Park','Montreal','QC','CA'), ('MON02','Stade Olympique','Olympic
Stadium','Montreal','QC','CA'), ('NEW01','Howard Avenue Grounds','Brewster
Park','New Haven','CT','US'), ('NEW02','Hamilton Park',null,'New Haven','CT','US'),
('NEW03','Geauga Lake Grounds','Beyerle_s Park','Geauga Lake','OH','US'),
('NWK01','Wiedenmeyer_s Park',null,'Newark','NJ','US'), ('NYC01','Union
Grounds',null,'Brooklyn','NY','US'), ('NYC02','Capitoline
Grounds',null,'Brooklyn','NY','US'), ('NYC03','Polo Grounds I (Southeast
Diamond)',null,'New York','NY','US'), ('NYC04','Polo Grounds II (Southwest
Diamond)',null,'New York','NY','US'), ('NYC05','Washington Park
I',null,'Brooklyn','NY','US'), ('NYC06','Metropolitan Park',null,'New
York','NY','US'), ('NYC07','Grauer_s Ridgewood Park','Ridgewood Park
I','Queens','NY','US'), ('NYC08','Washington Park II',null,'Brooklyn','NY','US'),
('NYC09','Polo Grounds III',null,'New York','NY','US'), ('NYC10','Polo Grounds
IV',null,'New York','NY','US'), ('NYC11','Eastern Park',null,'Brooklyn','NY','US'),
('NYC12','Washington Park III',null,'Brooklyn','NY','US'), ('NYC13','Hilltop
Park',null,'New York','NY','US'), ('NYC14','Polo Grounds V',null,'New
York','NY','US'), ('NYC15','Ebbets Field',null,'Brooklyn','NY','US'),
('NYC16','Yankee Stadium I',null,'New York','NY','US'), ('NYC17','Shea
Stadium','William A. Shea Stadium','New York','NY','US'), ('NYC18','Wallace_s
Ridgewood Park','Ridgewood Park II','Queens','NY','US'), ('NYC19','Washington Park
IV',null,'Brooklyn','NY','US'), ('NYC20','Citi Field',null,'New York','NY','US'),
('NYC21','Yankee Stadium II',null,'New York','NY','US'), ('OAK01','Oakland-Alameda
County Coliseum','Network Associates Coliseum','Oakland','CA','US'), ('OMA01','TD
Ameritrade Park',null,'Omaha','NE','US'), ('PEN01','East End Park','Pendleton
Park','Cincinnati','OH','US'), ('PHI01','Jefferson Street Grounds','Athletics
Park','Philadelphia','PA','US'), ('PHI02','Centennial
Park',null,'Philadelphia','PA','US'), ('PHI03','Oakdale
Park',null,'Philadelphia','PA','US'), ('PHI04','Recreation
Park',null,'Philadelphia','PA','US'), ('PHI05','Keystone
Park',null,'Philadelphia','PA','US'), ('PHI06','Huntingdon Grounds
I',null,'Philadelphia','PA','US'), ('PHI07','Forepaugh
Park',null,'Philadelphia','PA','US'), ('PHI08','University of Penn. Athletic
Field',null,'Philadelphia','PA','US'), ('PHI09','Baker
Bowl',null,'Philadelphia','PA','US'), ('PHI10','Columbia
Park',null,'Philadelphia','PA','US'), ('PHI11','Shibe Park','Connie Mack
Stadium','Philadelphia','PA','US'), ('PHI12','Veterans
Stadium',null,'Philadelphia','PA','US'), ('PHI13','Citizens Bank
Park',null,'Philadelphia','PA','US'), ('PHI14','Huntingdon Grounds
II',null,'Philadelphia','PA','US'), ('PHO01','Chase Field','Bank One
Ballpark','Phoenix','AZ','US'), ('PIT01','Union Park',null,'Pittsburgh','PA','US'),
('PIT02','Exposition Park I','Lower Field','Pittsburgh','PA','US'),
('PIT03','Exposition Park II','Upper Field','Pittsburgh','PA','US'),
('PIT04','Recreation Park',null,'Pittsburgh','PA','US'), ('PIT05','Exposition Park
III',null,'Pittsburgh','PA','US'), ('PIT06','Forbes
Field',null,'Pittsburgh','PA','US'), ('PIT07','Three Rivers
Stadium',null,'Pittsburgh','PA','US'), ('PIT08','PNC
Park',null,'Pittsburgh','PA','US'), ('PRO01','Adelaide Avenue
Grounds',null,'Providence','RI','US'), ('PRO02','Messer Street
Grounds',null,'Providence','RI','US'), ('RCK01','Agricultural Society Fair
Grounds',null,'Rockford','IL','US'), ('RIC01','Richmond Fair
Grounds',null,'Richmond','VA','US'), ('RIC02','Allens
Pasture',null,'Richmond','VA','US'), ('ROC01','Culver Field
I',null,'Rochester','NY','US'), ('ROC02','Culver Field
II',null,'Rochester','NY','US'), ('ROC03','Ontario Beach
Grounds',null,'Rochester','NY','US'), ('SAI01','St. George Cricket
Grounds',null,'New York','NY','US'), ('SAN01','Qualcomm Stadium','San Diego/Jack
Murphy Stadium','San Diego','CA','US'), ('SAN02','PETCO Park',null,'San
Diego','CA','US');
INSERT INTO Parks VALUES ('SEA01','Sick_s Stadium',null,'Seattle','WA','US'),
('SEA02','Kingdome',null,'Seattle','WA','US'), ('SEA03','Safeco Field','T-Mobile
Park','Seattle','WA','US'), ('SFO01','Seals Stadium',null,'San
Francisco','CA','US'), ('SFO02','Candlestick Park','3Com Park','San
Francisco','CA','US'), ('SFO03','AT&T Park','Pacific Bell Park; SBC Park','San
Francisco','CA','US'), ('SJU01','Estadio Hiram Bithorn',null,'San Juan',null,'PR'),
('SPR01','Hampden Park Race Track','Springfield Track','Springfield','MA','US'),
('STL01','Red Stockings Base Ball Park',null,'St. Louis','MO','US'),
('STL02','Grand Avenue Park',null,'St. Louis','MO','US'), ('STL03','Sportsman_s
Park I',null,'St. Louis','MO','US'), ('STL04','Union Grounds',null,'St.
Louis','MO','US'), ('STL05','Robison Field',null,'St. Louis','MO','US'),
('STL06','Sportsman_s Park II',null,'St. Louis','MO','US'), ('STL07','Sportsman_s
Park III','Busch Stadium I','St. Louis','MO','US'), ('STL08','Handlan_s
Park','Federal League Park','St. Louis','MO','US'), ('STL09','Busch Stadium
II',null,'St. Louis','MO','US'), ('STL10','Busch Stadium III',null,'St.
Louis','MO','US'), ('STP01','Tropicana Field',null,'St. Petersburg','FL','US'),
('SYD01','Sydney Cricket Ground',null,'Sydney','New South Wales','AU'),
('SYR01','Star Park I','Newell Park','Syracuse','NY','US'), ('SYR02','Star Park
II',null,'Syracuse','NY','US'), ('SYR03','Iron Pier',null,'Syracuse','NY','US'),
('THR01','Three Rivers Park',null,'Three Rivers','NY','US'), ('TOK01','Tokyo
Dome',null,'Tokyo','Tokyo','JP'), ('TOL01','League Park',null,'Toledo','OH','US'),
('TOL02','Tri-State Fair Grounds',null,'Toledo','OH','US'), ('TOL03','Speranza
Park',null,'Toledo','OH','US'), ('TOL04','Armory Park',null,'Toledo','OH','US'),
('TOR01','Exhibition Stadium',null,'Toronto','ON','CA'), ('TOR02','Rogers
Centre','Skydome','Toronto','ON','CA'), ('TRO01','Haymakers_
Grounds',null,'Troy','NY','US'), ('TRO02','Putnam Grounds',null,'Troy','NY','US'),
('WAR01','Rocky Point Park',null,'Warwick','RI','US'), ('WAS01','Olympic
Grounds',null,'Washington','DC','US'), ('WAS02','National
Grounds',null,'Washington','DC','US'), ('WAS03','Capitol
Grounds',null,'Washington','DC','US'), ('WAS04','Athletic
Park',null,'Washington','DC','US'), ('WAS05','Swampoodle
Grounds',null,'Washington','DC','US'), ('WAS06','Boundary
Field',null,'Washington','DC','US'), ('WAS07','American League Park
I',null,'Washington','DC','US'), ('WAS08','American League Park
II',null,'Washington','DC','US'), ('WAS09','Griffith
Stadium',null,'Washington','DC','US'), ('WAS10','Robert F. Kennedy Stadium','D.C.
Stadium','Washington','DC','US'), ('WAS11','Nationals
Park',null,'Washington','DC','US'), ('WAT01','Troy Ball Club
Grounds',null,'Watervliet','NY','US'), ('WAV01','Waverly
Fairgrounds',null,'Waverly','NJ','US'), ('WEE01','Monitor
Grounds',null,'Weehawken','NJ','US'), ('WHE01','Island
Grounds',null,'Wheeling','WV','US'), ('WIL01','Union Street
Park',null,'Wilmington','DE','US'), ('WIL02','BB&T Ballpark at Bowman
Field',null,'Williamsport','PA','US'), ('WNY01','West New York Field Club
Grounds',null,'West New York','NJ','US'), ('WOR01','Agricultural County Fair
Grounds I',null,'Worcester','MA','US'), ('WOR02','Agricultural County Fair Grounds
II',null,'Worcester','MA','US'), ('WOR03','Worcester Driving Park
Grounds',null,'Worcester','MA','US');
Go
select count(*) from Parks