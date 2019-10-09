/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT *
FROM `Facilities`
WHERE Facilities.membercost >0
LIMIT 0 , 30

/* Q2: How many facilities do not charge a fee to members? */
SELECT COUNT(Facilities.membercost)
FROM `Facilities`
WHERE Facilities.membercost =0



/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT 	Facilities.facid as facid, 
		Facilities.name as  name,
		Facilities.membercost as membercost,
		Facilities.monthlymaintenance as monthlymaintenance

FROM `Facilities`

WHERE  membercost<(0.2*monthlymaintenance)

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
SELECT 	*

FROM `Facilities`

WHERE Facilities.facid IN (1,5)


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT	Facilities.name as name,
		Facilities.monthlymaintenance as monthlymaintenance,


CASE WHEN monthlymaintenance > 100 THEN 'expensive'
		ELSE 'cheap' END AS is_expensive_or_cheap

FROM `Facilities`

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT  Members.firstname as firstname,
	    Members.surname as lastname,
		Members.joindate as joindate
FROM `Members`

Group BY Members.joindate DESC

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */


SELECT CONCAT(Members.firstname,' ',Members.surname) AS name,

	   CASE WHEN Bookings.facid = 0 THEN 'Tennis Court 1' 
	   ELSE 'Tennis Court 2' END AS Facility_Name
	   



FROM Members

JOIN Bookings

ON 	 Members.memid = Bookings.memid

WHERE Bookings.facid IN (0,1) 


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT  Facilities.name AS Facility_name,
		
		CONCAT(Members.firstname,' ',Members.surname) AS Name_of_Member, 

		CASE WHEN Bookings.memid =0 THEN  Facilities.guestcost * 2 * Bookings.slots
		ELSE Facilities.membercost * 2 * Bookings.slots END AS cost 


		From Bookings
		JOIN Facilities
		ON Bookings.facid= Facilities.facid AND Bookings.starttime like '2012-09-14%'

		JOIN Members 
		ON Bookings.memid= Members.memid 


WHERE  (CASE WHEN Bookings.memid =0 THEN  Facilities.guestcost * 2 * Bookings.slots
		ELSE Facilities.membercost * 2 * Bookings.slots END )>30
		

ORDER BY cost DESC 




/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT *


FROM
	( SELECT 
     
     	Facilities.name AS Facility_name,
		
		CONCAT(Members.firstname,' ',Members.surname) AS Name_of_Member,
    
    	 CASE WHEN Bookings.memid = 0 THEN  2*Facilities.guestcost*Bookings.slots
         ELSE 2* Facilities.membercost*Bookings.slots END AS cost
                      
         FROM Bookings 
         JOIN Facilities 
         ON Bookings.facid = Facilities.facid  AND Bookings.starttime like '2012-09-14%'
     
     	 JOIN Members 
		 ON Bookings.memid= Members.memid 
    
    ) sub

WHERE sub.cost >30

ORDER BY cost DESC 
 
		

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT sub.Facility_name,
	   SUM(sub.cost) AS total_revenue

FROM
	( SELECT 
     
     	 Facilities.name AS Facility_name,
		
    
    	 CASE WHEN Bookings.memid = 0 THEN  2*Facilities.guestcost*Bookings.slots
         ELSE 2* Facilities.membercost*Bookings.slots END AS cost
                      
         FROM Bookings 
         JOIN Facilities 
         ON Bookings.facid = Facilities.facid  AND Bookings.starttime like '2012-09-14%'
     
     	 JOIN Members 
		 ON Bookings.memid= Members.memid 
    
    ) sub


GROUP BY sub.Facility_name
HAVING total_revenue <1000
ORDER BY total_revenue 
 