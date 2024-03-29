-- -*- sql-product: postgres; -*-

create extension if not exists pgcrypto;

create table "public"."user" ("id" uuid not null default gen_random_uuid(), "name" text not null, primary key ("id") );

create table "public"."organization" ("id" uuid not null default gen_random_uuid(), "name" text not null, primary key ("id") );

alter table "public"."user" add column "organization_id" uuid
 not null;
alter table "public"."user"
  add constraint "user_organization_id_fkey"
  foreign key ("organization_id")
  references "public"."organization"
  ("id") on update restrict on delete restrict;

CREATE TABLE "public"."permission" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, PRIMARY KEY ("id") );

CREATE TABLE "public"."user_permission" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "user_id" UUID NOT NULL, "permission_id" uuid NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("user_id") REFERENCES "public"."user"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("permission_id") REFERENCES "public"."permission"("id") ON UPDATE restrict ON DELETE restrict);

CREATE TABLE "public"."project" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "organization_id" UUID NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("organization_id") REFERENCES "public"."organization"("id") ON UPDATE restrict ON DELETE restrict);

CREATE TABLE "public"."assignment" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "user_id" uuid NOT NULL, "project_id" uuid NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("user_id") REFERENCES "public"."user"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("project_id") REFERENCES "public"."project"("id") ON UPDATE restrict ON DELETE restrict);

insert into permission (name) values
('view_all_timesheets'),
('edit_all_timesheets'),
('edit_assigned_projects'),
('delete_assigned_projects'),
('view_money_gantt_on_assigned_projects'),
('view_all_projects'),
('edit_all_projects');

alter table "public"."user" alter column "organization_id" drop not null;

insert into "user" (name) values ('Calv Taile');
insert into "user" (name) values ('Faydra Cater');
insert into "user" (name) values ('Roanna Vedenyakin');
insert into "user" (name) values ('Laurianne Defries');
insert into "user" (name) values ('Malvina Sangwine');
insert into "user" (name) values ('Tildie Hummerston');
insert into "user" (name) values ('Betsy Cowdrey');
insert into "user" (name) values ('George Comford');
insert into "user" (name) values ('Basilius Durant');
insert into "user" (name) values ('Constantine Crannage');
insert into "user" (name) values ('Abbott Domengue');
insert into "user" (name) values ('Reggy Jayne');
insert into "user" (name) values ('Doro Bensusan');
insert into "user" (name) values ('Sergent Conaboy');
insert into "user" (name) values ('Baryram Dankersley');
insert into "user" (name) values ('Stu Solloway');
insert into "user" (name) values ('Rochell Luckings');
insert into "user" (name) values ('Tricia Trevaskiss');
insert into "user" (name) values ('Stormi Cowderoy');
insert into "user" (name) values ('Hanna Vivian');
insert into "user" (name) values ('Sergent Caraher');
insert into "user" (name) values ('Efren Gavahan');
insert into "user" (name) values ('Paige Howison');
insert into "user" (name) values ('Winthrop Bim');
insert into "user" (name) values ('Brandice Schwand');
insert into "user" (name) values ('Burton Allawy');
insert into "user" (name) values ('Brig McGoon');
insert into "user" (name) values ('Jarrod Dictus');
insert into "user" (name) values ('Wilma Stedall');
insert into "user" (name) values ('Melisent Coomer');
insert into "user" (name) values ('Dusty Habgood');
insert into "user" (name) values ('Edvard Bande');
insert into "user" (name) values ('Lurette Aistrop');
insert into "user" (name) values ('Flore Stranaghan');
insert into "user" (name) values ('Georgeanne Kinnear');
insert into "user" (name) values ('Giovanni Stihl');
insert into "user" (name) values ('Roby Lambrechts');
insert into "user" (name) values ('Casey Saddleton');
insert into "user" (name) values ('Nita Oswal');
insert into "user" (name) values ('Antons Peris');
insert into "user" (name) values ('Margaretta Ondrus');
insert into "user" (name) values ('Pam Enders');
insert into "user" (name) values ('Faythe Boadby');
insert into "user" (name) values ('Waldon Ainslee');
insert into "user" (name) values ('Buddie Hardbattle');
insert into "user" (name) values ('Emmanuel Linfitt');
insert into "user" (name) values ('Saxon Strapp');
insert into "user" (name) values ('Denni Eckart');
insert into "user" (name) values ('Doe Mallock');
insert into "user" (name) values ('Orelie Iddons');
insert into "user" (name) values ('Kaela Rosgen');
insert into "user" (name) values ('Daryl Sydry');
insert into "user" (name) values ('Dennison Whisson');
insert into "user" (name) values ('Fletch Rudgard');
insert into "user" (name) values ('Addy Van Baaren');
insert into "user" (name) values ('Verile Ida');
insert into "user" (name) values ('Kassia Durante');
insert into "user" (name) values ('Ingaborg Charleston');
insert into "user" (name) values ('Carlita Schaffler');
insert into "user" (name) values ('Alexio Mastrantone');
insert into "user" (name) values ('Roman Francino');
insert into "user" (name) values ('Shirleen Sabatini');
insert into "user" (name) values ('Guglielma Siddell');
insert into "user" (name) values ('Tait Roseborough');
insert into "user" (name) values ('Kathleen Janssens');
insert into "user" (name) values ('Olivero Presslie');
insert into "user" (name) values ('Leland Stiller');
insert into "user" (name) values ('Che Martinetto');
insert into "user" (name) values ('Cullan Chetham');
insert into "user" (name) values ('Alanson Buie');
insert into "user" (name) values ('Sada Marnes');
insert into "user" (name) values ('Caro Rosbottom');
insert into "user" (name) values ('Mandel Garfitt');
insert into "user" (name) values ('Berty Lambol');
insert into "user" (name) values ('Chrysa Bardell');
insert into "user" (name) values ('Pincus Hearons');
insert into "user" (name) values ('Hilliard Stellman');
insert into "user" (name) values ('Raychel Chellam');
insert into "user" (name) values ('Marjy Sheers');
insert into "user" (name) values ('Griffy Pottage');
insert into "user" (name) values ('Ricardo Treppas');
insert into "user" (name) values ('Rockie Holywell');
insert into "user" (name) values ('Meade Cornbill');
insert into "user" (name) values ('Petronille Shillinglaw');
insert into "user" (name) values ('Faun Weippert');
insert into "user" (name) values ('Blythe Chastenet');
insert into "user" (name) values ('Mathew Petren');
insert into "user" (name) values ('Roddie Ianelli');
insert into "user" (name) values ('Emera Weatherley');
insert into "user" (name) values ('Truman Cosford');
insert into "user" (name) values ('Livvyy Wittke');
insert into "user" (name) values ('Sully Osbaldstone');
insert into "user" (name) values ('Damiano Garforth');
insert into "user" (name) values ('Niccolo Texton');
insert into "user" (name) values ('Florinda Yerbury');
insert into "user" (name) values ('Nolana McGrady');
insert into "user" (name) values ('Laurette Coyish');
insert into "user" (name) values ('Jermayne Hallut');
insert into "user" (name) values ('Lacy Possa');
insert into "user" (name) values ('Emmalynne O''Neill');
insert into "user" (name) values ('Bendick Iskov');
insert into "user" (name) values ('Quinn Hargreves');
insert into "user" (name) values ('Westleigh MacKaig');
insert into "user" (name) values ('Emelia Coltman');
insert into "user" (name) values ('Hewe Waulker');
insert into "user" (name) values ('Rozanne Fance');
insert into "user" (name) values ('Carleen Wreakes');
insert into "user" (name) values ('Archibald McNalley');
insert into "user" (name) values ('Rudolf Ficken');
insert into "user" (name) values ('Dud Dockray');
insert into "user" (name) values ('Hannis McGlue');
insert into "user" (name) values ('Gilli Shortall');
insert into "user" (name) values ('Wainwright Arber');
insert into "user" (name) values ('Bernetta Ghirigori');
insert into "user" (name) values ('Care Sante');
insert into "user" (name) values ('Hildy Michel');
insert into "user" (name) values ('Idette Leser');
insert into "user" (name) values ('Kamila Yerrell');
insert into "user" (name) values ('Garvy Taunton.');
insert into "user" (name) values ('Tibold Friett');
insert into "user" (name) values ('Jennie Paal');
insert into "user" (name) values ('Thayne Zannetti');
insert into "user" (name) values ('Waring Kofax');
insert into "user" (name) values ('Alie Bobasch');
insert into "user" (name) values ('Enrichetta Larman');
insert into "user" (name) values ('Dane Chick');
insert into "user" (name) values ('Catie Orpyne');
insert into "user" (name) values ('Tann Crowcher');
insert into "user" (name) values ('Pablo Haker');
insert into "user" (name) values ('Linnie Kuschek');
insert into "user" (name) values ('Arlen Back');
insert into "user" (name) values ('Betti Gibberd');
insert into "user" (name) values ('Lavina Gierardi');
insert into "user" (name) values ('Ibby Ouchterlony');
insert into "user" (name) values ('Rochelle Schoffel');
insert into "user" (name) values ('Lorrayne Alleyn');
insert into "user" (name) values ('Gaultiero Kightly');
insert into "user" (name) values ('Alexandra Kopmann');
insert into "user" (name) values ('Shelagh Kibble');
insert into "user" (name) values ('Jemimah Perren');
insert into "user" (name) values ('Desirae Cochrane');
insert into "user" (name) values ('Patrizio Gaskall');
insert into "user" (name) values ('Britt Scaife');
insert into "user" (name) values ('Roma Jerrolt');
insert into "user" (name) values ('Gino Osipov');
insert into "user" (name) values ('Crista Stolze');
insert into "user" (name) values ('Ivar Smallcombe');
insert into "user" (name) values ('Alberta Normavill');
insert into "user" (name) values ('Shel Sprowell');
insert into "user" (name) values ('Saundra Mitchel');
insert into "user" (name) values ('Amabel Pilkington');
insert into "user" (name) values ('Gavin Tattersill');
insert into "user" (name) values ('Willi Drescher');
insert into "user" (name) values ('Pate Pitts');
insert into "user" (name) values ('Merv Clausson');
insert into "user" (name) values ('Lora Proudler');
insert into "user" (name) values ('Ofelia Street');
insert into "user" (name) values ('Gerry Faire');
insert into "user" (name) values ('Sher Jaslem');
insert into "user" (name) values ('Dollie Pinnigar');
insert into "user" (name) values ('Dion Choake');
insert into "user" (name) values ('Erl Elham');
insert into "user" (name) values ('Isa Philippet');
insert into "user" (name) values ('Conni Burns');
insert into "user" (name) values ('Mamie Chippindale');
insert into "user" (name) values ('Pattin Vella');
insert into "user" (name) values ('Thaxter Baversor');
insert into "user" (name) values ('Bettina Common');
insert into "user" (name) values ('Bobby Curgenven');
insert into "user" (name) values ('Noellyn Agronski');
insert into "user" (name) values ('Zia Beeston');
insert into "user" (name) values ('Oates Livett');
insert into "user" (name) values ('Frederich Tuminini');
insert into "user" (name) values ('Rem Maha');
insert into "user" (name) values ('Jodee Mogra');
insert into "user" (name) values ('Annamarie Eate');
insert into "user" (name) values ('Noach Clibbery');
insert into "user" (name) values ('Percy Waren');
insert into "user" (name) values ('Agathe Challicum');
insert into "user" (name) values ('Kelby Brownbill');
insert into "user" (name) values ('Rickie Worland');
insert into "user" (name) values ('Bess Treeby');
insert into "user" (name) values ('Aleece Ruffles');
insert into "user" (name) values ('Sherri Wildman');
insert into "user" (name) values ('Dorise Maffeo');
insert into "user" (name) values ('Stacy Millwater');
insert into "user" (name) values ('Hodge Yakolev');
insert into "user" (name) values ('Dar Trowle');
insert into "user" (name) values ('Caprice Cloughton');
insert into "user" (name) values ('Angy Hurlin');
insert into "user" (name) values ('Rosette Tuiller');
insert into "user" (name) values ('Liva Thorius');
insert into "user" (name) values ('Derril Straker');
insert into "user" (name) values ('Astra Minchell');
insert into "user" (name) values ('Lela Worwood');
insert into "user" (name) values ('Vitoria Popple');
insert into "user" (name) values ('Bobbie MacCosto');
insert into "user" (name) values ('Leonerd Wolseley');
insert into "user" (name) values ('Geri Sheehan');
insert into "user" (name) values ('Keslie Blest');
insert into "user" (name) values ('Richardo Seid');
insert into "user" (name) values ('Roxane Crocombe');
insert into "user" (name) values ('Missie Tibb');
insert into "user" (name) values ('Sarina Tailby');
insert into "user" (name) values ('Sharyl De Bernardis');
insert into "user" (name) values ('Dur Carroll');
insert into "user" (name) values ('Fielding Campsall');
insert into "user" (name) values ('Denice Ashworth');
insert into "user" (name) values ('Marquita Redish');
insert into "user" (name) values ('Raquel Simmell');
insert into "user" (name) values ('Allina Dicks');
insert into "user" (name) values ('Kaia Saket');
insert into "user" (name) values ('Imogen Jencey');
insert into "user" (name) values ('Pru Bein');
insert into "user" (name) values ('Gabi Bentote');
insert into "user" (name) values ('Darby Campion');
insert into "user" (name) values ('Edwina Vizor');
insert into "user" (name) values ('Amelie Vatini');
insert into "user" (name) values ('Barry Philipson');
insert into "user" (name) values ('Hermine Halligan');
insert into "user" (name) values ('Rosabelle Setterthwait');
insert into "user" (name) values ('Salomo MacSween');
insert into "user" (name) values ('Mel Skilling');
insert into "user" (name) values ('Chris Walkingshaw');
insert into "user" (name) values ('Blaire Wilton');
insert into "user" (name) values ('Ernestus Budnik');
insert into "user" (name) values ('Jed Gabb');
insert into "user" (name) values ('Germain Kures');
insert into "user" (name) values ('Evaleen Sleet');
insert into "user" (name) values ('Roslyn Hounsom');
insert into "user" (name) values ('Eldin Monson');
insert into "user" (name) values ('Shayne Ellyatt');
insert into "user" (name) values ('Debbie Mogey');
insert into "user" (name) values ('Kalindi Bartolic');
insert into "user" (name) values ('Leese Wogden');
insert into "user" (name) values ('Arleta Jakuszewski');
insert into "user" (name) values ('Nata Camblin');
insert into "user" (name) values ('Abigale Pietrowicz');
insert into "user" (name) values ('Dewey Tubb');
insert into "user" (name) values ('Benyamin Port');
insert into "user" (name) values ('Janeva Cannan');
insert into "user" (name) values ('Hillery Cauthra');
insert into "user" (name) values ('Riobard Thebeau');
insert into "user" (name) values ('Hannie Larman');
insert into "user" (name) values ('Rudy Radleigh');
insert into "user" (name) values ('Ignatius Popham');
insert into "user" (name) values ('Emery Vaz');
insert into "user" (name) values ('Katusha Snipe');
insert into "user" (name) values ('Aldon Gavan');
insert into "user" (name) values ('Raimundo Segot');
insert into "user" (name) values ('Saraann Riddler');
insert into "user" (name) values ('Kissiah Hannah');
insert into "user" (name) values ('Morissa Beahan');
insert into "user" (name) values ('Tymothy Lacroux');
insert into "user" (name) values ('Hanny Tuiller');
insert into "user" (name) values ('Lorena Shewsmith');
insert into "user" (name) values ('Sashenka Tabour');
insert into "user" (name) values ('Betsy Bennison');
insert into "user" (name) values ('Dasya Neal');
insert into "user" (name) values ('Chrissie de Werk');
insert into "user" (name) values ('Margarita Baulk');
insert into "user" (name) values ('Annabal Simonard');
insert into "user" (name) values ('Fredrick Shambroke');
insert into "user" (name) values ('Euphemia Letts');
insert into "user" (name) values ('Filmore Cuddihy');
insert into "user" (name) values ('Dulcia Bownde');
insert into "user" (name) values ('Nicki Daice');
insert into "user" (name) values ('See Vasilyev');
insert into "user" (name) values ('Micky Nicholes');
insert into "user" (name) values ('Jena Paulon');
insert into "user" (name) values ('Reg Keable');
insert into "user" (name) values ('Rosaline Cornforth');
insert into "user" (name) values ('Ava Mahaddy');
insert into "user" (name) values ('Mathilda Chandlar');
insert into "user" (name) values ('Pincus Shilvock');
insert into "user" (name) values ('Ibbie Cosgreave');
insert into "user" (name) values ('Emmy Ballchin');
insert into "user" (name) values ('Nedda Hammerich');
insert into "user" (name) values ('Carroll Dowd');
insert into "user" (name) values ('Lindsay Dowber');
insert into "user" (name) values ('Myrvyn Bottomley');
insert into "user" (name) values ('Marcos Brosius');
insert into "user" (name) values ('Hughie Simco');
insert into "user" (name) values ('Wolfy Miquelet');
insert into "user" (name) values ('Karalee Doumer');
insert into "user" (name) values ('Kingsly Dartnall');
insert into "user" (name) values ('Alvan Rowling');
insert into "user" (name) values ('Stanfield Blondelle');
insert into "user" (name) values ('Trixie Klaff');
insert into "user" (name) values ('Max McKendry');
insert into "user" (name) values ('Dominic Gillebride');
insert into "user" (name) values ('Olivette Houten');
insert into "user" (name) values ('Karlik Simoes');
insert into "user" (name) values ('Taryn Bolley');
insert into "user" (name) values ('Marthe Jumeau');
insert into "user" (name) values ('Malva Labdon');
insert into "user" (name) values ('Gabriella Rontsch');
insert into "user" (name) values ('Isaak Treverton');
insert into "user" (name) values ('Blondy Preene');
insert into "user" (name) values ('Lorilee Hutchens');
insert into "user" (name) values ('Kynthia Burle');
insert into "user" (name) values ('Pernell Smither');
insert into "user" (name) values ('Rodrigo Timmes');
insert into "user" (name) values ('Greta Surmon');
insert into "user" (name) values ('Carlene Benjafield');
insert into "user" (name) values ('Bernete Kiendl');
insert into "user" (name) values ('Fifi Franklen');
insert into "user" (name) values ('Vere Woolf');
insert into "user" (name) values ('Clair Foort');
insert into "user" (name) values ('Ardeen Seel');
insert into "user" (name) values ('Chiquia Tudhope');
insert into "user" (name) values ('Haskell Blunt');
insert into "user" (name) values ('Angelique Curado');
insert into "user" (name) values ('Morris Orhtmann');
insert into "user" (name) values ('Shaun Holwell');
insert into "user" (name) values ('Cymbre Armell');
insert into "user" (name) values ('Brett Yendle');
insert into "user" (name) values ('Blayne Matthensen');
insert into "user" (name) values ('Gib Naulty');
insert into "user" (name) values ('Rowena Kuscha');
insert into "user" (name) values ('Deb Esser');
insert into "user" (name) values ('Mirella Judge');
insert into "user" (name) values ('Modesta Gunson');
insert into "user" (name) values ('Andrej Hrus');
insert into "user" (name) values ('Agnola Aronoff');
insert into "user" (name) values ('Evangelina Castello');
insert into "user" (name) values ('Rodrick Ishaki');
insert into "user" (name) values ('Lynda Boothby');
insert into "user" (name) values ('Ettore Warrior');
insert into "user" (name) values ('Roselle Wiper');
insert into "user" (name) values ('Mabel Barthelmes');
insert into "user" (name) values ('Woodie Sharman');
insert into "user" (name) values ('Rose Murrhaupt');
insert into "user" (name) values ('Pammie Loughman');
insert into "user" (name) values ('Krispin Greiswood');
insert into "user" (name) values ('Rianon Diche');
insert into "user" (name) values ('Elisha Tarrant');
insert into "user" (name) values ('Lilla Belliveau');
insert into "user" (name) values ('Marlene Clissett');
insert into "user" (name) values ('Marcus Herculson');
insert into "user" (name) values ('Horst Bryers');
insert into "user" (name) values ('Pietrek Lapslie');
insert into "user" (name) values ('Olive Grono');
insert into "user" (name) values ('Ewen Heys');
insert into "user" (name) values ('Estrellita Speddin');
insert into "user" (name) values ('Iormina Cowing');
insert into "user" (name) values ('Sumner Burne');
insert into "user" (name) values ('Billi Hambly');
insert into "user" (name) values ('Jephthah Mansuer');
insert into "user" (name) values ('Cherida Demonge');
insert into "user" (name) values ('Quillan Denacamp');
insert into "user" (name) values ('Thibaud Vellden');
insert into "user" (name) values ('Riobard Saddleton');
insert into "user" (name) values ('Kendell Ciccone');
insert into "user" (name) values ('Sibel Purviss');
insert into "user" (name) values ('Christian Biset');
insert into "user" (name) values ('Sheilah Hatto');
insert into "user" (name) values ('Lucy Angrock');
insert into "user" (name) values ('Brien Glasscott');
insert into "user" (name) values ('Ami Tivers');
insert into "user" (name) values ('Edgar Crannach');
insert into "user" (name) values ('Fidelio North');
insert into "user" (name) values ('Billy Chattelaine');
insert into "user" (name) values ('Maury Crosthwaite');
insert into "user" (name) values ('Pen Stroobant');
insert into "user" (name) values ('Edvard Grishaev');
insert into "user" (name) values ('Abbye Clemenzi');
insert into "user" (name) values ('Felicity Tegeller');
insert into "user" (name) values ('Matty Ceyssen');
insert into "user" (name) values ('Van Romaine');
insert into "user" (name) values ('Griz Kitchingham');
insert into "user" (name) values ('Virginia Bulgen');
insert into "user" (name) values ('Aurlie Layne');
insert into "user" (name) values ('Cary Moth');
insert into "user" (name) values ('Melisenda de Glanville');
insert into "user" (name) values ('Ignace Reinmar');
insert into "user" (name) values ('Loralyn Elwood');
insert into "user" (name) values ('Andie Faiers');
insert into "user" (name) values ('Nicolette Baumann');
insert into "user" (name) values ('Etti Annwyl');
insert into "user" (name) values ('Isac Vaudin');
insert into "user" (name) values ('Ofelia Gallihaulk');
insert into "user" (name) values ('Damita Lovell');
insert into "user" (name) values ('Kenon Maccrie');
insert into "user" (name) values ('Cass Dilnot');
insert into "user" (name) values ('Dimitri Tant');
insert into "user" (name) values ('Harp Andrat');
insert into "user" (name) values ('Hogan Tibald');
insert into "user" (name) values ('Bondy Peak');
insert into "user" (name) values ('Thekla Croyser');
insert into "user" (name) values ('Drusi Behrend');
insert into "user" (name) values ('Bel Corke');
insert into "user" (name) values ('Keri Thrift');
insert into "user" (name) values ('Reggi Prickett');
insert into "user" (name) values ('Giulietta Wolfenden');
insert into "user" (name) values ('Laureen Tidey');
insert into "user" (name) values ('Lonna Jaskowicz');
insert into "user" (name) values ('Hewitt Abrahmer');
insert into "user" (name) values ('Sharai Frentz');
insert into "user" (name) values ('Chadwick Gott');
insert into "user" (name) values ('Judi Paradin');
insert into "user" (name) values ('Debora Westphalen');
insert into "user" (name) values ('Garek Mattingson');
insert into "user" (name) values ('Hi Jarrel');
insert into "user" (name) values ('Waverly Meckiff');
insert into "user" (name) values ('Phaidra Willerstone');
insert into "user" (name) values ('Ferdy Gaul');
insert into "user" (name) values ('Bevin Paddingdon');
insert into "user" (name) values ('Herschel Warlowe');
insert into "user" (name) values ('Virgilio McGivena');
insert into "user" (name) values ('Matteo Caudray');
insert into "user" (name) values ('Helen-elizabeth Blackford');
insert into "user" (name) values ('Reine Byer');
insert into "user" (name) values ('Delores Jeroch');
insert into "user" (name) values ('Elly Laidlow');
insert into "user" (name) values ('Edin Muckloe');
insert into "user" (name) values ('Hadlee Netherwood');
insert into "user" (name) values ('Gavan Blest');
insert into "user" (name) values ('Teodorico Giottoi');
insert into "user" (name) values ('Ashton Beric');
insert into "user" (name) values ('Antony Newlands');
insert into "user" (name) values ('Peder Beardwood');
insert into "user" (name) values ('Bayard Chismon');
insert into "user" (name) values ('Berry Dacks');
insert into "user" (name) values ('Damian Antoszewski');
insert into "user" (name) values ('Tiffani Brinkworth');
insert into "user" (name) values ('Ezri Giovannini');
insert into "user" (name) values ('Marj McGovern');
insert into "user" (name) values ('Lorenzo Amey');
insert into "user" (name) values ('Federica Vize');
insert into "user" (name) values ('Darwin Shapcote');
insert into "user" (name) values ('Sal Wixey');
insert into "user" (name) values ('Gabriella Belbin');
insert into "user" (name) values ('Goldie Hevey');
insert into "user" (name) values ('Mose Ritchie');
insert into "user" (name) values ('Lianna Gerardeaux');
insert into "user" (name) values ('Gusti Ragsdall');
insert into "user" (name) values ('Ozzie Agerskow');
insert into "user" (name) values ('Charo Copins');
insert into "user" (name) values ('Berrie Lenoir');
insert into "user" (name) values ('Skipton McGarrie');
insert into "user" (name) values ('Ade Bradley');
insert into "user" (name) values ('Efrem Tarplee');
insert into "user" (name) values ('Rouvin Southers');
insert into "user" (name) values ('Waylin Chiverton');
insert into "user" (name) values ('Terrel Whittall');
insert into "user" (name) values ('Chloette Talkington');
insert into "user" (name) values ('Zaria Skotcher');
insert into "user" (name) values ('Saba Duncanson');
insert into "user" (name) values ('Kerri Losemann');
insert into "user" (name) values ('Mordecai Casetta');
insert into "user" (name) values ('Diannne Pleasance');
insert into "user" (name) values ('Saudra Burghall');
insert into "user" (name) values ('Arel Kaszper');
insert into "user" (name) values ('Starr Breydin');
insert into "user" (name) values ('Cherise Benza');
insert into "user" (name) values ('Elwira Degenhardt');
insert into "user" (name) values ('Leo Wellesley');
insert into "user" (name) values ('Marlyn Brussels');
insert into "user" (name) values ('Daisi Franceschino');
insert into "user" (name) values ('Marion Carlan');
insert into "user" (name) values ('Blancha Tures');
insert into "user" (name) values ('Cher Aves');
insert into "user" (name) values ('Davidde Parramore');
insert into "user" (name) values ('Avictor Pincked');
insert into "user" (name) values ('Hagan Birchill');
insert into "user" (name) values ('Zelig Granleese');
insert into "user" (name) values ('Finn Hubbard');
insert into "user" (name) values ('Vivianna Grissett');
insert into "user" (name) values ('Kellby Gladbach');
insert into "user" (name) values ('Cristal Cundy');
insert into "user" (name) values ('Christoforo Cheesman');
insert into "user" (name) values ('Myrlene D''orsay');
insert into "user" (name) values ('Bancroft Lenaghen');
insert into "user" (name) values ('Marcelia Barnard');
insert into "user" (name) values ('Verney Danieli');
insert into "user" (name) values ('Carlos Camden');
insert into "user" (name) values ('Axe Bartocci');
insert into "user" (name) values ('Kristian Frostdyke');
insert into "user" (name) values ('Kamilah Belloch');
insert into "user" (name) values ('Ray Attryde');
insert into "user" (name) values ('Jewelle Churchlow');
insert into "user" (name) values ('Gus Pattenden');
insert into "user" (name) values ('Corrine Sokill');
insert into "user" (name) values ('Juanita Leitch');
insert into "user" (name) values ('Cher Imison');
insert into "user" (name) values ('Sib Mazzeo');
insert into "user" (name) values ('Lamont Martill');
insert into "user" (name) values ('Evelin Spencer');
insert into "user" (name) values ('Moyra Berrane');
insert into "user" (name) values ('Georgie Glazer');
insert into "user" (name) values ('George Gallagher');
insert into "user" (name) values ('Edgar Dufer');
insert into "user" (name) values ('Catarina Barta');
insert into "user" (name) values ('Sella Podbury');
insert into "user" (name) values ('Gorden Klimke');
insert into "user" (name) values ('Karol Naulty');
insert into "user" (name) values ('Cissiee Fouch');
insert into "user" (name) values ('Constancia Kunneke');
insert into "user" (name) values ('Alina Callway');
insert into "user" (name) values ('Lexy Abadam');
insert into "user" (name) values ('Pearle Bruni');
insert into "user" (name) values ('Chev Alenikov');
insert into "user" (name) values ('Hatti Barcke');
insert into "user" (name) values ('Tamar Blockwell');
insert into "user" (name) values ('Justine Caney');
insert into "user" (name) values ('Zorine Parkin');
insert into "user" (name) values ('Caprice Delamar');
insert into "user" (name) values ('Eustace Petrulis');
insert into "user" (name) values ('Lauren Craister');
insert into "user" (name) values ('Sascha Deegan');
insert into "user" (name) values ('Odele Bool');
insert into "user" (name) values ('Miguel Cleobury');
insert into "user" (name) values ('Clarice Foster');
insert into "user" (name) values ('Gregor Haseley');
insert into "user" (name) values ('Loise Colvine');
insert into "user" (name) values ('Gilles Weall');
insert into "user" (name) values ('Jacklin Friel');
insert into "user" (name) values ('Hugh Room');
insert into "user" (name) values ('Dorisa Furmonger');
insert into "user" (name) values ('Lyell Gilmartin');
insert into "user" (name) values ('Libbie Henric');
insert into "user" (name) values ('Cullen Larkkem');
insert into "user" (name) values ('Marlin Segge');
insert into "user" (name) values ('Nada Pavolillo');
insert into "user" (name) values ('Farlee Getten');
insert into "user" (name) values ('Cherye McGerraghty');
insert into "user" (name) values ('Joni Haddinton');
insert into "user" (name) values ('Alethea Brandom');
insert into "user" (name) values ('Bertine Hinksen');
insert into "user" (name) values ('Eldon Rosenstiel');
insert into "user" (name) values ('Fleur Iacapucci');
insert into "user" (name) values ('Harold Kingcott');
insert into "user" (name) values ('Mattie Welband');
insert into "user" (name) values ('Jessey Anglish');
insert into "user" (name) values ('Melissa Begin');
insert into "user" (name) values ('Melisent Razoux');
insert into "user" (name) values ('Ozzie Jerzykiewicz');
insert into "user" (name) values ('Viviene Beeres');
insert into "user" (name) values ('Kory Course');
insert into "user" (name) values ('Herbie Blasiak');
insert into "user" (name) values ('Flore Kubat');
insert into "user" (name) values ('Theresa Irlam');
insert into "user" (name) values ('Melli Aizikovich');
insert into "user" (name) values ('Ynes Catford');
insert into "user" (name) values ('Purcell Ryal');
insert into "user" (name) values ('Dolf Looby');
insert into "user" (name) values ('Trey Alps');
insert into "user" (name) values ('Rosalinde Ethelston');
insert into "user" (name) values ('Bette Muro');
insert into "user" (name) values ('Haskel Elie');
insert into "user" (name) values ('Dyanne Franey');
insert into "user" (name) values ('Benito Volante');
insert into "user" (name) values ('Heinrick Cescon');
insert into "user" (name) values ('Liana Boston');
insert into "user" (name) values ('Arabelle Zamudio');
insert into "user" (name) values ('Cherianne Raccio');
insert into "user" (name) values ('Rozanna Ganiclef');
insert into "user" (name) values ('Tansy Ryce');
insert into "user" (name) values ('Jon Francomb');
insert into "user" (name) values ('Isidore Heaven');
insert into "user" (name) values ('Lynsey Trustey');
insert into "user" (name) values ('Georgianna Scotson');
insert into "user" (name) values ('Kippy Marder');
insert into "user" (name) values ('Fairfax Semple');
insert into "user" (name) values ('Charlean Smaling');
insert into "user" (name) values ('Gray Henstone');
insert into "user" (name) values ('Jasun Muzzall');
insert into "user" (name) values ('Thayne Russi');
insert into "user" (name) values ('Anabel Parlet');
insert into "user" (name) values ('Amabelle Showering');
insert into "user" (name) values ('Booth Piller');
insert into "user" (name) values ('Agnola Radley');
insert into "user" (name) values ('Sharia McColl');
insert into "user" (name) values ('Melantha Middell');
insert into "user" (name) values ('Helli Taylorson');
insert into "user" (name) values ('Tracey Toward');
insert into "user" (name) values ('Clay Rabb');
insert into "user" (name) values ('Gerda Settle');
insert into "user" (name) values ('Pet Marfell');
insert into "user" (name) values ('Florencia Satterley');
insert into "user" (name) values ('Diann Whelband');
insert into "user" (name) values ('Ricky Loade');
insert into "user" (name) values ('Eddie Stinton');
insert into "user" (name) values ('Cordelia Mynett');
insert into "user" (name) values ('Doll Lomas');
insert into "user" (name) values ('Ernest Clifton');
insert into "user" (name) values ('Emlynne Janoch');
insert into "user" (name) values ('Mable Colborn');
insert into "user" (name) values ('Newton Damerell');
insert into "user" (name) values ('Cornall Dey');
insert into "user" (name) values ('Sarine Skitch');
insert into "user" (name) values ('Ashly Fuchs');
insert into "user" (name) values ('Danie Haith');
insert into "user" (name) values ('Hewet Hurring');
insert into "user" (name) values ('Robby Maffey');
insert into "user" (name) values ('Hyman Dibb');
insert into "user" (name) values ('Gilberta Lockyear');
insert into "user" (name) values ('Abelard Tiley');
insert into "user" (name) values ('Javier Setter');
insert into "user" (name) values ('Romola Flacknell');
insert into "user" (name) values ('Malcolm Eliot');
insert into "user" (name) values ('Paige Alpes');
insert into "user" (name) values ('Laraine Baumber');
insert into "user" (name) values ('Moss Baldam');
insert into "user" (name) values ('Ibrahim Eytel');
insert into "user" (name) values ('Kelby Taffarello');
insert into "user" (name) values ('Boothe Ghion');
insert into "user" (name) values ('Gerhardine Trewhitt');
insert into "user" (name) values ('Ben Iacovolo');
insert into "user" (name) values ('Torrence Radnage');
insert into "user" (name) values ('Amos Semered');
insert into "user" (name) values ('Sandie Sandys');
insert into "user" (name) values ('Dory Brewett');
insert into "user" (name) values ('Eadie Seaton');
insert into "user" (name) values ('Jo-ann Volonte');
insert into "user" (name) values ('Leonie Schoroder');
insert into "user" (name) values ('Timothy Campes');
insert into "user" (name) values ('Homerus De Anesy');
insert into "user" (name) values ('Katalin Proudman');
insert into "user" (name) values ('Norrie Emanuelli');
insert into "user" (name) values ('Deeyn Borel');
insert into "user" (name) values ('Guthrey Pranger');
insert into "user" (name) values ('Vivyan Gillbey');
insert into "user" (name) values ('Pavla Cowey');
insert into "user" (name) values ('Hale Joye');
insert into "user" (name) values ('Maud Hanbury');
insert into "user" (name) values ('Sly Tomkins');
insert into "user" (name) values ('Verile Rigg');
insert into "user" (name) values ('Tommie Rowlson');
insert into "user" (name) values ('Nerti Pawfoot');
insert into "user" (name) values ('Bruce Scanderet');
insert into "user" (name) values ('Agosto Benley');
insert into "user" (name) values ('Murdoch Overlow');
insert into "user" (name) values ('Deloris Garlicke');
insert into "user" (name) values ('Celinda Gabites');
insert into "user" (name) values ('Palmer Calderonello');
insert into "user" (name) values ('Celina Binfield');
insert into "user" (name) values ('Tilly Gerasch');
insert into "user" (name) values ('Belinda Chant');
insert into "user" (name) values ('Queenie Borel');
insert into "user" (name) values ('Sibyl Tipling');
insert into "user" (name) values ('Myrlene Kiwitz');
insert into "user" (name) values ('Tremayne Legendre');
insert into "user" (name) values ('Zollie Oehme');
insert into "user" (name) values ('Dean Orhtmann');
insert into "user" (name) values ('Carmelina Mitkin');
insert into "user" (name) values ('Karina Larby');
insert into "user" (name) values ('Miner Lomis');
insert into "user" (name) values ('Sukey Utteridge');
insert into "user" (name) values ('Beverlie Vouls');
insert into "user" (name) values ('Ferrell Gainsbury');
insert into "user" (name) values ('Trueman Aliman');
insert into "user" (name) values ('Sisely Romushkin');
insert into "user" (name) values ('Genvieve Pollard');
insert into "user" (name) values ('Kyla Yurocjkin');
insert into "user" (name) values ('Oswell Ramas');
insert into "user" (name) values ('Starlene Kimbell');
insert into "user" (name) values ('Ibrahim Claffey');
insert into "user" (name) values ('Nathaniel Dungey');
insert into "user" (name) values ('Shanon Ranaghan');
insert into "user" (name) values ('Bevan Pardi');
insert into "user" (name) values ('Viviene Lorden');
insert into "user" (name) values ('Gerome McQuilty');
insert into "user" (name) values ('Tiffani Pyrton');
insert into "user" (name) values ('Suzie Reader');
insert into "user" (name) values ('Marcelle Swanborrow');
insert into "user" (name) values ('Corabella Roubeix');
insert into "user" (name) values ('Jaquenette Cordell');
insert into "user" (name) values ('Aland Chorlton');
insert into "user" (name) values ('Candice Burless');
insert into "user" (name) values ('Gideon Tucknott');
insert into "user" (name) values ('Aylmer Arkow');
insert into "user" (name) values ('Leticia Senchenko');
insert into "user" (name) values ('Ariella Klimt');
insert into "user" (name) values ('Chaddie Mayman');
insert into "user" (name) values ('Keefe Simonyi');
insert into "user" (name) values ('Tonya Shead');
insert into "user" (name) values ('Marcy Greber');
insert into "user" (name) values ('Hadleigh Scoggan');
insert into "user" (name) values ('Kendell Gogarty');
insert into "user" (name) values ('Constantina Kildale');
insert into "user" (name) values ('Lorie Yeowell');
insert into "user" (name) values ('Christoffer Lillecrop');
insert into "user" (name) values ('Urban Vanin');
insert into "user" (name) values ('Bobette Kleint');
insert into "user" (name) values ('Rudyard Arkill');
insert into "user" (name) values ('Elsey Seamen');
insert into "user" (name) values ('Lilla Esson');
insert into "user" (name) values ('Claudina Saterweyte');
insert into "user" (name) values ('Marylin Anderson');
insert into "user" (name) values ('Trev Vella');
insert into "user" (name) values ('Gabriel Haacker');
insert into "user" (name) values ('Lanny Adamik');
insert into "user" (name) values ('Della Jarrette');
insert into "user" (name) values ('Free Grice');
insert into "user" (name) values ('Basia Broadfoot');
insert into "user" (name) values ('Lorrie Camelia');
insert into "user" (name) values ('Bancroft Matthieson');
insert into "user" (name) values ('Chevalier Hadgkiss');
insert into "user" (name) values ('Julee Franchioni');
insert into "user" (name) values ('Austen Stanett');
insert into "user" (name) values ('Rheta Leatherborrow');
insert into "user" (name) values ('Florence Kaplan');
insert into "user" (name) values ('Tobye Fonquernie');
insert into "user" (name) values ('Mariya Broadbury');
insert into "user" (name) values ('Rolando Cranfield');
insert into "user" (name) values ('Dominique Jacobovitz');
insert into "user" (name) values ('Brandtr Dobbie');
insert into "user" (name) values ('Artemis Mattedi');
insert into "user" (name) values ('Arline Sayward');
insert into "user" (name) values ('Mallory Jambrozek');
insert into "user" (name) values ('Romain Duiguid');
insert into "user" (name) values ('Lazaro Snedker');
insert into "user" (name) values ('Lavina Justham');
insert into "user" (name) values ('Nicolina Kitchaside');
insert into "user" (name) values ('Olvan Begent');
insert into "user" (name) values ('Gizela Poulston');
insert into "user" (name) values ('Margareta Barthelme');
insert into "user" (name) values ('Jessamyn Sauvain');
insert into "user" (name) values ('Devin Tregunna');
insert into "user" (name) values ('Lorens Keme');
insert into "user" (name) values ('Heda Nardoni');
insert into "user" (name) values ('Corabelle Bolt');
insert into "user" (name) values ('Corbet Penkethman');
insert into "user" (name) values ('Felice Lapping');
insert into "user" (name) values ('Rosana Bernetti');
insert into "user" (name) values ('Lemuel O''Regan');
insert into "user" (name) values ('Jacqui Richardes');
insert into "user" (name) values ('Dicky Firbank');
insert into "user" (name) values ('Thedric Lendon');
insert into "user" (name) values ('Laurene Ouchterlony');
insert into "user" (name) values ('Archibaldo Charke');
insert into "user" (name) values ('Amble Mease');
insert into "user" (name) values ('Frederigo Bru');
insert into "user" (name) values ('Jobye Clipson');
insert into "user" (name) values ('Lin Chesterfield');
insert into "user" (name) values ('Marijo Pleat');
insert into "user" (name) values ('Cornell Goodby');
insert into "user" (name) values ('Laurie Dubble');
insert into "user" (name) values ('Berkeley Emps');
insert into "user" (name) values ('Dona Frude');
insert into "user" (name) values ('Jessie Sacks');
insert into "user" (name) values ('Juliana Parminter');
insert into "user" (name) values ('Hakim Jeves');
insert into "user" (name) values ('Haywood Vivers');
insert into "user" (name) values ('Farlee Aizikovitch');
insert into "user" (name) values ('Harper Petherick');
insert into "user" (name) values ('Erda Really');
insert into "user" (name) values ('Josefina Plumptre');
insert into "user" (name) values ('Lyssa Penhale');
insert into "user" (name) values ('Cross Brafferton');
insert into "user" (name) values ('Yancey Mandal');
insert into "user" (name) values ('Maighdiln Collimore');
insert into "user" (name) values ('Baldwin Kneeshaw');
insert into "user" (name) values ('Gifford Cannell');
insert into "user" (name) values ('Eddy Lamdin');
insert into "user" (name) values ('Martelle Kubas');
insert into "user" (name) values ('Elmira Moralis');
insert into "user" (name) values ('Natalee Sides');
insert into "user" (name) values ('Todd Savell');
insert into "user" (name) values ('Vanessa Lemmer');
insert into "user" (name) values ('Nicolas Rowthorne');
insert into "user" (name) values ('Cthrine Helin');
insert into "user" (name) values ('Mei Keyse');
insert into "user" (name) values ('Matthaeus Buey');
insert into "user" (name) values ('Sibbie Stoyle');
insert into "user" (name) values ('Ambur McAughtry');
insert into "user" (name) values ('Frasquito Celier');
insert into "user" (name) values ('Worthy Harsnipe');
insert into "user" (name) values ('Rasia Cloke');
insert into "user" (name) values ('Kimberlyn Orrey');
insert into "user" (name) values ('Giselbert McGlew');
insert into "user" (name) values ('Sigrid Sheldon');
insert into "user" (name) values ('Olva Copins');
insert into "user" (name) values ('Devina Fleeman');
insert into "user" (name) values ('Astrix Espinas');
insert into "user" (name) values ('Logan Skehens');
insert into "user" (name) values ('Aimil Loffhead');
insert into "user" (name) values ('Tonye Grafton');
insert into "user" (name) values ('Hermina Dalloway');
insert into "user" (name) values ('Melamie Fuggle');
insert into "user" (name) values ('Sindee Barme');
insert into "user" (name) values ('Aretha Snawdon');
insert into "user" (name) values ('Crosby Raise');
insert into "user" (name) values ('Wiatt Bruggeman');
insert into "user" (name) values ('Juliane MacWilliam');
insert into "user" (name) values ('Harris Ceely');
insert into "user" (name) values ('King Benning');
insert into "user" (name) values ('Rolfe Craise');
insert into "user" (name) values ('Jodee Mathen');
insert into "user" (name) values ('Orel Staley');
insert into "user" (name) values ('Giovanni Sefton');
insert into "user" (name) values ('Marlo Chadbourn');
insert into "user" (name) values ('Maynard Watsam');
insert into "user" (name) values ('Hurleigh Lude');
insert into "user" (name) values ('Levy Berrecloth');
insert into "user" (name) values ('Lane Foch');
insert into "user" (name) values ('Randy Nisius');
insert into "user" (name) values ('Maurizio McIlvenna');
insert into "user" (name) values ('Lorrayne Dupoy');
insert into "user" (name) values ('Bobby Upham');
insert into "user" (name) values ('Malissa Bridgwood');
insert into "user" (name) values ('Loralie MacGilmartin');
insert into "user" (name) values ('Gertrude Pitblado');
insert into "user" (name) values ('Emanuele Dopson');
insert into "user" (name) values ('Junia Elcy');
insert into "user" (name) values ('Mordecai Alpes');
insert into "user" (name) values ('Bradney Dauby');
insert into "user" (name) values ('Robbin Decourcy');
insert into "user" (name) values ('Cthrine Luetkemeyers');
insert into "user" (name) values ('Milka Ickov');
insert into "user" (name) values ('Willabella Nicholas');
insert into "user" (name) values ('Ernesta Giovanizio');
insert into "user" (name) values ('Odille Gumary');
insert into "user" (name) values ('Dolley Bowlands');
insert into "user" (name) values ('Tildie Tiebe');
insert into "user" (name) values ('Anatol Jouandet');
insert into "user" (name) values ('Ogden Montel');
insert into "user" (name) values ('Ingra Quogan');
insert into "user" (name) values ('Kass Filkov');
insert into "user" (name) values ('Agnes Mannagh');
insert into "user" (name) values ('Tori Grievson');
insert into "user" (name) values ('Dara Nowlan');
insert into "user" (name) values ('Claus Paulsson');
insert into "user" (name) values ('Reggi Robjents');
insert into "user" (name) values ('Odelle Steven');
insert into "user" (name) values ('Elsbeth Letson');
insert into "user" (name) values ('Justinn Leve');
insert into "user" (name) values ('Jerrold Pittway');
insert into "user" (name) values ('Heda Beelby');
insert into "user" (name) values ('Alvinia Cressingham');
insert into "user" (name) values ('Lauraine Campione');
insert into "user" (name) values ('Lennie Bleiman');
insert into "user" (name) values ('Mandy MacGowan');
insert into "user" (name) values ('Vasily Drew');
insert into "user" (name) values ('Lilith Salasar');
insert into "user" (name) values ('Jed Lepope');
insert into "user" (name) values ('Arly Worsnap');
insert into "user" (name) values ('Pepito Lawson');
insert into "user" (name) values ('Tull Clemence');
insert into "user" (name) values ('Roxy Drewry');
insert into "user" (name) values ('Gaylord Grinin');
insert into "user" (name) values ('Lorraine Dibble');
insert into "user" (name) values ('Yankee Wagge');
insert into "user" (name) values ('Farris Duchart');
insert into "user" (name) values ('Annnora Ingledow');
insert into "user" (name) values ('Elicia Auchinleck');
insert into "user" (name) values ('Jarid Dominico');
insert into "user" (name) values ('Sibel Labbez');
insert into "user" (name) values ('Meredeth McDowall');
insert into "user" (name) values ('Lon Lembrick');
insert into "user" (name) values ('Sal Juliano');
insert into "user" (name) values ('Shari Shortcliffe');
insert into "user" (name) values ('Elisa Mowbray');
insert into "user" (name) values ('Anton Dumbell');
insert into "user" (name) values ('Arnold Blaw');
insert into "user" (name) values ('Jacklin Fairhall');
insert into "user" (name) values ('Jacki Manuelli');
insert into "user" (name) values ('Jere Wickey');
insert into "user" (name) values ('Wolf Bywater');
insert into "user" (name) values ('Lockwood Lockey');
insert into "user" (name) values ('Christina Siene');
insert into "user" (name) values ('Dallis Zaniolini');
insert into "user" (name) values ('Harri Vokes');
insert into "user" (name) values ('Kelli Petyakov');
insert into "user" (name) values ('Tobe Featonby');
insert into "user" (name) values ('Dee dee Leas');
insert into "user" (name) values ('Bonni Mankor');
insert into "user" (name) values ('Farr Chiommienti');
insert into "user" (name) values ('Eliza Bernardoux');
insert into "user" (name) values ('Joelle Ouslem');
insert into "user" (name) values ('Lauren MacTimpany');
insert into "user" (name) values ('Kissie Bunt');
insert into "user" (name) values ('Trish Dearness');
insert into "user" (name) values ('Wyatan Aspinwall');
insert into "user" (name) values ('Celestyna Belfit');
insert into "user" (name) values ('Charline Speight');
insert into "user" (name) values ('Raffaello Whittenbury');
insert into "user" (name) values ('Miranda Scales');
insert into "user" (name) values ('Wynny Penright');
insert into "user" (name) values ('Isak Morpeth');
insert into "user" (name) values ('Crosby Milington');
insert into "user" (name) values ('Jens Chetwind');
insert into "user" (name) values ('Tomi Honeywood');
insert into "user" (name) values ('Kimberly Engelbrecht');
insert into "user" (name) values ('Adela Gatecliffe');
insert into "user" (name) values ('Loleta Barbour');
insert into "user" (name) values ('Tymon Dowbiggin');
insert into "user" (name) values ('Giralda Hanscomb');
insert into "user" (name) values ('Gwenora Conman');
insert into "user" (name) values ('Fairlie Basey');
insert into "user" (name) values ('Dacia Pattisson');
insert into "user" (name) values ('Lorilee Yerlett');
insert into "user" (name) values ('Vivia Ceaplen');
insert into "user" (name) values ('Ardeen Kellen');
insert into "user" (name) values ('Nicolas Stollwerck');
insert into "user" (name) values ('Granger Guislin');
insert into "user" (name) values ('Kristy Venediktov');
insert into "user" (name) values ('Gerry Eddins');
insert into "user" (name) values ('Ginny Bilovus');
insert into "user" (name) values ('Graeme Bluck');
insert into "user" (name) values ('Reeta Durek');
insert into "user" (name) values ('Fania Parman');
insert into "user" (name) values ('Nester Pack');
insert into "user" (name) values ('Arabele Kopfer');
insert into "user" (name) values ('Micheal Presnell');
insert into "user" (name) values ('Brendis Holliar');
insert into "user" (name) values ('Wyatt Coult');
insert into "user" (name) values ('Sasha McCluney');
insert into "user" (name) values ('Louie Loudyan');
insert into "user" (name) values ('Timmi Goodlife');
insert into "user" (name) values ('Mychal Goman');
insert into "user" (name) values ('Ingmar Scolding');
insert into "user" (name) values ('Kane Moggan');
insert into "user" (name) values ('Branden Orbon');
insert into "user" (name) values ('Chloette Masding');
insert into "user" (name) values ('Laurena Shearmer');
insert into "user" (name) values ('Janifer Cattanach');
insert into "user" (name) values ('Korry Gaiford');
insert into "user" (name) values ('Robbin Pinchback');
insert into "user" (name) values ('Deanna Collymore');
insert into "user" (name) values ('Burtie Pennell');
insert into "user" (name) values ('Lorelle Gibbin');
insert into "user" (name) values ('Lynnette Blackstock');
insert into "user" (name) values ('Ilyssa Jennrich');
insert into "user" (name) values ('Jordan Newsome');
insert into "user" (name) values ('Terence Bushell');
insert into "user" (name) values ('Ashlen Pryn');
insert into "user" (name) values ('Kamilah Frame');
insert into "user" (name) values ('Inigo Sigg');
insert into "user" (name) values ('Dorothea Stang-Gjertsen');
insert into "user" (name) values ('Nikkie De Gogay');
insert into "user" (name) values ('Vasily Emmerson');
insert into "user" (name) values ('Hertha Rosbottom');
insert into "user" (name) values ('Jerad Elbourne');
insert into "user" (name) values ('Oswell Varsey');
insert into "user" (name) values ('Aretha Derle');
insert into "user" (name) values ('Marleah Cartmer');
insert into "user" (name) values ('Rochette Fearnehough');
insert into "user" (name) values ('Aurore Rilton');
insert into "user" (name) values ('Danita Chieze');
insert into "user" (name) values ('Ferguson Langston');
insert into "user" (name) values ('Enrico Rojel');
insert into "user" (name) values ('Field Farnish');
insert into "user" (name) values ('Cori Benasik');
insert into "user" (name) values ('Phil Buesden');
insert into "user" (name) values ('Stephan Kmieciak');
insert into "user" (name) values ('Lucien Norgan');
insert into "user" (name) values ('Dag Easbie');
insert into "user" (name) values ('Car Nast');
insert into "user" (name) values ('Kordula Triebner');
insert into "user" (name) values ('Jake Broker');
insert into "user" (name) values ('Oswell Varley');
insert into "user" (name) values ('Arlyn Langtree');
insert into "user" (name) values ('Jere Butts');
insert into "user" (name) values ('Claudette Marquess');
insert into "user" (name) values ('Katina Cabral');
insert into "user" (name) values ('Daphna Duxfield');
insert into "user" (name) values ('Glen Conduit');
insert into "user" (name) values ('Lanita Chasson');
insert into "user" (name) values ('Bartholomeo Burrage');
insert into "user" (name) values ('Cathryn Perago');
insert into "user" (name) values ('Vasilis Wetherburn');
insert into "user" (name) values ('Merrili Chave');
insert into "user" (name) values ('Lynda Hurdis');
insert into "user" (name) values ('Ciro Lovat');
insert into "user" (name) values ('Loren Bellam');
insert into "user" (name) values ('Bobbie Pepperell');
insert into "user" (name) values ('Dene Bondesen');
insert into "user" (name) values ('Estell Downham');
insert into "user" (name) values ('Ashia Espina');
insert into "user" (name) values ('Keir Kitt');
insert into "user" (name) values ('Haleigh Davson');
insert into "user" (name) values ('Trueman Conor');
insert into "user" (name) values ('Quintana Tackett');
insert into "user" (name) values ('Briano Probbing');
insert into "user" (name) values ('Cody Torri');
insert into "user" (name) values ('Gail Balazot');
insert into "user" (name) values ('Freedman Cottell');
insert into "user" (name) values ('Kesley Hedylstone');
insert into "user" (name) values ('Keefer Witcomb');
insert into "user" (name) values ('Ulric Claiton');
insert into "user" (name) values ('Ingelbert Lothean');
insert into "user" (name) values ('Jennine Philipard');
insert into "user" (name) values ('Siusan Ciccone');
insert into "user" (name) values ('Hamlen Lamke');
insert into "user" (name) values ('Hendrik Pringour');
insert into "user" (name) values ('Rosalynd Loche');
insert into "user" (name) values ('Shaina Thackwray');
insert into "user" (name) values ('Helen Gilfoyle');
insert into "user" (name) values ('Solly Klageman');
insert into "user" (name) values ('Clive Scimonelli');
insert into "user" (name) values ('Ricky Vardie');
insert into "user" (name) values ('Henderson Moret');
insert into "user" (name) values ('Jude Paolo');
insert into "user" (name) values ('Tallie Adderley');
insert into "user" (name) values ('Kissie Plane');
insert into "user" (name) values ('Hali Grigoroni');
insert into "user" (name) values ('Nina Isted');
insert into ORGANIZATION (name) values ('Watsica and Sons');
insert into ORGANIZATION (name) values ('Satterfield, Ryan and Carroll');
insert into ORGANIZATION (name) values ('Sauer-Robel');
insert into ORGANIZATION (name) values ('Cummerata, Kuvalis and Fritsch');
insert into ORGANIZATION (name) values ('Dare, Reinger and Rosenbaum');
insert into ORGANIZATION (name) values ('Schinner-Dach');
insert into ORGANIZATION (name) values ('Ullrich and Sons');
insert into ORGANIZATION (name) values ('Collins and Sons');
insert into ORGANIZATION (name) values ('Barrows LLC');
insert into ORGANIZATION (name) values ('Von, Labadie and Beer');
alter table "public"."project" alter column "organization_id" drop not null;
insert into PROJECT (name) values ('Guerza');
insert into PROJECT (name) values ('Australian sea lion');
insert into PROJECT (name) values ('Python (unidentified)');
insert into PROJECT (name) values ('Comb duck');
insert into PROJECT (name) values ('Indian porcupine');
insert into PROJECT (name) values ('Cormorant, large');
insert into PROJECT (name) values ('Meerkat');
insert into PROJECT (name) values ('Silver-backed jackal');
insert into PROJECT (name) values ('Dove, little brown');
insert into PROJECT (name) values ('Gray heron');
insert into PROJECT (name) values ('Blue fox');
insert into PROJECT (name) values ('Savannah deer (unidentified)');
insert into PROJECT (name) values ('Mouse, four-striped grass');
insert into PROJECT (name) values ('Owl, white-browed');
insert into PROJECT (name) values ('Javanese cormorant');
insert into PROJECT (name) values ('Heron, yellow-crowned night');
insert into PROJECT (name) values ('Red-billed tropic bird');
insert into PROJECT (name) values ('Striped hyena');
insert into PROJECT (name) values ('Roan antelope');
insert into PROJECT (name) values ('Bear, polar');

update "user" set organization_id = org.id from (select organization.id from organization, generate_series(1,100) order by random()) org;

alter table "public"."user" alter column "organization_id" set not null;

with sample as (select project.id as project_id, organization.id as organization_id from project, organization order by random() limit 100) update project set organization_id = sample.organization_id from sample where project.id = sample.project_id;

alter table "public"."project" alter column "organization_id" set not null;

with sample as (select "user".id as user_id, organization.id as organization_id from "user", organization order by random() limit 10000) update "user" set organization_id = sample.organization_id from sample where "user".id = sample.user_id;

with
  "user" as (
    select
      "user".id,
      (random()*9 + 1)::int items
      from "user")
    insert into user_permission (user_id, permission_id)
select
  user_id,
  permission_id
  from (
    select
      "user".id user_id,
      permission.id permission_id,
      row_number() over (partition by "user".id) ordinal
      from "user", permission) user_item
       join "user" on "user".id = user_item.user_id
	   and user_item.ordinal <= "user".items;

with
  "user" as (
    select
      "user".id,
      (random()*9 + 1)::int items
      from "user")
    insert into assignment (user_id, project_id)
select
  user_id,
  project_id
  from (
    select
      "user".id user_id,
      project.id project_id,
      row_number() over (partition by "user".id) ordinal
      from "user", project) user_item
       join "user" on "user".id = user_item.user_id
	   and user_item.ordinal <= "user".items;
delete from assignment;

with
  "user" as (
    select
      "user".id,
      "user".organization_id,
      (random()*9 + 1)::int items
      from "user")
    insert into assignment (user_id, project_id)
select
  user_id,
  project_id
  from (
    select
      "user".id user_id,
      project.id project_id,
      row_number() over (partition by "user".id) ordinal
      from
	"user",
	project join organization on organization_id = organization.id
     where
       "user".organization_id = organization.id
  ) user_item
       join "user" on "user".id = user_item.user_id
	   and user_item.ordinal <= "user".items;

create table "public"."timesheet" ("id" uuid not null default gen_random_uuid(), "user_id" uuid not null, "project_id" uuid not null, "hours" integer not null, primary key ("id") , foreign key ("user_id") references "public"."user"("id") on update restrict on delete restrict, foreign key ("project_id") references "public"."project"("id") on update restrict on delete restrict);

drop table "public"."timesheet";

create table "public"."timesheet" ("id" uuid not null default gen_random_uuid(), "assignment_id" uuid not null, "hours" integer not null, primary key ("id") , foreign key ("assignment_id") references "public"."assignment"("id") on update restrict on delete restrict);
delete from timesheet;

with
  assignment as (
    select
      id,
      project_id,
      (random()*5)::int assignments
      from assignment
  )
    insert into timesheet (assignment_id, hours)
select
  assignment_id,
  (random()*9 + 1)::int hours
  from (
    select
      assignment.id assignment_id,
      row_number() over (partition by assignment.id order by project.name) ordinal
      from
	assignment join project on project.id = project_id,
	generate_series(1, 5)) assignments
       join assignment on assignment.id = assignment_id
	   and ordinal <= assignments;
comment on table "public"."user" is E'Users belong to organizations';
comment on table "public"."organization" is E'Organizations have users and projects';
comment on table "public"."project" is E'A project belongs to an organization';
comment on table "public"."assignment" is E'A user can be assigned to a project at their organization';
comment on table "public"."assignment" is E'A user can be assigned to a project';
comment on table "public"."timesheet" is E'A timesheet records an increment of hours worked on an assignment';
comment on table "public"."permission" is E'A permission object is used in business rules';
comment on table "public"."user_permission" is E'A user can have permission objects';

alter table assignment enable row level security;

alter table organization enable row level security;

-- alter table permission enable row level security;

alter table project enable row level security;

alter table timesheet enable row level security;

-- alter table "user" enable row level security;

-- alter table "user_permission" enable row level security;

create policy query on assignment for select using (true);

create policy query on organization for select using (true);

-- create policy query on permission for select using (true);

create policy query on project for select using (true);

create policy query on timesheet for select using (true);

-- create policy query on "user" for select using (true);

-- create policy query on user_permission for select using (true);

create policy delete_assigned_projects on project for delete using (
  exists (
    select
      1
      from
	user_permission
	join permission
	    on true
	    and user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'delete_assigned_projects'
  )
  and
  exists (
    select
      1
      from
	assignment
     where true
       and project_id = project.id
       and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
  )
);

create policy edit_all_projects on project for update using (
  exists (
    select
      1
      from
	user_permission
	join permission
	    on true
	    and user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'edit_all_projects'
  )
);

create policy edit_all_timesheets on timesheet for update using (
  exists (
    select
      1
      from
	user_permission
	join permission
	    on true
	    and user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'edit_all_timesheets'
  )
);

create policy edit_assigned_projects on project for update using (
  exists (
    select
      1
      from
	user_permission
	join permission
	    on true
	    and user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'edit_assigned_projects'
  )
  and
  exists (
    select
      1
      from
	assignment
     where true
       and project_id = project.id
       and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
  )
);

create policy view_all_projects on project for select using (
  exists (
    select
      1
      from
	user_permission
	join permission
	    on true
	    and user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'view_all_projects'
  )
);

create policy view_all_timesheets on timesheet for select using (
  exists (
    select
      1
      from
	user_permission
	join permission on user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'view_all_timesheets'
  )
);
delete from user_permission;
create or replace function get_assigned_projects(user_id uuid) returns setof project stable parallel safe
as $$
  select
  project.*
  from project
  where true
  and exists (
    select 1
      from
	assignment
     where true
       and project_id = project.id
       and user_id = $1)
$$ language sql;

create or replace function get_unassigned_projects(user_id uuid) returns setof project stable parallel safe
as $$
  select
  project.*
  from project
  where true
  or not exists (
    select 1
      from
	assignment
     where true
       and project_id = project.id
       and user_id = $1)
$$ language sql;

create or replace function get_assigned_users() returns setof "user" stable parallel safe
as $$
  select
  *
  from "user"
  where true
  and exists (
    select 1
      from
	assignment
     where true
       and user_id = "user".id)
$$ language sql;
