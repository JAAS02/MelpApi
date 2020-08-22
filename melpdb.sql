--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4
-- Dumped by pg_dump version 12.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: address_standardizer; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS address_standardizer WITH SCHEMA public;


--
-- Name: EXTENSION address_standardizer; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION address_standardizer IS 'Used to parse an address into constituent elements. Generally used to support geocoding address normalization step.';


--
-- Name: address_standardizer_data_us; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS address_standardizer_data_us WITH SCHEMA public;


--
-- Name: EXTENSION address_standardizer_data_us; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION address_standardizer_data_us IS 'Address Standardizer US dataset example';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: ogr_fdw; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS ogr_fdw WITH SCHEMA public;


--
-- Name: EXTENSION ogr_fdw; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION ogr_fdw IS 'foreign-data wrapper for GIS data access';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: pgrouting; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgrouting WITH SCHEMA public;


--
-- Name: EXTENSION pgrouting; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgrouting IS 'pgRouting Extension';


--
-- Name: pointcloud; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pointcloud WITH SCHEMA public;


--
-- Name: EXTENSION pointcloud; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pointcloud IS 'data type for lidar point clouds';


--
-- Name: pointcloud_postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pointcloud_postgis WITH SCHEMA public;


--
-- Name: EXTENSION pointcloud_postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pointcloud_postgis IS 'integration for pointcloud LIDAR data and PostGIS geometry data';


--
-- Name: postgis_sfcgal; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_sfcgal WITH SCHEMA public;


--
-- Name: EXTENSION postgis_sfcgal; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_sfcgal IS 'PostGIS SFCGAL functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- Name: area(text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.area(text, text, integer) RETURNS TABLE(count bigint, avg numeric, std numeric)
    LANGUAGE sql
    AS $_$SELECT count(*), avg(rating), stddev(rating) FROM "Restaurants" 
 WHERE $3 > ST_Distance(ST_GeographyFromText(CONCAT ('POINT(',$1,' ',$2,')')), 
 ST_GeographyFromText(CONCAT ('POINT(',lng,' ',lat,')')));$_$;


ALTER FUNCTION public.area(text, text, integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Restaurants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Restaurants" (
    id text NOT NULL,
    rating integer,
    name text,
    site text,
    email text,
    phone text,
    street text,
    city text,
    state text,
    lat numeric(10,8),
    lng numeric(11,8),
    CONSTRAINT "Restaurants_rating_check" CHECK (((rating >= 0) AND (rating < 5)))
);


ALTER TABLE public."Restaurants" OWNER TO postgres;

--
-- Data for Name: Restaurants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Restaurants" (id, rating, name, site, email, phone, street, city, state, lat, lng) FROM stdin;
851f799f-0852-439e-b9b2-df92c43e7672	1	Barajas, Bahena and Kano	https://federico.com	Anita_Mata71@hotmail.com	534 814 204	82247 Mariano Entrada	Mérida Alfredotown	Durango	19.44005705	-99.12704710
4e17896d-a26f-44ae-a8a4-5fbd5cde79b0	0	Hernández - Lira	http://graciela.com.mx	Brandon_Vigil@hotmail.com	570 746 998	93725 Erick Arroyo	Mateofurt	Hidalgo	19.43790428	-99.12865768
c0ffd058-e773-47f1-974b-42d41cb555bf	3	Rendón - Elizondo	https://cristina.mx	Hugo.Casanova49@gmail.com	5866-337-812	5518 Monserrat Explanada	Chignahuapan María	Sinaloa	19.43607059	-99.12978657
c29082c4-4352-4517-9b4b-c45f86fc1830	2	Nájera - Chávez	https://pedro.gob.mx	Carlota31@hotmail.com	5532-129-406	79224 Mariano Travesía	Nezahualcóyotl Timoteo	Coahuila	19.44248691	-99.12383326
2b8f5a44-1e8b-44ec-9b25-0edc5b64b7e6	3	Hurtado, Rolón and Segovia	https://elías.org	RosaMara_Figueroa@corpfolder.com	559.867.074	039 Susana Polígono	Marco Antonioland	Colima	19.43349766	-99.12851351
ddb77425-2c3f-435c-8391-021b40010b0d	0	Serrato Hermanos	https://octavio.org	Yamileth_Lugo28@corpfolder.com	571.744.718	14476 Delgadillo Partida	Nevárezfort	Michoacan	19.43470423	-99.12638178
7b845a5f-94d4-4d52-bbb7-838839a180d6	1	Saiz, Aponte and Muñoz	https://homero.com	Carolina_Merino@nearbpo.com	584212054	563 Verduzco Vía Pública	Nuevo Laredo Alejandrahaven	San Luis Potosí	19.44148782	-99.12748993
030eaf75-da6e-4748-9727-f2704f831498	2	Niño - Negrete	https://elizabeth.gob.mx	Luz_Sevilla@gmail.com	5178-668-409	3041 Gael Torrente	Querétaro Saratown	Oaxaca	19.44168147	-99.12657324
1ce4a7f8-ff21-4450-9107-f4f952f39f99	4	Kortajarena - Rangel	http://débora.gob.mx	Brandon_Quiros@gmail.com	560 092 151	59897 Esquivel Aldea	Monterrey Dulce María	Querétaro	19.44070197	-99.12601493
9f98fad3-ecd6-421b-ba8c-2bd63340473d	2	Macías S.L.	http://miguel.com.mx	Jazmin_Santiago7@yahoo.com	508272671	1736 Adela Urbanización	Puerto Vallarta Dorotea	Baja California Sur	19.43692578	-99.13156075
38c965f9-74b0-4d8e-9cc2-2e457a1ebb83	3	Arreola Hermanos	https://alejandra.com.mx	Ximena_Domnquez62@yahoo.com	531.757.355	9061 Fernando Puente	Campeche Mercedes	Guanajuato	19.43498882	-99.12630735
4501fb34-eefe-4f63-90c9-a9a1272df71d	0	Gallardo - Angulo	https://josé antonio.mx	Brandon34@gmail.com	5191-333-084	7229 Villarreal Gran Subida	Campeche Daniela	Quintana Roo	19.43413203	-99.13262356
d04fd5aa-4a56-43a6-91c9-35edaaadadc9	0	Calvillo S.L.	https://martín.info	JuanPablo.Cervntez@nearbpo.com	501 812 092	38836 Emilio Partida	Rubénchester	Tabasco	19.44239317	-99.12657698
a850ff07-516e-44e4-acd7-26fa0c12f4fc	1	Palomo - Cardona	http://marco antonio.org	Lizbeth.Laboy@hotmail.com	508.505.560	5588 Leticia Torrente	Tetela de Ocampo Silviafurt	Colima	19.43486986	-99.12808952
7173d827-3308-46d8-9b9e-86306ec64f78	3	Carreón e Hijos	http://dolores.org	Benjamn.Arenas27@yahoo.com	572.204.703	7124 Granado Parcela	Celaya Carlos	Puebla	19.44055436	-99.12680347
d6782cfc-29ef-4241-985b-0a6ff6cf4c64	4	Munguía S.L.	https://emmanuel.com.mx	Yaretzi_Saldivar28@yahoo.com	573.429.070	05203 Martín Lado	León Césarland	Guerrero	19.43889204	-99.13033427
dd56e1e9-bd67-41cd-baac-a8f9f47ad5c8	4	Fuentes, Porras and Barajas	http://ariadna.com.mx	Jimena25@hotmail.com	5087-469-378	81414 Luz Ferrocarril	Paolabury	Michoacan	19.43935118	-99.13306613
ac3bafbe-ea67-47cb-af99-63d945f71bf5	1	Ledesma, Vélez and Matías	https://miranda.mx	Amalia27@gmail.com	593 520 541	7630 Collado Huerta	Irapuato Carolina	Jalisco	19.44271475	-99.12725417
3e26a92c-defb-4475-8c23-450750556fb9	4	Galarza, Griego and Orozco	https://josé luis.com.mx	JosEduardo_Narvez@nearbpo.com	5177-114-746	0785 José Luis Mercado	Tampico-Pánuco Mercedes	Guerrero	19.43531181	-99.13091740
6b7cd221-7859-4ece-8ed6-fd79283f0e65	2	Hurtado, Armijo and Soto	https://iker.org	Patricio.Alonso52@gmail.com	5234-475-063	830 Valentín Colonia	La Laguna Ana Maríamouth	Tabasco	19.43343388	-99.13044725
d7888ed4-52f0-4be8-a210-f0d28ce0e565	0	Paredes - Montero	http://abraham.com.mx	Vanessa_Quinterodelacruz84@hotmail.com	5783-052-043	237 Regina Jardines	Pilarshire	Nuevo León	19.43924018	-99.13319044
e6c4bf95-dba4-44b5-af90-b0ab7214146e	0	Zavala - Chavarría	https://ignacio.mx	Jernimo_Armas@nearbpo.com	588078464	019 Aragón Urbanización	Carrasquillobury	Yucatán	19.43324030	-99.13229424
1d7e6cac-013e-404b-8d93-19d838ef30e1	1	Padilla, Mata and Posada	https://gabriel.com.mx	Josefina_Cano@corpfolder.com	554 352 295	0658 Espino Conjunto	Mérida Emilio	Guerrero	19.43915027	-99.12413154
811fa2fc-f29c-4152-a821-7c2a67ab5d21	4	Gallegos, Anguiano and Jurado	http://eduardo.com	Carla.Ramn81@corpfolder.com	5572-745-754	2179 José Plaza	Sofiaville	Durango	19.43406262	-99.12380258
6e658154-be6f-409c-9c38-b53cc38c2705	3	Figueroa e Hijos	http://maría cristina.org	FernandoJavier.Batista@nearbpo.com	576.091.302	166 Gaona Ferrocarril	Tetela de Ocampo Ester	Yucatán	19.43416304	-99.13069784
40424cd9-a4ff-466f-bea9-51cacb2dd2d5	3	Cruz, Korta hernandez and Yáñez	http://pedro.info	Jorge.Carrion@gmail.com	551 482 751	684 Barrientos Monte	Orizaba Nataliahaven	Estado de México	19.44203661	-99.13275607
ed23040e-6d68-4211-b31c-62e2f36d120a	3	Casanova - Jaramillo	http://brayan.com	Valentina_Gracia59@nearbpo.com	573.342.065	220 Ángel Gabriel Solar	Cancún Yaretzi	Durango	19.43380998	-99.12934458
8e086874-60ff-44d5-a327-e4bccf3a90ed	2	Moya - Cepeda	https://claudia.info	Silvia20@hotmail.com	592.612.849	28658 José Antonio Aldea	Guardadoview	Chihuahua	19.44197459	-99.13210572
5675b76e-738a-4f6f-9adc-2a1b708b67fc	1	Yanes S.A.	http://rubén.info	MaraLuisa_Amador@nearbpo.com	555 572 993	358 María Soledad Arrabal	Tlalnepantla Cristobal	Baja California Sur	19.43923550	-99.12893260
c4965d5d-4c08-4806-8cfc-77099379ce4e	1	Rael, Mota and Cintrón	https://francisco.org	Miguelngel4@corpfolder.com	511.280.590	821 Lorena Ramal	Tula Adánville	Chihuahua	19.44159823	-99.12635209
da7c9bad-6036-4a3a-8873-81dfaa585b26	0	Hinojosa Hermanos	https://erick.mx	XimenaGuadalupe.Mireles@nearbpo.com	5382-692-003	8772 Marrero Huerta	Zaragozafort	Morelos	19.43710946	-99.12925726
71795f1c-4ca0-4ec7-b925-5b906711329b	3	Zamudio S.L.	http://cecilia.com.mx	Estela.Quinta80@hotmail.com	590.101.852	928 Benavídez Municipio	Terrazasside	Baja California Sur	19.43654561	-99.12559146
556091ed-3047-4f07-a2e3-1abbb37ff1bd	4	Kamat S.L.	http://melissa.mx	Eva88@corpfolder.com	5756-043-582	4820 Gurule Rambla	León Kimberlyland	Aguascalientes	19.44025026	-99.12917746
87b35453-f063-461a-b17b-9173f7f09805	0	Arevalo - Reséndez	http://esteban.info	Valeria.Espinal@yahoo.com	560 091 544	481 Raquel Huerta	Ríoshaven	Guanajuato	19.43626629	-99.13294280
8d567e51-e73c-47b3-ad15-9ca14c32da14	0	Ñañez S.L.	http://cristobal.mx	Eduardo_Montes75@nearbpo.com	506.416.955	705 Gloria Avenida	Armijomouth	Tabasco	19.43480314	-99.12484891
84314586-29fb-420f-95e5-f15fbe7a619c	0	Mayorga S.L.	https://eva.com.mx	Melissa51@corpfolder.com	521.791.308	4152 Karem Mercado	Coatzacoalcos Nicolásstad	Baja California Norte	19.43966503	-99.13242159
1b413a3a-e894-4142-a954-37176f12003b	1	Báez, Karan and Armijo	https://fernando.info	Alexa.Ortega@yahoo.com	545520700	08030 Juan Manuel Torrente	Uruapan del Progreso Juan Pabloland	Tabasco	19.43369957	-99.13109211
15c7fea0-89e8-4539-8632-46a619ef4ce9	1	García e Hijos	http://victor manuel.gob.mx	JosEmilio31@corpfolder.com	5250-478-668	3239 Apodaca Parque	Campeche Ramiroborough	Puebla	19.43291252	-99.13120792
073aa6dc-3363-417c-b3f4-eba74fb75de8	3	Palacios, Moreno and Bustamante	http://bernardo.mx	Luis.Anaya25@corpfolder.com	581 978 966	37097 Florencia Senda	Octavioville	Chiapas	19.43456572	-99.13242485
36d43234-edd6-4680-8054-f2f6e4e4ab47	3	Polanco - Rodríguez	http://paola.gob.mx	Mayte.Camacho@nearbpo.com	5778-085-952	31916 Daniel Glorieta	Zitacuaro Monserratchester	Sinaloa	19.43452227	-99.12684009
7b97ebd0-6c61-43b1-80c6-bdc88846c727	3	Aragón, Robles and Echevarría	https://mario.org	MaradeJess32@gmail.com	558.191.752	5983 Tapia Lado	Juanaborough	Baja California Sur	19.43695412	-99.13007207
58c0549f-4b2c-43d4-af8d-d4641ffa9f66	4	Zabaleta S.A.	http://sofia.com	Bernardo.Yebra48@hotmail.com	538173475	65562 Olivas Rincón	Durango Elizabethchester	Campeche	19.43531029	-99.12920438
5dccd552-2941-485c-a80d-8a769f4df5c5	0	Pelayo, Puente and Echevarría	https://homero.gob.mx	Eva.Ferrer47@hotmail.com	568360596	96024 Ana Sofía Polígono	Chetumal Liliafort	Tlaxcala	19.44070300	-99.12748069
6308a2f2-6719-4ff6-818e-4e62f41a5296	4	Benítez - Carbajal	https://jaime.com.mx	Eva_Faras11@corpfolder.com	566384264	795 Gaytán Colonia	Nicolásview	Durango	19.43928626	-99.13152404
72cc52c1-7aa5-4098-a391-5a713e2d9781	0	Lozada, Chávez and Guerrero	https://estefanía.mx	Victoria.Valadez@corpfolder.com	567 287 108	66998 Tejada Colegio	Isabelbury	Oaxaca	19.43866769	-99.12583769
601c7236-e03c-4ba1-beb5-38fbc09108f9	1	Mesa e Hijos	http://sofia.org	Julia_Chavarra@nearbpo.com	565 772 068	6236 Axel Masía	Francisco Javierland	Baja California Sur	19.43321355	-99.13172434
3e21e0c4-3f89-42fb-8676-8350b95883e2	3	Muñoz, Armendáriz and Moya	https://abraham.com.mx	Emilio.Kortahernandez@nearbpo.com	500 103 302	626 Adriana Ramal	Rochaport	Veracruz	19.43472437	-99.12411203
8b8af894-bc42-4664-b08c-6cf4ef28081f	3	Delgadillo - Escobar	http://cristian.mx	JosLuis.Valds86@yahoo.com	5325-988-654	73621 Gloria Colegio	Delgadilloshire	Michoacan	19.43499341	-99.13172328
0b9447e8-6253-4337-b9a0-d6573149fde0	1	Palomino - Vargas	http://abigail.mx	Cecilia_Zabaleta76@nearbpo.com	566.689.802	396 Abreu Bloque	Kortajarenaside	Quintana Roo	19.43447205	-99.13177863
cc9c245d-8b02-44c3-868e-90a3149edd5b	2	Vallejo, Jiménez and Jaimes	https://alfredo.gob.mx	Ramn_Campos@nearbpo.com	534 642 223	9775 Amaya Cuesta	Valle de México Juanborough	Tlaxcala	19.43565765	-99.12528320
b6c3a6d0-4082-4353-926a-b903132b29f4	4	Ramón Hermanos	http://gloria.gob.mx	Abril.Yez@yahoo.com	526.705.438	41601 Lucia Manzana	Vallechester	Quintana Roo	19.43734860	-99.12789598
32084e1d-41b9-4dc8-9b8a-83b5003302c1	2	Sáenz - Romo	https://juan.gob.mx	Pablo_Alicea@yahoo.com	523671866	65816 Sergio Parque	Becerraport	Sonora	19.43970677	-99.12944217
5b04ad6d-54c1-419c-b8cd-69090fee4e76	0	Ramos S.L.	https://matías.gob.mx	Daniela_Castillo26@yahoo.com	565166901	919 Salvador Colonia	Ángel Gabrielfurt	Chiapas	19.43285465	-99.13344355
fdc12e77-af11-496a-846b-94068dcded56	2	Aragón, Herrera and Cortez	https://camila.com.mx	Victoria14@hotmail.com	5359-320-036	18089 Ramírez Partida	Los Mochis Carlachester	Jalisco	19.43730960	-99.13168674
39292d20-d201-4f0f-91a2-58e0f38fb2a2	0	Carrillo - Ozuna	https://carlos.mx	Armando82@yahoo.com	515577461	18190 Villagómez Ronda	Reynosa-Río Bravo Sofia	Colima	19.44263640	-99.12821945
84572f5a-ea3d-4800-930c-5799a897b06c	1	Khalid - Cortés	https://rosa maría.mx	Alan.Escobar@corpfolder.com	5191-038-970	225 Cortés Masía	Ixtapaluca María de Jesúsmouth	Veracruz	19.43870305	-99.12665947
3765054a-c706-4dcd-8424-aa8db4e5a4bd	4	Casárez S.L.	https://julio césar.gob.mx	Isaac86@gmail.com	567057696	808 Noriega Pasaje	La Paz Lucasbury	Jalisco	19.43547730	-99.12574555
beef488c-7f32-4a35-8469-89f5c6277972	4	Cordero, Chapa and Lomeli	https://erick.org	Elisa.Orozco1@gmail.com	577 596 369	70658 Arredondo Extrarradio	Torreón Tadeochester	Veracruz	19.44128511	-99.13085499
fe82f695-e437-4f42-9a69-d3a451c4a1d0	0	Jaramillo - Narváez	https://raúl.org	scar_Olivo@yahoo.com	591 730 248	0112 Jaime Apartamento	Comitán de Dominguez Gregorio	Jalisco	19.44030163	-99.12623585
b464014b-44ca-43e3-ba27-7477c8af2a53	0	Carrero Hermanos	http://luz.info	Adn.valos@corpfolder.com	562 179 920	7383 Hinojosa Huerta	Carlahaven	Hidalgo	19.43313641	-99.12392061
8e5f2c9c-7a25-4cc0-a4fa-306c1a6e2d91	2	Sedillo - Márquez	https://maría teresa.org	DulceMara98@nearbpo.com	5452-478-262	4279 Tadeo Parcela	Lozanoshire	Chiapas	19.43451065	-99.13358867
83967700-00d9-4d8e-8b5d-dd72f4fba3e5	0	Bueno, Crespo and Rodrígez	https://gonzalo.com	Toms.Sols@gmail.com	5578-929-369	6347 Reina Salida	Roybalfort	Zacatecas	19.44141238	-99.12854567
650156a1-081b-4760-b438-0cee445be58e	3	Reyna S.A.	https://soledad.gob.mx	XimenaGuadalupe.Alaniz@nearbpo.com	518 264 968	895 Xenia Prolongación	Mazatlán Antoniamouth	Morelos	19.43913815	-99.13319298
b2ca0188-62c0-4bba-b20c-62bc2d4ba192	4	Rubio S.A.	http://víctor.info	Hugo.Casrez2@hotmail.com	5471-253-103	119 Polanco Colegio	Vicentechester	Morelos	19.43644245	-99.12645815
cb0e214f-b0e4-496a-8164-eac6105b2d35	0	Valles, Tamez and Duarte	https://marta.com	Anita_Crdova@gmail.com	574 635 517	16737 Garrido Rampa	Piedras Negras Martaport	Campeche	19.43363497	-99.13319198
b8b03b3d-4c06-4d91-b895-5d8dc85cbb2e	2	Venegas S.L.	http://maría guadalupe.com.mx	Dbora.Delgado66@gmail.com	5810-547-684	776 Burgos Plaza	Karantown	Quintana Roo	19.44143540	-99.13301142
9e71243d-3b46-45de-9f1f-019b1bfe6bac	1	Romo, Olmos and Calderón	https://valeria.gob.mx	Emilio29@corpfolder.com	510.186.181	67576 Cabán Chalet	Nicolásfurt	Jalisco	19.44095452	-99.12461699
59cddeed-fbea-425f-8181-4bd1354b4dfe	1	Arias S.L.	https://alejandro.com.mx	Axel.Zavala60@hotmail.com	537 651 378	739 Ortiz Manzana	Abrahamfurt	Baja California Norte	19.43312007	-99.12784928
39be48e9-ec92-4ce5-8c90-768dfe20fc37	1	Almaraz, Narváez and Urías	https://sebastian.com.mx	Lola32@nearbpo.com	500 100 614	684 Rolón Apartamento	Karanmouth	Oaxaca	19.44039834	-99.13117378
80537b08-6bae-444b-9564-98731e680f59	0	Alaniz - Aponte	https://ariadna.com.mx	Mara26@corpfolder.com	524.823.622	750 Alberto Escalinata	Tehuantepec-Salina Cruz Mauriciostad	Hidalgo	19.43288511	-99.12643918
714ce590-f302-4453-895b-aa2992c2fa2c	1	Armendáriz S.A.	https://eloisa.org	Regina35@yahoo.com	542 891 822	821 Agustín Quinta	Piedras Negras Jesúsberg	Chiapas	19.43655129	-99.13302329
ecbdb52a-4263-4bf1-87fb-8d9d809ea6aa	4	Soliz Hermanos	http://roberto.gob.mx	Mercedes_Lugo@hotmail.com	537 295 998	440 Ceballos Huerta	Oaxaca Sara	Aguascalientes	19.43502031	-99.12721964
596081be-67c8-4c47-8c56-e2611cd4fa32	2	Olivo, Santana and Elizondo	http://victor manuel.gob.mx	Emmanuel_Rosas56@nearbpo.com	545.851.405	4409 José Luis Rampa	Elizabethtown	Durango	19.43495711	-99.12735425
8a5aefe2-8d0c-45b6-aab2-4da2769e10fa	4	Vázquez, Espinal and Cervántez	http://mariana.gob.mx	Leticia.Hidalgo@nearbpo.com	528679468	055 Julio Lugar	Zacatlan José Emilioside	Guanajuato	19.43841681	-99.12759699
c9186202-30a4-48e7-b20b-c56d733fa76a	1	Viera S.L.	http://ximena.gob.mx	Benjamn26@yahoo.com	518272168	675 Kamal Chalet	Guanajuato Tadeoview	Estado de México	19.44227365	-99.12935202
32b74fb4-1911-4db9-9646-f5ce4663ff1c	0	Alicea - Castañeda	https://gustavo.org	Gerardo_Ozuna32@yahoo.com	599 747 935	5702 Yamileth Terrenos	Coronadoview	Zacatecas	19.43949621	-99.12644309
e5f21255-2dde-469e-bff8-4ea81d6fca27	3	Medrano - Chavarría	http://julia.org	Kevin.Longoria68@nearbpo.com	568061069	0302 Águilar Terrenos	Ocotlán Maricarmenstad	Tabasco	19.43684000	-99.12783023
3b84c87a-1cf9-40e8-81ff-19669240ce9b	2	Naranjo, Galarza and Águilar	https://juan pablo.com	Monserrat.Lozano77@corpfolder.com	588438707	9390 Manuel Sector	Cuernavaca Aliciachester	Puebla	19.43531675	-99.13303887
d3df42be-c6ff-43f6-8226-066140ab1b01	0	Kanzaki e Hijos	http://ivanna.info	Eva_Guerra48@gmail.com	5487-547-323	8465 Jorge Luis Aldea	Saizside	Querétaro	19.43406239	-99.12900435
35b9efad-5168-419e-96bc-0535e5e5d2f9	1	Villarreal - Gaytán	http://yolanda.info	Camila.Castellanos@corpfolder.com	5344-687-599	00698 Vallejo Ferrocarril	Arriagabury	Veracruz	19.43713002	-99.12858031
9c6f0247-d128-4396-b80c-8f9648928ec0	4	Salcedo Hermanos	https://marco antonio.org	Victoria.Lucero@corpfolder.com	573 413 844	7688 Puga Entrada	Gonzaloborough	Sinaloa	19.44069556	-99.13211590
937518f0-a27f-491e-8788-ae9be0c65b31	2	Gonzales, Valladares and Espinal	https://carlota.org	Dolores.Mercado64@corpfolder.com	5528-685-947	30474 Montez Mercado	José Luisstad	Sinaloa	19.43730705	-99.12809112
534d5669-c0d4-4fe1-805e-7f836eb80e0f	1	Zayas - Loya	https://javier.com	Teresa_Miramontes@nearbpo.com	523.743.315	9119 Lorenzo Riera	Tulancingo Zoe	Tlaxcala	19.44096215	-99.12570527
72bd30eb-192f-4f5a-bda2-bde3ae0844c2	1	Huerta e Hijos	https://esteban.com.mx	Gloria_Robledo73@nearbpo.com	509.051.989	93160 Xairo Belmonte Vía	Ciudad Obregón Emmanuel	Zacatecas	19.43910022	-99.12469917
5e238917-a1e1-408a-93d5-0c1bcb3361bc	0	Carranza e Hijos	http://diana.org	Teresa_Domnquez39@corpfolder.com	545.204.593	19099 Isabel Bloque	Tlaxcala-Apizaco Juan Manuel	Sinaloa	19.43973481	-99.13234929
4e20f081-3095-4918-88f8-9591991b017f	4	Vélez - Maldonado	http://josé eduardo.org	Diego16@gmail.com	516.205.131	5206 Juárez Salida	Manuelaburgh	Puebla	19.43776850	-99.12864866
74c9182c-9ec1-47cb-8271-50729ae7f95d	3	Solís, Valles and Collado	http://mariana.com	Mario_Arreola51@gmail.com	5917-337-221	638 Sedillo Urbanización	Concepciónside	Quintana Roo	19.44110282	-99.12928944
19e1837a-c9ad-49d8-8d6d-7cb1d2ee0700	0	Águilar - Matos	https://eloisa.com.mx	LuisMiguel.Godnez83@yahoo.com	5616-561-563	319 Dolores Rampa	Coatzacoalcos Gonzalo	Oaxaca	19.43714950	-99.12651043
6589e471-ae41-4e6b-83b8-9654d6fc71ea	1	Peres, Meraz and Peña	http://esteban.com.mx	Luisngel.Gmez50@nearbpo.com	581 479 974	134 Hidalgo Avenida	Ojo de agua Luis Ángelport	Campeche	19.43293297	-99.13129210
58131b8b-1b93-495f-b7a1-0e2e1b93633d	2	Meraz e Hijos	http://ximena.gob.mx	Isabela.Briones11@gmail.com	5495-151-485	10411 Pagan Salida	Ciudad de México Carlota	Aguascalientes	19.43868243	-99.12891140
097f66dd-ca33-4f30-88e4-33193fcf8cda	1	Briseño - Rodarte	https://fernando javier.com	Mario84@yahoo.com	5256-976-186	780 Medina Terrenos	Madridland	Sonora	19.43385728	-99.12542738
fcb9b113-49f5-4119-8016-c7357ac135fc	0	Briones S.A.	http://maría de jesús.com	Emilio_Abeyta@yahoo.com	539 404 967	375 Puente Puente	Tulancingo de Bravo Margarita	Zacatecas	19.43975847	-99.12611984
0c91a515-2be1-4e8b-a4b0-be4f0ed1cce1	0	Pedroza, Heredia and Lebrón	https://zoe.com	Teodoro_Zelaya@gmail.com	5932-627-483	69201 Dávila Edificio	Julioview	Baja California Norte	19.43386838	-99.12657592
7ef3ed97-ebd6-4114-b2c1-af664534df79	1	Jáquez, Jimínez and Yami	http://dulce maría.org	Ivan_Delro32@gmail.com	555522401	057 Meléndez Aldea	Zacatlan Claudia	Baja California Sur	19.44178271	-99.12955183
3eb803d7-445a-43cd-9d08-2c3bd1c56148	1	Esquivel S.L.	https://abigail.com	Norma40@corpfolder.com	552972577	66678 Andrés Salida	Zacatlan Berta	Baja California Sur	19.43809312	-99.13341109
24345eda-0451-4225-a6d0-17365f746afc	3	Jaramillo - Flores	http://josé antonio.com.mx	Patricia.Noriega75@yahoo.com	520.411.112	2399 Esquibel Partida	Culiacán Cristianport	Chihuahua	19.44199672	-99.12430642
1ce2e219-d0e5-4f88-85f9-c152485ec7ab	0	Matos S.L.	https://ricardo.info	JosEmilio.Cotto69@corpfolder.com	5502-208-117	69982 Luis Gabino Terrenos	Cancún Estefaníahaven	Hidalgo	19.44201663	-99.13139965
04e43341-64c0-4f66-822f-f2c0ef02e6bc	0	Barela e Hijos	https://timoteo.gob.mx	Soledad.Brito7@yahoo.com	500 281 343	8758 Alondra Romina Parcela	Guadalupeside	Tamaulipas	19.44161395	-99.13366146
f73cfbce-60b8-4e2c-9ec7-de8dbb5e0a49	1	Palacios - Montez	https://felipe.org	Rosalia.Estvez@nearbpo.com	590 666 046	7676 Raquel Solar	Marco Antonioton	Michoacan	19.44106341	-99.13046770
edb50561-46f9-4541-9c04-8de82401cc13	4	Pedraza - Niño	http://josé eduardo.gob.mx	Irene_Rojas95@nearbpo.com	537 531 201	207 Chavarría Lado	Franciscohaven	Baja California Norte	19.44268382	-99.12502459
\.


--
-- Data for Name: pointcloud_formats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pointcloud_formats (pcid, srid, schema) FROM stdin;
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: us_gaz; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.us_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: us_lex; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.us_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: us_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.us_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Name: Restaurants Restaurants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Restaurants"
    ADD CONSTRAINT "Restaurants_pkey" PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

