DELETE FROM "RawTable";
COPY "RawTable"("eventDateTime","city","state","shape", "timeDuration","summary","datePosted") 
FROM '/Users/obawany/Desktop/Winter 2018/CSI 4142 - Data Science /FIN.csv' DELIMITER ',' CSV HEADER;

DELETE FROM "UFO-Fact";
Delete FROM "Reported-Date";
Delete FROM "Location";
Delete FROM "Event-Date";
Delete FROM "Shape";

--From RAW to Location TABLE

INSERT INTO "Location" ("City","State","Location-Key")
SELECT "city", "state", "id"
FROM "RawTable";

/*

select * 
from "Location";

*/

/*

Insert into "Location Dimension"("City","State","Location-key")
Select "Location", "State", "id"
FROM "UFO";

Insert into "Shape Dimension"("Shape-name","Summary", "Shape-key")
Select "Shape", "Description", "id"
FROM "UFO";

Insert into "Event-Date Dimension"("Date","Week","Month","Year","Weekend", "Event-Date key")
Select "Event_Date", EXTRACT(week FROM "Event_Date"), EXTRACT(MONTH FROM "Event_Date"), EXTRACT(YEAR FROM "Event_Date"),
	CASE 
	WHEN to_char("Event_Date", 'D') = '7' THEN 'y'
	WHEN to_char("Event_Date", 'D') = '1' then 'y'
	ELSE 'n' 
	END, "id"
FROM "UFO";

Insert into "Reported-Date Dimension"("Date","Week","Month","Year","Weekend", "Reported-Date key")
Select "Posted_Date", EXTRACT(week FROM "Posted_Date"), EXTRACT(MONTH FROM "Posted_Date"), EXTRACT(YEAR FROM "Posted_Date"),
	CASE 
	WHEN to_char("Posted_Date", 'D') = '7' THEN 'y'
	WHEN to_char("Posted_Date", 'D') = '1' then 'y'
	ELSE 'n' 
	END, "id"
FROM "UFO";

Insert into "UFO FACT"("Event Date key","Location key","Shape key","Reported Date key","Duration")
Select e."Event-Date key" , l."Location-key", s."Shape-key", r."Reported-Date key", u."Duration"
FROM "Location Dimension" l, "Shape Dimension" s, "Reported-Date Dimension" r, "Event-Date Dimension" e, "UFO" u
WHERE e."Event-Date key" = u."id" and u."id" = l."Location-key" and u."id" = r."Reported-Date key" and u."id" = s."Shape-key";

*/


--FROM RAW to Reported-Date TABLE

INSERT INTO "Reported-Date"("Date","Week","Month","Year","Weekend (Y/N)", "Reported-Date-Key")
SELECT "datePosted", EXTRACT(week from "datePosted"), EXTRACT(month from "datePosted"), EXTRACT(year from "datePosted"), CASE WHEN to_char("datePosted", 'D') = '7'THEN 'Y'
		WHEN to_char("datePosted", 'D') = '1'THEN 'Y'
		ELSE 'N'
		END, "id"
FROM "RawTable";

/*

select * 
from "Reported-Date";

*/

--FROM RAW to Event-Date TABLE

INSERT INTO "Event-Date"("Date","Week","Month","Year","Weekend (Y/N)", "Event-Date-key")
SELECT "eventDateTime", EXTRACT(week from "eventDateTime"), EXTRACT(month from "eventDateTime"), EXTRACT(year from "eventDateTime"), CASE WHEN to_char("eventDateTime", 'D') = '7'THEN 'Y'
		WHEN to_char("eventDateTime", 'D') = '1'THEN 'Y'
		ELSE 'N'
		END, "id"
FROM "RawTable";

/*

select * 
from "Event-Date";

*/

--FROM RAW to Shape TABLE


INSERT INTO "Shape" ("Shape-name", "summary", "Shape-Key")
SELECT "shape", "summary", "id"
FROM "RawTable";

/*

select * 
from "Shape";

*/

Insert into "UFO-Fact"("Event-Date-key","Location-Key","Shape-Key","Reported-Date-Key","timeDuration")
Select e."Event-Date-key" , l."Location-Key", s."Shape-Key", r."Reported-Date-Key", u."timeDuration"
FROM "Location" l, "Shape" s, "Reported-Date" r, "Event-Date" e, "RawTable" u
WHERE e."Event-Date-key" = u."id" and u."id" = l."Location-Key" and u."id" = r."Reported-Date-Key" and u."id" = s."Shape-Key";



/*		Maybe the reason not working properly

INSERT INTO "UFO-Fact" ("Reported-Date-Key") SELECT "Reported-Date-Key" FROM "Reported-Date";
INSERT INTO "UFO-Fact" ("Event-Date-key") SELECT "Event-Date-key" FROM "Event-Date";
INSERT INTO "UFO-Fact" ("Shape-Key") SELECT "Shape-Key" FROM "Shape";
INSERT INTO "UFO-Fact" ("Location-Key") SELECT "Location-Key" FROM "Location";

*/

--Q11

SELECT "Month", COUNT ("Month")
FROM "Event-Date"
GROUP BY "Month"
ORDER BY "Month";

--Q12

SELECT count(*), "Location"."State", "Reported-Date"."Month" FROM ("UFO-Fact" INNER JOIN "Location" ON "Location"."Location-Key" = "UFO-Fact"."Location-Key")
  INNER JOIN "Reported-Date" ON "Reported-Date"."Reported-Date-Key" = "UFO-Fact"."Reported-Date-Key" GROUP BY "Location"."State", "Reported-Date"."Month";

/*

--RUNS BUT NO RESULTS

SELECT COUNT(e."Month"), l."State", e."Month"
From "UFO-Fact" f, "Event-Date" e, "Location" as l
WHERE e."Event-Date-key" = f."Event-Date-key" AND l."Location-Key" = f."Location-Key"
GROUP BY e."Month", l."State"

*/

/*

SELECT count(*), "Location"."State", "Reported-Date"."Month" FROM ("UFO-Fact" INNER JOIN "Location" ON "UFO-Fact"."Location-Key" = "Location"."Location-Key")
  INNER JOIN "Reported-Date" ON "UFO-Fact"."Reported-Date-Key" = "Reported-Date"."Reported-Date-Key" GROUP BY "Location.State", "Reported-Date"."Month";

*/

/*

SELECT count(*), state, month FROM (UFO INNER JOIN Location_Dimension ON location_id = location_key)
 INNER JOIN Reported_Dimension ON reported_id = reported_key GROUP BY state, month;

*/

/*
SELECT r."Month", l."State", COUNT(u."Key")
FROM public."UFO-Fact" u, public."Reported-Date" r, public."Location" l
WHERE u."ReportedDateKey" = r."Key"
AND u."LocationKey" = l."Key"
GROUP BY r."Month", l."State";

*/

/*

SELECT e."Month", l."State", COUNT("Month") as cnt
FROM "Event-Date" e , "Location" cross join 
	(select distinct State from Location) l left join
	Event-Date e
	on l."Location-Key" = e."Event-Date-key" and UFOFact.id = 
GROUP BY "Month", "State"
ORDER BY "Month", "State"

*/

--Q13

/*
SELECT COUNT(shape), shape, AVG(duration) FROM UFO-Fact
  INNER JOIN Shape_Dimension ON shape_id = shape_key ORDER BY 1 DESC LIMIT 5
*/

SELECT COUNT("Shape-name"), "Shape-name", AVG("UFO-Fact"."timeDuration")
FROM (public."UFO-Fact"
 INNER JOIN public."Shape"
   ON "UFO-Fact"."Shape-Key" = "Shape"."Shape-Key") GROUP BY "Shape-name" ORDER BY 1 DESC LIMIT 5;

/*
SELECT COUNT(Shape_Name), Shape_Name, AVG(Duration)
FROM (UFO_DataMart.UFO_Fact
 INNER JOIN UFO_DataMart.Shape_Dimension
   ON UFO_Fact.Shape_Key = Shape_Dimension.Shape_Key) GROUP BY Shape_Name ORDER BY 1 DESC LIMIT 5;
*/

--Q14

SELECT s."Shape-name", AVG(u."timeDuration") as avg_duration, l."State", MAX(u."timeDuration") as max_duration
FROM "Shape" s, "UFO-Fact" u, "Location" l
WHERE s."Shape-Key" = u."Shape-Key" AND l."Location-Key" = u."Location-Key"
GROUP BY l."State", s."Shape-name"  ORDER BY max_duration desc;


--Q15

SELECT count(*), "Shape", "State" FROM ("UFO-Fact" INNER JOIN "Location" ON "Location"."Location-Key" = "UFO-Fact"."Location-Key")
  INNER JOIN "Event-Date" ON "Event-Date"."Event-Date-key" = "UFO-Fact"."Event-Date-key" INNER JOIN "Shape"
ON "UFO-Fact"."Shape-Key" = "Shape"."Shape-Key"
WHERE ("Location"."State" = 'CA' OR "Location"."State"= 'FL') AND "Event-Date"."Weekend (Y/N)" = 'Y' GROUP BY "State", "Shape";

/*
SELECT count(*), shape, state FROM (UFO INNER JOIN Location_Dimension ON location_id = location_key)
  INNER JOIN Observation_Dimenstion ON observation_id = observation_key INNER JOIN Shape_Dimension
ON shape_key = shape_id
WHERE (state = 'CA' OR state = 'FL') AND weekend = 'Y' GROUP BY state, shape;
*/   